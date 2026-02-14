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
            ESX.TriggerServerCallback('Lynx_Containerrobbery:PoliceJob', function(IsPolice)
                if IsPolice then
                    SendNUIMessage({
                        action = 'open',
                        list = Config.Container
                    })
                    IsPanelOpen = not IsPanelOpen
                    SetNuiFocus(IsPanelOpen, IsPanelOpen)
                else
                    ESX.ShowNotification('You must be a police officer to access this.')
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

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    if ped ~= nil then
        DeleteEntity(ped)
        ped = nil
    end
end)
