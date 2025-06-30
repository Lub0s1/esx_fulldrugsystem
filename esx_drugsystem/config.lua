Config = {}

Config.Drugs = {
    weed = {
        collect = vector3(2214.6770, 5576.9912, 53.7290),
        process = vector3(2320.0, 2900.0, 50.0),
        sell = vector3(150.0, -1800.0, 28.0),
        item_raw = "weed_leaf",
        item_processed = "weed_pooch",
        price = {min = 1000, max = 1300},
        label = "Spracovaná marihuana"
    },
    coke = {
        collect = vector3(1713.1533, -1555.7445, 113.9421),
        process = vector3(894.7654, -891.6626, 27.1586),
        sell = vector3(-470.2598, -1717.9167, 18.6891),
        item_raw = "coca_leaf",
        item_processed = "coke_pooch",
        price = {min = 1300, max = 1500},
        label = "Spracovaný kokaín"
    },
    meth = {
        collect = vector3(1391.0, 3605.0, 38.9),
        process = vector3(2438.8547, 4976.1484, 46.8106),
        sell = vector3(-330.9865, -2778.8303, 5.1451),
        item_raw = "meth_raw",
        item_processed = "meth_pooch",
        price = {min = 1500, max = 1700},
        label = "Spracovaný metamfetamín"
    },
    opium = {
        collect = vector3(1972.0, 3819.0, 33.5),
        process = vector3(1977.9426, 3819.4822, 33.45),
        sell = vector3(-72.3977, -1821.6471, 26.9419),
        item_raw = "opium_leaf",
        item_processed = "opium_pooch",
        price = {min = 1700, max = 2000},
        label = "Spracovaný ópium"
    }
}

Config.SellToNPC = true
Config.PoliceAlertChance = 30
Config.CooldownTime = 5000 -- ms