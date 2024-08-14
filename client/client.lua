local VORPcore = exports.vorp_core:GetCore()

local Timer = 0
local Webhook = 0
---------------------------------------------------------------------------------

RegisterCommand(Config.NotAfkCommand, function()
    Timer = 0
    Webhool = 0
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
    Citizen.Wait(Config.WaitTime *1000)
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
        Citizen.Wait(20)
        NewCoords = GetEntityCoords(MyChar)
        Citizen.Wait(1000)
        if MyCoords == NewCoords then
            Timer = Timer + 1
        elseif MyCoords ~= NewCoords then
            Timer = 0
            Webhook = 0
        end
        if Timer == Config.FirstWarningTimer then
            Webhook = Webhook +1
            VORPcore.NotifyCenter(_U('FirstAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.SecoundWarningTimer then
            Webhook = Webhook +1
            VORPcore.NotifyCenter(_U('SecoundAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.LastWarningTimer then
            Webhook = Webhook +1
            VORPcore.NotifyCenter(_U('ThirdAfkWarning'),5000)
            TriggerServerEvent('mms-afk:server:SendWebhook',Webhook)
        elseif Timer == Config.KickTimer then
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