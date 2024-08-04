local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-afk/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

--- Get Player Data

RegisterServerEvent('mms-afk:server:getplayerdata',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local group = Character.group
    TriggerClientEvent('mms-afk:client:recieveuserdata',src,group)
end)

RegisterServerEvent('mms-afk:server:kickplayer',function ()
    local src = source
    DropPlayer(src,_U('KickReason'))
end)

RegisterServerEvent('mms-afk:server:SendWebhook',function (Webhook)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local firstname = Character.firstname
    local lastname = Character.lastname
    if firstname and lastname ~= nil then
        if Webhook == 1 then
            if Config.WebHook then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,firstname .. ' ' .. lastname .. _U('WebhookFirstWarning'), Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        elseif Webhook == 2 then
            if Config.WebHook then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,firstname .. ' ' .. lastname .. _U('WebhookSecoundWarning'), Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        elseif Webhook == 3 then
            if Config.WebHook then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,firstname .. ' ' .. lastname .. _U('WebhookThirdWarning'), Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        elseif Webhook == 4 then
            if Config.WebHook then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,firstname .. ' ' .. lastname .. _U('WebhookKick'), Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        end
    end
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()