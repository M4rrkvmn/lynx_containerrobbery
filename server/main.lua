function LynxAntiCheatSecurity(source)
    
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

local MySQL = exports.ghmattimysql

ESX.RegisterServerCallback('Lynx_Containerrobbery:GetXpLevel', function(src, cb, param1, param2)
    cb(MySQL.Sync.fetchScalar('SELECT xp FROM Lynx_Containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = ESX.GetPlayerData().identifier
    }))
end)

RegisterNetEvent('Lynx_Containerrobbery:Giveloot', function(cid, id, loot)
    local xPlayer = ESX.GetPlayerFromId(source)
    local addItem = true
    if not xPlayer then return end

    for _, v in ipairs(loot) do
        for _, lv in ipairs(Config.Container[id].container[cid].loot) do
            if v.item ~= lv.item and v.count ~= lv.count then
                addItem = false
                break
            end
        end

    end

    if addItem then
        for _, v in ipairs(loot) do
            xPlayer.addInventoryItem(v.item, v.count)
        end
    else
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.identifier)
        --Security measure to prevent exploits, you can log this or take action against the player
    end

    MySQL.Async.execute('UPDATE Lynx_Containerrobbery SET xp = xp + @xp WHERE identifier = @identifier', {
        ['@xp'] = Config.Container[id].xpadd,
        ['@identifier'] = xPlayer.identifier
    })
end)
