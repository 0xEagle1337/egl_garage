
local ESX = nil

ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('egl_garage:getOwnedVehicles', function(source, cb, garageName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    local vehicles = {}
    local query = ("SELECT * FROM %s WHERE %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)

    MySQL.Async.fetchAll(query, {
        ['@identifier'] = identifier
    }, function(result)
        for _, v in ipairs(result) do
            local vehicle = json.decode(v.vehicle)
            local impound = v.impound
            local deformation = json.decode(v.deformation)
            table.insert(vehicles, {plate = v.plate, model = v.model, vehicle = vehicle, park = v.park, impound = impound, ehealth = v.engine_health, bhealth = v.body_health, deformation = deformation, fuel = v.fuel_level})
        end
        cb(vehicles)
    end)
end)

RegisterServerEvent('egl_garage:storeVehicle')
AddEventHandler('egl_garage:storeVehicle', function(vehicle, garageName, engineHealth, bodyHealth, deformation, fuelLevel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    local query = ("UPDATE %s SET park = 1 WHERE plate = @plate"):format(Config.server_settings.vehicles_table)
    MySQL.Async.execute(query, {
        ['@plate'] = vehicle,
    }, function(rowsChanged)
        if rowsChanged == 1 then
            local query_data = ("UPDATE %s SET engine_health = @engineHealth, body_health = @bodyHealth, deformation = @deformation, fuel_level = @fuelLevel WHERE plate = @plate"):format(Config.server_settings.vehicles_table)
            MySQL.Async.execute(query_data, {
                ['@plate'] = vehicle,
                ['@engineHealth'] = engineHealth,
                ['@bodyHealth'] = bodyHealth,
                ['@deformation'] = json.encode(deformation),
                ['@fuelLevel'] = fuelLevel
            }, function(rowsChanged)
                TriggerClientEvent('egl_garage:storeVehicleResponse', _source, true)
            end)
        end
    end)
end)

RegisterServerEvent('egl_garage:retrieveVehicle')
AddEventHandler('egl_garage:retrieveVehicle', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local query = ("UPDATE %s SET park = 0 WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.execute(query, {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged == 0 then
            TriggerClientEvent('esx:showNotification', _source, false)
        end
    end)
end)
RegisterServerEvent('egl_garage:impoundVehicle')
AddEventHandler('egl_garage:impoundVehicle', function(vehiclePlate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local query = ("UPDATE %s SET impound = 1 WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.execute(query, {
        ['@plate'] = vehiclePlate,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged == 1 then
            TriggerClientEvent('egl_garage:impoundVehicleResponse', _source, true)
        else
            TriggerClientEvent('egl_garage:impoundVehicleResponse', _source, false)
        end
    end)
end)

RegisterServerEvent('egl_garage:retrieveFromImpound')
AddEventHandler('egl_garage:retrieveFromImpound', function(vehiclePlate, v, impound, deformation)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Check if player has enough money
    if xPlayer.getMoney() >= Config.impound_price then
        xPlayer.removeMoney(Config.impound_price)

        local query = ("UPDATE %s SET impound = 0 WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
        MySQL.Async.execute(query, {
            ['@plate'] = vehiclePlate,
            ['@identifier'] = xPlayer.identifier
        }, function(rowsChanged)
            if rowsChanged == 1 then
                TriggerClientEvent('egl_garage:retrieveFromImpoundResponse', _source, true, v, impound, deformation)
            else
                TriggerClientEvent('egl_garage:retrieveFromImpoundResponse', _source, false, v, impound, deformation)
            end
        end)
    end
end)
