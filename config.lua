Config = {} 

Config = {
    keyboard = 38,
    lang = 'fr', -- langage you want to use : en / fr
    currency = '$', -- currency used in menu
    impound_price = 500, -- impound price to get back the vehicle
    radius = 50000, -- radius in GTA V meter to search and delete current existing vehicle // Anti duplication system
    server_settings = {
        vehicles_table = 'owned_vehicles', -- table name where vehicle's players are stocked in database
        identifier_column = 'owner', -- column name of the identifier from the vehicles table
    },
    menu_settings = {
        x = 10,
        y = 20,
        width = 100,
        height = 100,
        themeColor = { r = 241, g = 194, b = 50, a = 255 }, -- rgb, a = opacity
        bannerType = "Color", -- "color" or "custom" /// custom COMING SOON
        logoCustom = nil -- /// COMING SOON
    },
    blips_settings = {
        blips_name_garage = 'Garage Public', -- only avaible if blip_list is enable
        blips_name_impound = 'Fourrière Public', -- only avaible if blip_list is enable
        blips_list = true, -- if you want to have just one blips display on the right side of your map menu - all garage blips will be have the same name put true, else put false
        garage = {blip = 357, scale = 0.6, color = 11},
        impound = {blip = 477, scale = 0.6, color = 17}
    },
    marker_settings = { -- the calibration of the marker can be used to set a specific height (Z axe)
        radius = 10,
        distance = 1.5,
        input = { marker_id = 25, color = { r = 255, g = 0, b = 0, a = 250}, calibration = -1}, -- marker to put vehicle in the garage if you are in vehicle
        output = { marker_id = 25, color = { r = 70, g = 150, b = 250, a = 250}, calibration = -1}, -- marker to retrieve vehicle in the garage if you are not in vehicle
        impound = { marker_id = 25, color = { r = 254, g = 133, b = 12, a = 200}, calibration =  -1}, -- marker to retrieve vehicle from impound
    },
    garage_settings = {
        parking_central = {
            name = 'Parking Central', -- name of the garage place
            input = { x = 216.2807, y = -788.7216, z = 30.92271}, -- zone to put vehicle in the garage if you are in vehicle
            output = { x = 217.2807, y = -788.7216, z = 30.92271, h = 255}, -- zone to retrieve vehicle in the garage if you are not in vehicle
            spawn = { x = 217.2807, y = -788.7216, z = 30.92271, h = 255}, -- zone where the vehicle spawn
        },
        job_center = {
            name = 'Job-Center Parking', -- name of the garage place
            input = { x = -293.2807, y = -887.7216, z = 31.08271}, -- zone to put vehicle in the garage if you are in vehicle
            output = { x = -292.69, y = -891.28, z = 31.08, h = 80.00}, -- zone to retrieve vehicle in the garage if you are not in vehicle
            spawn = { x = -292.69, y = -891.28, z = 31.08, h = 80.00},  -- zone where the vehicle spawn
        },
        la_mesa = {
            name = 'La Mesa', -- name of the garage place
            input = { x = 798.37, y = -811.86, z = 26.18}, -- zone to put vehicle in the garage if you are in vehicle
            output = { x = 806.87, y = -811.86, z = 26.18, h = 92.11}, -- zone to retrieve vehicle in the garage if you are not in vehicle
            spawn = { x = 799.17, y = -819.92, z = 26.18, h = 26.17},  -- zone where the vehicle spawn
        }
    }, 
    impound_settings = {
        davis = { 
            name = 'Davis Impound', -- name of the impound place
            output = { x = 408.81, y = -1638.95, z = 29.29, h = 230.79}, -- zone to retrieve vehicle from impound
            spawn = { x = 408.81, y = -1638.95, z = 29.29, h = 230.79},  -- zone where the vehicle spawn
        },
        la_mesa = { 
            name = 'La Mesa Impound', -- name of the impound place
            output = { x = 829.35, y = -813.01, z = 26.33, h = 90.08}, -- zone to retrieve vehicle from impound
            spawn = { x = 830.49, y = -803.64, z = 26.24, h = 357.08},  -- zone where the vehicle spawn
        }
    }, 
}