ESX = exports.es_extended:getSharedObject()
local ped = nil
local IsPanelOpen = false
local lib = exports.ox_lib
local Containerprop = {}

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
                    ESX.TriggerServerCallback('Lynx_Containerrobbery:GetXpLevel', function(xplevel)
                        if xplevel then
                            SendNUIMessage({
                                action = 'open',
                                list = ContainerData,
                                xp = xplevel
                            })
                            IsPanelOpen = not IsPanelOpen
                            SetNuiFocus(IsPanelOpen, IsPanelOpen)
                        end
                    end)
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

RegisterNUICallback('StartQuest', function(data, cb)
    local Container = Config.Container[data.id]
    ESX.TriggerServerCallback('Lynx_Containerrobbery:GetXpLevel', function(xplevel)
        if xplevel >= Container.xp then
            cb({ success = true, message = 'Quest started successfully.' })
            TriggerServerEvent('Lynx_Containerrobbery:StartQuest', data.id)
        else
            cb({ success = false, message = 'You do not have enough XP to start this quest.' })
        end
    end)
end)

RegisterNetEvent('Lynx_Containerrobbery:StartQuest', function(id)
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
        table.insert(Containerprop, prop)

        exports.ox_target:addLocalEntity(prop, {
            label = 'Search Container',
            name = 'lynx_containerrobbery:searchcontainer' .. cid,
            icon = 'fas fa-search',
            distance = 2.0,
            debug = true,
            onSelect = function(data)
                local success = lib.skillCheck(v.difficulty, { 'w', 'a', 's', 'd' })
                if success then
                    if lib.ProgressCircle({
                            duration = 10000, -- 10 seconds
                            label = 'Searching Container...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                                mouse = false
                            },
                            anim = {
                                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                                clip = 'machinic_loop_mechandplayer'
                            }
                        }) then
                        ESX.ShowNotification('You searched the container and found some loot!')

                        local addXp = true

                        for k, v in pairs(Containerprop) do
                            if DoesEntityExist(v) then
                                addXp = false
                                break
                            end
                        end

                        if addXp then
                            TriggerServerEvent('Lynx_Containerrobbery:AddXp', id, Container.xpadd)
                        end

                        TriggerServerEvent('Lynx_Containerrobbery:GiveLoot', cid, id, item)
                        DeleteEntity(prop)
                        RemoveBlip(blip)
                    end
                end
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
    for _, container in ipairs(Containerprop) do
        if container ~= nil then
            DeleteEntity(container)
        end
    end
end)
