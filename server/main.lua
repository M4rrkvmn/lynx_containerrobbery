local QuestActive = {}

if Config.OpenMenu == 'tablet' then
    ESX.RegisterUsableItem(Config.TabletItem, function(source)
       TriggerClientEvent('Lynx_Containerrobbery:OpenPanelwithTablet', source)
    end)
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
    local xplevel =MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier =?', {
         xPlayer.getIdentifier()
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
    if not QuestActive[source] then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.getIdentifier())
        LynxAntiCheatSecurity(source)
        return
    end

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
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local result = MySQL.Sync.fetchScalar('SELECT identifier FROM lynx_containerrobbery WHERE identifier =?', {
        xPlayer.getIdentifier()
    })

    if not result then
        MySQL.Sync.execute('INSERT INTO lynx_containerrobbery (identifier, xp) VALUES (?,?)', {
            xPlayer.getIdentifier(),
            0
        })
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:AddXp', function(id)
    local xp = Config.Container[id].xpadd
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if not xPlayer then return end

    if not QuestActive[_source] then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.getIdentifier())
        LynxAntiCheatSecurity(_source)
        return
    end

    local currentxp = MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier = ?', {
        xPlayer.getIdentifier()
    })

    local addXp = currentxp + xp

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
