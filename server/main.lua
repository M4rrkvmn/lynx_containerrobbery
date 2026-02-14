ESX.RegisterServerCallback('Lynx_Containerrobbery:PoliceJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local isPolice = false

    for _, v in ipairs(Config.PoliceJob) do
        if xPlayer.getJob().name == v then
            isPolice = true
        end
    end
    
    cb(isPolice)
end)

RegisterNetEvent('Lynx_Containerrobbery:SyncProp',function (action,prop)
    if action == 'create' then
        
    elseif action == 'delete' then

    end
end)