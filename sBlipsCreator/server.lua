ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('sBlipsCreator:createBlip')
AddEventHandler('sBlipsCreator:createBlip', function(name, label, coords, sprite, display, scale, color, flashes)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    for i=1, #Config.permission, 1 do
        if group == Config.permission[i] then
            break
        elseif i == #Config.permission then
            TriggerClientEvent('esx:showNotification', _src, "~r~Vous n'avez pas la permission d'ajouter des blips !")
            return
        end
    end

    MySQL.Async.fetchAll('SELECT * FROM sblips WHERE name = @name', {
        ['@name'] = name
    }, function(result)
        if result[1] == nil then
            MySQL.Async.execute('INSERT INTO sblips (name, label, coords, sprite, display, scale, color, flashes) VALUES (@name, @label, @coords, @sprite, @display, @scale, @color, @flashes)', {
                ['@name'] = name,
                ['@label'] = label,
                ['@coords'] = coords,
                ['@sprite'] = sprite,
                ['@display'] = display,
                ['@scale'] = scale,
                ['@color'] = color,
                ['@flashes'] = flashes
            }, function(rowsChanged)
                TriggerClientEvent('esx:showNotification', _src, "~g~Blips créé avec succès !")
            end)
        else
            TriggerClientEvent('esx:showNotification', _src, "~r~Un blips porte déjà ce nom !")
        end
    end)
end)

RegisterServerEvent('sBlipsCreator:deleteBlip')
AddEventHandler('sBlipsCreator:deleteBlip', function(name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local group = xPlayer.getGroup()
    for i=1, #Config.permission, 1 do
        if group == Config.permission[i] then
            break
        elseif i == #Config.permission then
            TriggerClientEvent('esx:showNotification', _src, "~r~Vous n'avez pas la permission d'ajouter des blips !")
            return
        end
    end
    MySQL.Async.execute('DELETE FROM sblips WHERE name = @name', {
        ['@name'] = name
    }, function(rowsChanged)
        TriggerClientEvent('esx:showNotification', _src, "~g~Blips supprimé avec succès !")
    end)
end)

ESX.RegisterServerCallback('sBlipsCreator:getBlips', function(source, cb)
    local _source = source
    local blipsList = {}
    MySQL.Async.fetchAll('SELECT * FROM sblips', {}, function(result)
        for i=1, #result, 1 do
            table.insert(blipsList, {
                name = result[i].name,
                label = result[i].label,
                coords = result[i].coords,
                sprite = result[i].sprite,
                display = result[i].display,
                scale = result[i].scale,
                color = result[i].color,
                flashes = result[i].flashes
            })
        end
        cb(blipsList)
    end)
end)

ESX.RegisterServerCallback('sBlipsCreator:getUserGroup', function(source, cb)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local group = xPlayer.getGroup()
	cb(group)
end)