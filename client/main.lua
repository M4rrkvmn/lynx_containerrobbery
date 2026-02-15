ESX = exports.es_extended:getSharedObject()
local ped = nil
local IsPanelOpen = false

CreateThread(function()
    local pm = Config.NPCQuestPed.pedModel
    local pc = Config.NPCQuestPed.pedCoords

    RequestModel(GetHashKey(pm))
    while HasModelLoaded(pm) do Wait(10) end

    ped = CreatePed(4, pm, pc.x, pc.y, pc.z, Config.NPCQuestPed.pedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        label = 'Container Robbery',
        name = 'lynx_containerrobbery:target',
        icon = 'fas fa-c',
        distance = 4.0,
        debug = true,
        onSelect = function(data)
            ESX.TriggerServerCallback('Lynx_Containerrobbery:PoliceJob', function(IsNotPolice)
                if IsNotPolice then
                    local ContainerData = {}
                    for i, v in ipairs(Config.Container) do
                        local diffculty = ''
                        if v.xp < 100 then
                            diffculty = 'Easy'
                        elseif v.xp < 500 then
                            diffculty = 'Medium'
                        else
                            diffculty = 'Hard'
                        end

                        local ContainerList = {
                            id = i,
                            name = v.name,
                            count = #v.container,
                            difficulty = diffculty,
                            xp = v.xp
                        }
                        table.insert(ContainerData, ContainerList)
                    end

                    SendNUIMessage({
                        action = 'open',
                        list = ContainerData
                    })
                    IsPanelOpen = not IsPanelOpen
                    SetNuiFocus(IsPanelOpen, IsPanelOpen)
                else
                    ESX.ShowNotification('You are not allowed to access this.')
                end
            end)
        end
    })
end)

RegisterNUICallback('ClosePanel', function(data, cb)
    SendNUIMessage({
        action = 'close'
    })
    IsPanelOpen = not IsPanelOpen
    SetNuiFocus(IsPanelOpen, IsPanelOpen)
    cb()
end)

RegisterNUICallback('StartQuest',function (data, cb)
    local Container = Config.Container[data.id]
    local xplevel = 0
    ESX.TriggerServerCallback('Lynx_Containerrobbery:GetXpLevel', function(xplevel)
        if xplevel ~= nil or xplevel ~= 0 then
            xplevel = xplevel
        end
    end)

    if xplevel < Container.xp then
        cb({success = false, message = 'You do not have enough XP to start this quest.'})
    else
        cb({success = true, message = 'Quest started successfully.'})
        TriggerServerEvent('Lynx_Containerrobbery:StartQuest', data.id)
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:StartQuest',function (id)
    local Container = Config.Container[id]

    for cid, v in ipairs(Container.container) do
        local item = {}
        for i, va in ipairs(v.loot) do
            local itemandcount = {
                item = va.item,
                count = va.count
            }
            table.insert(item, itemandcount)
        end
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)

        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Container Location')
        EndTextCommandSetBlipName(blip)

        RequestModel(GetHashKey(v.model))
        while HasModelLoaded(v.model) do Wait(10) end

        local prop = CreateObject(GetHashKey(v.model), v.coords.x, v.coords.y, v.coords.z, false, false, false)
        SetEntityHeading(prop, v.heading)

        exports.ox_target:addLocalEntity(prop, {
            label = 'Search Container',
            name = 'lynx_containerrobbery:searchcontainer',
            icon = 'fas fa-search',
            distance = 2.0,
            debug = true,
            onSelect = function(data)
                ESX.ShowNotification('You searched the container and found some loot!')
                

                TriggerServerEvent('Lynx_Containerrobbery:GiveLoot', cid, id, item)
                DeleteEntity(prop)
                RemoveBlip(blip)
            end
        })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    if ped ~= nil then
        DeleteEntity(ped)
        ped = nil
    end
end)
