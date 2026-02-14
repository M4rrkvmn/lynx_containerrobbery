Config = {}

Config.NPCQuestPed = {
    pedModel = '',
    pedCoords = vector3(0,0,0),
    pedHeading = 0
}

Config.PoliceJob = {
    'police'
}

Config.Container = {
    [1] = {
        name = 'Kezdő Container',
        container = {
            [1] = {
                coords = vector3(0,0,0),
                heading = 0,
                model = 'prop_container_01a',
                loot = {
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },
}