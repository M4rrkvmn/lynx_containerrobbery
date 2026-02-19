ESX = exports.es_extended:getSharedObject()
local ped = nil
local IsPanelOpen = false
local Containerprop = {}
local QuestActive = false
local tabletModel = 'prop_cs_tablet'
local tabletprop = nil
local cooldown = nil

CreateThread(function()
    if Config.OpenMenu == 'pedModel' then
        local pm = Config.NPCQuestPed.pedModel
        local pc = Config.NPCQuestPed.pedCoords
        local modelHash = GetHashKey(pm)


        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(10) end

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
                            SendNUIMessage({
                                action = 'open',
                                list = ContainerData,
                                xp = xplevel
                            })
                            IsPanelOpen = not IsPanelOpen
                            SetNuiFocus(IsPanelOpen, IsPanelOpen)
                        end)
                    else
                        ESX.ShowNotification('You are not allowed to access this.')
                    end
                end)
            end
        })
    else
        RegisterNetEvent('Lynx_Containerrobbery:OpenPanelwithTablet', function()
            RequestModel(GetHashKey(tabletModel))
            while not HasModelLoaded(GetHashKey(tabletModel)) do Wait(10) end
            local ped = PlayerPedId()
            tabletprop = CreateObject(GetHashKey(tabletModel), 0, 0, 0, true, true, true)
            AttachEntityToEntity(tabletprop, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true,
                false,
                true,
                1, true)

            TaskPlayAnim(ped, 'amb@world_human_seat_wall_tablet@female@base', 'base', 8.0, -8.0, -1, 50, 0, false, false,false)

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
                        SendNUIMessage({
                            action = 'open',
                            list = ContainerData,
                            xp = xplevel
                        })
                        IsPanelOpen = not IsPanelOpen
                        SetNuiFocus(IsPanelOpen, IsPanelOpen)
                    end)
                else
                    ESX.ShowNotification('You are not allowed to access this.')
                end
            end)
        end)
    end
end)


RegisterNUICallback('ClosePanel', function(data, cb)
    SendNUIMessage({
        action = 'close'
    })
    IsPanelOpen = not IsPanelOpen
    SetNuiFocus(IsPanelOpen, IsPanelOpen)
    if tabletprop ~= nil then
        DeleteObject(tabletprop)
        tabletprop = nil
    end
    cb()
end)

RegisterNUICallback('StartQuest', function(data, cb)
    local Container = Config.Container[data.id]

    if QuestActive then
        cb({ success = false, message = 'You already have an active quest.' })
        return
    else
        ESX.TriggerServerCallback('Lynx_Containerrobbery:GetXpLevel', function(xplevel)
            if xplevel >= Container.xp then
                if GetGameTimer() < cooldown then
                    cb({ success = false, message = 'You are on cooldown.' })
                else
                    cb({ success = true, message = 'Quest started successfully.' })
                    TriggerServerEvent('Lynx_Containerrobbery:StartQuest', data.id)
                    QuestActive = true
                    cooldown = GetGameTimer() + 30000
                end
            else
                cb({ success = false, message = 'You do not have enough XP to start this quest.' })
            end
        end)
    end
end)

RegisterNUICallback('BreakingQuest', function(data, cb)
    QuestActive = false
    for _, v in ipairs(Containerprop) do
        DeleteEntity(v)
    end
    Containerprop = {}
    cooldown = GetGameTimer() + 30000 -- 30 second cooldown after breaking a container, adjust as needed

    cb({ success = true })
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

        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(v.model) do Wait(10) end

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
                    TriggerServerEvent('Lynx_Containerrobbery:StartContainerRobberyBlip', id, cid)
                    if lib.progressCircle({
                            duration = 2000, -- 1 minute
                            position = 'bottom',
                            label = 'Breaking Container...',
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
                            } }) then
                        ESX.ShowNotification('You searched the container and found some loot!')

                        local addXp = true

                        TriggerServerEvent('Lynx_Containerrobbery:Giveloot', cid, id, item)
                        DeleteEntity(prop)
                        for k, v in pairs(Containerprop) do
                            if DoesEntityExist(v) then
                                addXp = false
                                break
                            end
                        end
                        if addXp then
                            TriggerServerEvent('Lynx_Containerrobbery:AddXp', id)
                            QuestActive = false
                            SendNUIMessage({
                                action = 'resetbutton',
                                id = id
                            })
                        end
                    end
                end
            end
        })
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:AddRobberyBlip', function(id, cid)
    local Containers = Config.Container[id].container[cid]
    local blip = AddBlipForCoord(Containers.coords.x, Containers.coords.y, Containers.coords.z)
    ESX.ShowNotification('A container robbery has started! Check your map for the location.')

    SetBlipSprite(blip, 161)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Ongoing Container Robbery')
    EndTextCommandSetBlipName(blip)

    Wait(60000) -- Blip lasts for 1 minute, you can adjust this as needed
    RemoveBlip(blip)
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
    if tabletprop ~= nil then
        DeleteObject(tabletprop)
        tabletprop = nil
    end
end)
