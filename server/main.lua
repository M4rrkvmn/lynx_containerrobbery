local QuestActive = {}

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


ESX.RegisterServerCallback('Lynx_Containerrobbery:PoliceJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local IsNotPolice = true

    for _, v in ipairs(Config.PoliceJob) do
        if xPlayer.getJob().name == v then
            IsNotPolice = false
        end
    end

    cb(IsNotPolice)
end)

ESX.RegisterServerCallback('Lynx_Containerrobbery:GetXpLevel', function(src, cb, param1, param2)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local xplevel =MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    })
    cb(xplevel)
end)

RegisterNetEvent('Lynx_Containerrobbery:StartQuest',function (id)
    local src = source
    QuestActive[src] = id
    TriggerClientEvent('Lynx_Containerrobbery:StartQuest', src, id)
end)

RegisterNetEvent('Lynx_Containerrobbery:StartContainerRobberyBlip', function(id,cid)
    for _, players in pairs(ESX.GetPlayers()) do
        local xPlayers = ESX.GetPlayerFromId(players)
        for _, v in ipairs(Config.PoliceJob) do
            if xPlayers.getJob().name == v then
                TriggerClientEvent('Lynx_Containerrobbery:AddRobberyBlip', players,id,cid)
            end
        end
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:Giveloot', function(cid, id, loot)
    local xPlayer = ESX.GetPlayerFromId(source)
    local addItem = true
    if not xPlayer then return end
    TriggerClientEvent('esx:showNotification', source, 'Processing container loot...')
    if not QuestActive[source] then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.getIdentifier())
        LynxAntiCheatSecurity(source)
        return
    end

    TriggerClientEvent('esx:showNotification', source, 'Processing container loot2...')
    for _, v in ipairs(loot) do
        for _, lv in ipairs(Config.Container[id].container[cid].loot) do
            if v.item ~= lv.item and v.count ~= lv.count then
                addItem = false
            else
                addItem = true
            end
        end
    end

    local item = ''

    TriggerClientEvent('esx:showNotification', source, 'Processing container loot3...')
    if addItem then
        for _, v in ipairs(loot) do
            item = item .. v.item .. ' [' .. v.count .. '], '
            xPlayer.addInventoryItem(v.item, v.count)
            TriggerClientEvent('esx:showNotification', source, 'You received ' .. v.count .. 'x ' .. v.item)
        end
    else
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.getIdentifier())
        LynxAntiCheatSecurity(source)
    end

    LynxLogSecurity('Name: ' ..
    GetPlayerName(source) ..
    '\nIdentifier:' .. xPlayer.getIdentifier() .. '\nAction: Completed Container Quest\nItem: ' .. item .. '')
end)

RegisterCommand('getIdentifier', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    TriggerClientEvent('esx:showNotification', source, xPlayer.getIdentifier())
end,false)

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local result = MySQL.Sync.fetchScalar('SELECT identifier FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    })

    if not result then
        MySQL.Sync.execute('INSERT INTO lynx_containerrobbery (identifier, xp) VALUES (@identifier, @xp)', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@xp'] = 0
        })
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:AddXp', function(id)
    local xp = Config.Container[id].xpadd
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    TriggerClientEvent('esx:showNotification', _source, 'Processing XP...')
    if not QuestActive[_source] then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.getIdentifier())
        LynxAntiCheatSecurity(_source)
        return
    end

    local currentxp = MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    })

    local addXp = currentxp + xp

    TriggerClientEvent('esx:showNotification', _source, 'Processing XP2...'.. currentxp .. 'XP to add: ' .. xp .. ' Total XP: ' .. addXp)


    MySQL.Sync.execute('UPDATE lynx_containerrobbery SET xp = ? WHERE identifier = ?', {
         addXp,
         xPlayer.getIdentifier()
    })

    QuestActive[_source] = nil
    LynxLogSecurity('Name: ' ..
    GetPlayerName(_source) ..
    '\nIdentifier:' .. xPlayer.getIdentifier() .. '\nAction: Gained XP\nCurrent XP: ' .. currentxp .. '\nXP Added: ' .. xp ..
    '')
end)
