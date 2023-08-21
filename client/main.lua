RegisterNetEvent('garage:retrieveFromImpoundResponse')
AddEventHandler('garage:retrieveFromImpoundResponse', function(success, v, impound)
    if success then
        ImpoundSpawnVehicle(v.vehicle, impound)
        RageUI.CloseAll()
    else
        ESX.ShowNotification(Locales[Config.lang]['not_enough_money'])
        RageUI.CloseAll()
    end
end)

RMenu.Add('garage', 'retrieve_vehicle', RageUI.CreateMenu(Locales[Config.lang]["garage_name"], Locales[Config.lang]["garage_desc"], Config.menu_settings.x, Config.menu_settings.y))
RMenu:Get('garage', 'retrieve_vehicle'):SetRectangleBanner(Config.menu_settings.themeColor.r, Config.menu_settings.themeColor.g, Config.menu_settings.themeColor.b, Config.menu_settings.themeColor.a)
RMenu.Add('impound', 'retrieve_vehicles', RageUI.CreateMenu(Locales[Config.lang]["impound_name"], Locales[Config.lang]["impound_desc"], Config.menu_settings.x, Config.menu_settings.y))
RMenu:Get('impound', 'retrieve_vehicles'):SetRectangleBanner(Config.menu_settings.themeColor.r, Config.menu_settings.themeColor.g, Config.menu_settings.themeColor.b, Config.menu_settings.themeColor.a)

local ESX = nil
local isGarageMenuOpen = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
end)

-- Displaying blips on map for garages and impounds
Citizen.CreateThread(function()
    for _, garage in pairs(Config.garage_settings) do
        local blip = AddBlipForCoord(garage.output.x, garage.output.y, garage.output.z)
        SetBlipSprite(blip, Config.blips_settings.garage.blip)
        SetBlipScale(blip, Config.blips_settings.garage.scale)
        SetBlipColour(blip, Config.blips_settings.garage.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        if Config.blips_settings.blips_list then
            AddTextComponentString(Config.blips_settings.blips_name_garage)
        else
            AddTextComponentString(garage.name)
        end
        EndTextCommandSetBlipName(blip)
    end

    for _, impound in pairs(Config.impound_settings) do
        local blip = AddBlipForCoord(impound.output.x, impound.output.y, impound.output.z)
        SetBlipSprite(blip, Config.blips_settings.impound.blip)
        SetBlipScale(blip, Config.blips_settings.impound.scale)
        SetBlipColour(blip, Config.blips_settings.impound.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        if Config.blips_settings.blips_list then
            AddTextComponentString(Config.blips_settings.blips_name_impound)
        else
            AddTextComponentString(impound.name)
        end
        EndTextCommandSetBlipName(blip)
    end
end)


-- Displaying markers for garages and impounds
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)

        -- Marker for storing the vehicle
        for _, garage in pairs(Config.garage_settings) do
            local distance = GetDistanceBetweenCoords(playerCoords, garage.input.x, garage.input.y, garage.input.z, true)
            if distance < Config.marker_settings.radius then
                DrawMarker(Config.marker_settings.input.marker_id, garage.input.x, garage.input.y, garage.input.z + Config.marker_settings.input.calibration, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 0.5, Config.marker_settings.input.color.r, Config.marker_settings.input.color.g, Config.marker_settings.input.color.b, Config.marker_settings.input.color.a, false, true, 2, false, false, false, false)
                
                if distance < Config.marker_settings.distance and isInVehicle then
                    DisplayHelpText(Locales[Config.lang]["input_store"])
                    if IsControlJustReleased(0, Config.keyboard) then
                        StoreVehicle(garage)
                    end
                end
            end
        end

        -- Marker for retrieving the vehicle
        for _, garage in pairs(Config.garage_settings) do
            local distance = GetDistanceBetweenCoords(playerCoords, garage.output.x, garage.output.y, garage.output.z, true)
            if distance < Config.marker_settings.radius then
                DrawMarker(Config.marker_settings.output.marker_id, garage.output.x, garage.output.y, garage.output.z + Config.marker_settings.output.calibration, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 0.5, Config.marker_settings.output.color.r, Config.marker_settings.output.color.g, Config.marker_settings.output.color.b, Config.marker_settings.output.color.a, false, true, 2, false, false, false, false)
                
                if distance < Config.marker_settings.distance and not isMenuOpen then
                    DisplayHelpText(Locales[Config.lang]["input_retrieve"])
                    if IsControlJustReleased(0, Config.keyboard) then
                        isGarageMenuOpen = true
                        MenuRetrieveVehicle(garage)
                    end
                elseif distance > Config.marker_settings.distance then
                    isGarageMenuOpen = false
                    RageUI.CloseAll()
                end
            end
        end

        -- Marker for retrieving from impound
        for _, impound in pairs(Config.impound_settings) do
            local distance = GetDistanceBetweenCoords(playerCoords, impound.output.x, impound.output.y, impound.output.z, true)
            if distance < Config.marker_settings.radius then
                DrawMarker(Config.marker_settings.impound.marker_id, impound.output.x, impound.output.y, impound.output.z + Config.marker_settings.impound.calibration, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 0.5, Config.marker_settings.impound.color.r, Config.marker_settings.impound.color.g, Config.marker_settings.impound.color.b, Config.marker_settings.impound.color.a, false, true, 2, false, false, false, false)

                if distance < Config.marker_settings.distance then
                    DisplayHelpText(Locales[Config.lang]["input_impound"])
                    if IsControlJustReleased(0, Config.keyboard) then
                        OpenImpoundMenu(impound)
                    end
                elseif distance > Config.marker_settings.distance then
                    RageUI.CloseAll()
                end
            end
        end
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function StoreVehicle(garage)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(vehicle)
    if vehicle and DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
    end
    if vehicle and vehicle ~= 0 then
        TriggerServerEvent('garage:storeVehicle', plate, garage.name)
    else
        ESX.ShowNotification(Locales[Config.lang]["error_vehicle"])
    end
end

function GetVehicleDisplayName(model)
    return GetLabelText(GetDisplayNameFromVehicleModel(model))
end

function GarageSpawnVehicle(vehicle, garage)
    local coords = garage.spawn
    ESX.Game.SpawnVehicle(vehicle.model, coords, garage.heading, function(spawnedVehicle)
        ESX.Game.SetVehicleProperties(spawnedVehicle, vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), spawnedVehicle, -1)
        TriggerServerEvent('garage:retrieveVehicle', GetVehicleNumberPlateText(spawnedVehicle))
    end)
