local VORPcore = exports.vorp_core:GetCore()

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

RegisterCommand(Config.AfkCommand, function(source, args, rawcommand)
    local src = source
    local Reason = args[1]
    if Config.Debug then print(rawcommand) end
    local FormatedTime = os.date("%H:%M")
    if Config.Debug then print(FormatedTime) print(Reason) end
    TriggerClientEvent('mms-afk:client:ShowAfkText',src,Reason,FormatedTime)
end)
