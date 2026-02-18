function LynxLogSecurity(message)
    if not Config.Webhook then return end
    local text = {
        {
            ["color"] = 16711680,
            ["title"] = "**LYNX CONTAINER ROBBERY [SECURITY LOG]**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Lynx Container Robbery | " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST',json.encode({embeds = text }), { ['Content-Type'] = 'application/json' })
end

function LynxAntiCheatSecurity(source, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.kick(
        'LYNX ANTI CHEAT\nYou have been kicked for suspected cheating. If you believe this is a mistake, please contact support.')
    LynxLogSecurity(message)

    --Set Ban system here if you have one, you can use the identifier to ban the player from your server
end