end

function ImpoundSpawnVehicle(vehicle, impound)
    local coords = impound.spawn
    ESX.Game.SpawnVehicle(vehicle.model, coords, impound.heading, function(spawnedVehicle)
        ESX.Game.SetVehicleProperties(spawnedVehicle, vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), spawnedVehicle, -1)
        GetVehicleNumberPlateText(spawnedVehicle)
    end)
end

function MenuRetrieveVehicle(garage)
    ESX.TriggerServerCallback('garage:getOwnedVehicles', function(vehicles)
        RageUI.Visible(RMenu:Get('garage', 'retrieve_vehicle'), not RageUI.Visible(RMenu:Get('garage', 'retrieve_vehicle')))

        Citizen.CreateThread(function()
            while RageUI.Visible(RMenu:Get('garage', 'retrieve_vehicle')) do
                Citizen.Wait(0)

                RageUI.IsVisible(RMenu:Get('garage', 'retrieve_vehicle'), true, true, true, function()
                    for _, vehicle in ipairs(vehicles) do
                        local vehicleName = GetVehicleDisplayName(vehicle.vehicle.model)
                        if vehicle.park == true and vehicle.impound == false then
                            RageUI.ButtonWithStyle(vehicleName .. " [~o~" .. vehicle.plate .. "~s~]", Locales[Config.lang]["retrieve_vehicle"], {RightLabel = "~b~>>>"}, true, function(_, _, Selected)
                                if Selected then
                                    GarageSpawnVehicle(vehicle.vehicle, garage)
                                    RageUI.CloseAll()
                                    isMenuOpen = false
                                end
                            end)
                        elseif vehicle.park == false and vehicle.impound == true then
                            RageUI.ButtonWithStyle(vehicleName .. " [~o~" .. vehicle.plate .. "~s~]", Locales[Config.lang]["vehicle_is_impounded"], {RightLabel = Locales[Config.lang]["vehicle_impounded"]}, true)
                        else RageUI.ButtonWithStyle(vehicleName .. " [~o~" .. vehicle.plate .. "~s~]", Locales[Config.lang]["vehicle_is_retrieved"], {RightLabel = Locales[Config.lang]["vehicle_retrieved"]}, true)
                        end
                    end
                end)
            end
        end)
    end)
end


local function DeleteVehicleByPlate(plate)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.radius)
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehiclePlate = GetVehicleNumberPlateText(vehicle):gsub("%s+", "")
            if vehiclePlate == plate:gsub("%s+", "") then
                ESX.Game.DeleteVehicle(vehicle)
                break
            end
        end
    end
end

function OpenImpoundMenu(impound)
    ESX.TriggerServerCallback('garage:getOwnedVehicles', function(vehicles)
        RageUI.Visible(RMenu:Get('impound', 'retrieve_vehicles'), not RageUI.Visible(RMenu:Get('impound', 'retrieve_vehicles')))
        local shouldBreak = false
        Citizen.CreateThread(function()
            while RageUI.Visible(RMenu:Get('impound', 'retrieve_vehicles')) do
                Citizen.Wait(0)

                RageUI.IsVisible(RMenu:Get('impound', 'retrieve_vehicles'), true, true, true, function()
                    for _, v in ipairs(vehicles) do
                        local vName = GetVehicleDisplayName(v.vehicle.model)
                        if v.park == false and v.impound == false then
                            RageUI.ButtonWithStyle(vName .. " [~o~" .. v.plate .. "~s~]", Locales[Config.lang]["select_to_impound"], {RightLabel = Locales[Config.lang]["impound_vehicle"]}, true, function(_, _, selected)
                                if selected then
                                    DeleteVehicleByPlate(v.plate)
                                    TriggerServerEvent('garage:impoundVehicle', v.plate)
                                    RageUI.CloseAll()
                                end
                            end)
                        end
                        if v.impound == true then
                            RageUI.ButtonWithStyle(vName .. " [~o~" .. v.plate .. "~s~]", Locales[Config.lang]["pay_impound"].. Config.impound_price .. "~s~ "  .. Config.currency, {RightLabel = "~r~>>>"}, true, function(_, _, selected)
                                if selected then
                                    TriggerServerEvent('garage:retrieveFromImpound', v.plate, v, impound)
                                end
                            end)
                        end
                    end
                end)
                if shouldBreak then
                    break
                end
            end
        end)
    end)
end

