local VORPcore = exports.vorp_core:GetCore()

local Timer = 0
local Webhook = 0
local ImAfk = false

local Text = nil
local Time = nil
---------------------------------------------------------------------------------

RegisterCommand(Config.NotAfkCommand, function()
    Timer = 0
    Webhook = 0
    VORPcore.NotifyTip(_U('NotAFK'),4000)
end)

if Config.Debug then
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        TriggerServerEvent('mms-afk:server:getplayerdata')
    end)
end

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(Config.WaitTime * 60000)
    TriggerServerEvent('mms-afk:server:getplayerdata')
end)

RegisterNetEvent('mms-afk:client:recieveuserdata')
AddEventHandler('mms-afk:client:recieveuserdata',function(group)
    --- CHECK IF ADMIN IGNORED BY AFK
    if group == Config.AdminGroup and Config.IgnoreAdmins then
        Citizen.Wait(5000)
        if Config.Debug then
            print(group)
            print(Config.AdminGroup)
        end
    else
        Citizen.Wait(5000)
        TriggerEvent('mms-afk:client:startafktimer')
    end
end)


RegisterNetEvent('mms-afk:client:startafktimer')
AddEventHandler('mms-afk:client:startafktimer',function()
    while true do
        local MyChar = PlayerPedId()
        MyCoords = GetEntityCoords(MyChar)
        Citizen.Wait(250)
        NewCoords = GetEntityCoords(MyChar)
        Citizen.Wait(10000)
        if MyCoords == NewCoords then
            Timer = Timer + 10000
        elseif MyCoords ~= NewCoords then
            Timer = 0
            Webhook = 0
        end
        if Timer == Config.FirstWarningTimer * 60000 then
            Webhook = Webhook + 1
            VORPcore.NotifyCenter(_U('FirstAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.SecoundWarningTimer * 60000 then
            Webhook = Webhook +1
            VORPcore.NotifyCenter(_U('SecoundAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.LastWarningTimer * 60000 then
            Webhook = Webhook +1
            VORPcore.NotifyCenter(_U('ThirdAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.KickTimer * 60000 then
            Webhook = Webhook +1
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
            Citizen.Wait(100)
            TriggerServerEvent('mms-afk:server:kickplayer')
        end
        if Config.Debug then
            print(Timer)
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(15000)
        if IsNuiFocused() then
            Timer = 0
            Webhook = 0
        end
    end
end)

RegisterNetEvent('mms-afk:client:ShowAfkText')
AddEventHandler('mms-afk:client:ShowAfkText',function(Reason,FormatedTime)
    if ImAfk then
        ImAfk = false
        if Config.SetAFKPlayerGodmode then
            SetEntityInvincible(PlayerPedId(),false)
        end
        if Config.FreezeAFKPlayer then
            FreezeEntityPosition(PlayerPedId(),false)
        end
        if Config.SetEntityGhost then
            SetEntityAlpha(PlayerPedId(),255)
        end
    else
        ImAfk = true
        Text = Reason
        Time = FormatedTime
        if Config.SetAFKPlayerGodmode then
            SetEntityInvincible(PlayerPedId(),true)
        end
        if Config.FreezeAFKPlayer then
            FreezeEntityPosition(PlayerPedId(),true)
        end
        if Config.SetEntityGhost then
            SetEntityAlpha(PlayerPedId(),Config.GhostAlpha)
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        Citizen.Wait(sleep)
        while ImAfk do
            Citizen.Wait(3)
            local MyPed = PlayerPedId()
            local MyPos = GetEntityCoords(MyPed)
            DrawText3D(MyPos.x, MyPos.y, MyPos.z + Config.TextOffset +0.13 , _U('AFKSince') .. Time, Config.TextColor)
            if Text ~= nil then
                DrawText3D(MyPos.x, MyPos.y, MyPos.z + Config.TextOffset, _U('AFKReason') .. Text, Config.TextColor)
            else
                Text = _U('NoReason')
                DrawText3D(MyPos.x, MyPos.y, MyPos.z + Config.TextOffset, _U('AFKReason') .. Text, Config.TextColor)
            end
        end
    end
end)

-- DrawText3D Function

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(Config.Scale, Config.Scale)
        SetTextFontForCurrentCommand(Config.Textfont)
        SetTextColor(color[1], color[2], color[3], 255)
        SetTextCentre(1)
        DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
    end
end