Config = {}

Config.NPCQuestPed = {
    pedModel = 'a_m_m_afriamer_01',
    pedCoords = vector3(224.6401, -863.3003, 30.2922),
    pedHeading = 344.8
}

Config.PoliceJob = {
    'police'
}

Config.OpenMenu = 'tablet' -- 'tablet' item or 'pedModel'
Config.TabletItem = 'tablet' -- Item to Open Menu if OpenMenu is set to 'tablet'

Config.Webhook = 'https://discord.com/api/webhooks/1473708160589103399/j5tvoZxh7xPN7SYy9DazNAdhjiKcI16sr36FPox00lL-FPvoK1GmGHADbsPNd5KUuDNE' -- Webhook for Security Logs, you can use this to log possible exploits or cheaters

Config.Container = {
    [1] = {
        name = 'Full Kezdő Container',
        xp = 0, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy', 'easy'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [2] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [3] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [4] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [5] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [6] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },

    [7] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(233.9793, -867.6003, 30.2922),
                heading =  330.1001,
                model = 'prop_container_01a',
                difficulty = {'easy','medium','medium'}, -- For minigame
                loot = { -- Items to Give on Container break 
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },
}