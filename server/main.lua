
local ESX = nil

ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('garage:getOwnedVehicles', function(source, cb, garageName)
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
            table.insert(vehicles, {plate = v.plate, model = v.model, vehicle = vehicle, park = v.park, impound = impound})
        end
        cb(vehicles)
    end)
end)

RegisterServerEvent('garage:storeVehicle')
AddEventHandler('garage:storeVehicle', function(vehicle, garageName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    local query = ("UPDATE %s SET park = 1 WHERE plate = @plate"):format(Config.server_settings.vehicles_table)
    MySQL.Async.execute(query, {
        ['@plate'] = vehicle,
    }, function(rowsChanged)
        if rowsChanged == 1 then
            TriggerClientEvent('garage:storeVehicleResponse', _source, true)
        else
            TriggerClientEvent('garage:storeVehicleResponse', _source, false)
        end
    end)
end)

RegisterServerEvent('garage:retrieveVehicle')
AddEventHandler('garage:retrieveVehicle', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local query_check = ("SELECT park FROM %s WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.fetchScalar(query_check, {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(isParked)
        if isParked == 0 then
            return
        end
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local query = ("UPDATE %s SET park = 0 WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.execute(query, {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged == 0 then
            TriggerClientEvent('esx:showNotification', _source, 'Erreur lors de la sortie du véhicule.')
        end
    end)
end)
end)
RegisterServerEvent('garage:impoundVehicle')
AddEventHandler('garage:impoundVehicle', function(vehiclePlate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local query = ("UPDATE %s SET impound = 1 WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.execute(query, {
        ['@plate'] = vehiclePlate,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged == 1 then
            TriggerClientEvent('garage:impoundVehicleResponse', _source, true)
        else
            TriggerClientEvent('garage:impoundVehicleResponse', _source, false)
        end
    end)
end)

RegisterServerEvent('garage:retrieveFromImpound')
AddEventHandler('garage:retrieveFromImpound', function(vehiclePlate, v, impound)
    local xPlayer = ESX.GetPlayerFromId(source)
    local query_check = ("SELECT impound FROM %s WHERE plate = @plate AND %s = @identifier"):format(Config.server_settings.vehicles_table, Config.server_settings.identifier_column)
    MySQL.Async.fetchScalar(query_check, {
        ['@plate'] = vehiclePlate,
        ['@identifier'] = xPlayer.identifier
    }, function(isImpounded)
        if isImpounded == 0 then
            return
        end
    end)
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
                TriggerClientEvent('garage:retrieveFromImpoundResponse', _source, true, v, impound)
            end
        end)
    else
        TriggerClientEvent('garage:retrieveFromImpoundResponse', _source, false, v, impound)
    end
end)
