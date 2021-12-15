BR = nil
Event = {}
TriggerEvent('brt:getSharedObject', function(obj) BR = obj end)

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT ID, world FROM events_data', {})
	for i=1, #result, 1 do
        Event[tonumber(result[i].ID)] = {World = tonumber(result[i].world), Players = {}}
	end
end)

TriggerEvent('es:addAdminCommand', 'eventdata', 9, function(source, args, user)
    local _source = source
    local xPlayer = BR.GetPlayerFromId(_source)
    local playerpos = xPlayer.coords

    if args[1] then
        if tonumber(args[2]) then
            if args[1] == 'create' then
                local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z +0.5} 
                TriggerEvent('br_events:create', args[2], Pos, _source)
            elseif args[1] == 'start' then
                TriggerEvent('br_events:start', args[2], _source)
            elseif args[1] == 'delete' then
                TriggerEvent('br_events:delete', args[2], _source)
            elseif args[1] == 'status' then
                if args[3] == 'true' or args[3] == 'false' then
                    TriggerEvent('br_events:changestatus', args[2], args[3], _source)
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Akhar Status Bayad true Ya false Vared")
                end
            elseif args[1] == 'checkpoint' then
                TriggerClientEvent('br_events:checkpoint', _source, args[2], args[3])
            elseif args[1] == 'remove' then
                if args[3] == 'car1' or args[3] == 'car2' then
                    TriggerEvent('br_events:removecar', args[2], args[3], _source)
                elseif args[3] == 'gun1' or args[3] == 'gun2'then
                    TriggerEvent('br_events:removegun', args[2], args[3], _source)
                elseif args[3] == 'skin1' or args[3] == 'skin2' then
                    TriggerEvent('br_events:removeskin', args[2], args[3], _source)
                elseif args[3] == 'checkpoint' then
                    TriggerClientEvent('br_events:checkpoint', args[2], 'remove')
                    TriggerEvent('br_events:removecheckpoint', args[2], _source)
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Akhar Remove Bayad Yeki Az Option Haye car1, car2, gun1, gun2, skin1, skin2 Vared")
                end
            elseif args[1] == 'vest' then
                if tonumber(args[3]) then
                    local armor = tonumber(args[3])
                    if armor <= 100 then
                        TriggerEvent('br_events:changevest', args[2], args[3], _source)
                    else
                        TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitavanid Meghdar Armor Ra Bishtar Az 100 Set Konid")
                    end
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Armor Faghat Mitavanid Adad Vared Konid")
                end
            elseif args[1] == 'world' then
                if tonumber(args[3]) then
                    local world = tonumber(args[3])
                    TriggerEvent('br_events:changeworld', args[2], args[3], _source)
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat World Faghat Mitavanid Adad Vared Konid")
                end
            elseif args[1] == 'car1' or args[1] == 'car2' then
                if args[3] then
                    if args[4] then
                        if tonumber(args[5]) then 
                            local ben = tonumber(args[5])
                            if ben <= 100 then
                                local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                                TriggerEvent('br_events:changecar', args[1], args[2], args[3], args[4], args[5], Pos, _source)
                            else
                                TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitavanid Meghdar Benzin Ra Bishtar Az 100 Set Konid")
                            end
                        else
                            TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Benzin Faghat Mitavanid Adad Vared Konid")
                        end
                    else
                        TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Pelak Mashin Chizi Vared Nakardid")
                    end
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat VasileNaghlie Chizi Vared Nakardid")
                end
            elseif args[1] == 'carspawn1' or args[1] == 'carspawn2' then
                local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z , h = xPlayer.angel }
                TriggerEvent('br_events:changecarspawn', args[1], args[2], Pos, _source)
            elseif args[1] == 'gun1' or args[1] == 'gun2' then
                if args[3]:find('weapon_') or args[3]:find('WEAPON_')then
                    if tonumber(args[4]) then
                        local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                        TriggerEvent('br_events:changegun', args[1], args[2], args[3], args[4], Pos, _source)
                    else
                        TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Tedad Tir Faghat Mitavanid Adad Vared Konid")
                    end
                else
                    TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Model Aslahe Bayad Az WEAPON_(Esm Aslahe) Estefade Konid")
                end
            elseif args[1] == 'skin1' or args[1] == 'skin2' then
                if tonumber(args[3]) then
                    if GetPlayerName(args[3]) then
                        local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                        TriggerEvent('br_events:changeskin', args[1], args[2], args[3], Pos, _source)
                    else
                        TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Player Vared Shode Vojod Nadarad")
                    end
                else
                    TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Player Faghat Mitavanid Adad Vared Konid")
                end
            else
                TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Option Faghat Bayad Yeki Az Option Haye create, start, delete, remove, world, status, vest, car1, car2, carspawn, gun1, gun2, skin1, skin2 Ra Vared Konid")
            end
        else
            TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Shomare Event Faghat Bayad Adad Vared Konid")
        end
    else
        TriggerClientEvent('chatMessage', _source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Syntax Vared Shode Eshtebah Ast")
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Shoma Ejaze Estefade Az In Dastor Ra Nadarid!' } })
end, {help = "Taghir Option Haye Event", params = {{name = "Noe Taghir", help = "create, start, delete, remove, world, status, vest, car1, car2, carspawn1, carspawn2, gun1, gun2, skin1, skin2"}, {name = "Shomare Event", help = "Faghat Be Sorate Shomare"}}})

RegisterServerEvent('br_events:OnPlayerDeath')
AddEventHandler('br_events:OnPlayerDeath', function(id, data)
    local _source = source
    local killername = 'HichKas'
    local killedname = string.gsub(exports.essentialmode:GetPlayerICName(_source), "_", " ")
    local headshot = data.headshot
    local weapon = 'WEAPON_UNARMED'
    if BR.GetWeaponFromHash(data.deathCause) then
        weapon = BR.GetWeaponFromHash(data.deathCause).name
    end
    if data.killedByPlayer then
        killername = string.gsub(exports.essentialmode:GetPlayerICName(data.killerServerId), "_", " ")
        killArray = {
            {
                ["color"] = "5020550",
                ["title"] = "New Kill",
                ["description"] = "Id:".._source.."\nPlayer: **"..GetPlayerName(_source).."**\nZaman: **"..os.date('%Y-%m-%d %H:%M:%S').."**",
                ["fields"] = {
                    {
                        ["name"] = "Killer: ",
                        ["value"] = "**("..data.killerServerId..") "..killername.."**"
                    },
                    {
                        ["name"] = "Aslahe: ",
                        ["value"] = "**"..weapon.."**"
                    }
                },
                ["footer"] = {
                ["text"] = "BR Log System",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/801538325600403466/802826232797331456/discordicon.png",
                }
            }
        }
        TriggerEvent('brt_bot:SendLog', 'event', SystemName, killArray, 'system', source, false, false)
    else
        killArray = {
            {
                ["color"] = "5020550",
                ["title"] = "Khodkoshi",
                ["description"] = "Id:".._source.."\nPlayer: **"..GetPlayerName(_source).."**\nZaman: **"..os.date('%Y-%m-%d %H:%M:%S').."**",
                ["footer"] = {
                ["text"] = "BR Log System",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/801538325600403466/802826232797331456/discordicon.png",
                }
            }
        }
        TriggerEvent('brt_bot:SendLog', 'event', SystemName, killArray, 'system', source, false, false)
    end

    local players = Event[id].Players
    for i=1, #players, 1 do
        TriggerClientEvent('br_events:NewKill', Players[i], killername, killedname, weapon, headshot)
    end
end)

RegisterServerEvent('br_events:SetMyData')
AddEventHandler('br_events:SetMyData', function(id)
    local _source = source
    table.insert(Event[id].Players, _source)
    local World = Event[id].World
    if World ~= 0 then
        SetPlayerRoutingBucket(_source, World)
        exports.BR_voip:updateRoutingBucket(_source, World)
    end
end)

RegisterServerEvent('br_events:Exit')
AddEventHandler('br_events:Exit', function(id)
    local _source = source
    Event[id].Players[_source] = nil
    if GetPlayerRoutingBucket(_source) ~= 0 then
        SetPlayerRoutingBucket(_source, 0)
        exports.BR_voip:updateRoutingBucket(_source, 0)
    end
end)

BR.RegisterServerCallback('br_events:getData', function(source, cb, id)
    MySQL.Async.fetchAll('SELECT * FROM events_data WHERE ID = @id', {
	    ['@id'] = id
	}, function(data)
		cb(data[1])
    end)
end)

RegisterNetEvent('br_events:create')
AddEventHandler('br_events:create', function(id, pos, source)
    MySQL.Async.execute('INSERT INTO `events_data` (`ID`, `tp`) VALUES (@id, @pos)', {
        ['@id'] = tonumber(id),
        ['@pos'] = json.encode(pos)
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Event Ba Shomare ' .. id .. ' Sakhtid')
            TriggerClientEvent('br_events:sync', source, id)
            Event[id] = {World = 0, Players = {}}
        end
    end)
end)

RegisterNetEvent('br_events:delete')
AddEventHandler('br_events:delete', function(id, source)
    MySQL.Async.execute('DELETE FROM events_data WHERE ID = @id', {
        ['@id'] = tonumber(id)
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Event Ba Shomare ' .. id .. ' Ra Hazf Kardid')
            TriggerClientEvent('br_events:sync', source, id)
            Event[id] = nil
        end
    end)
end)

RegisterNetEvent('br_events:changestatus')
AddEventHandler('br_events:changestatus', function(id, tf, source)
    if tf == 'true' then
        MySQL.Async.execute('UPDATE events_data SET status = TRUE WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Event Ba Shomare ' .. id .. ' Baaz Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif tf == 'false' then
        MySQL.Async.execute('UPDATE events_data SET status = FALSE WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Event Ba Shomare ' .. id .. ' Bastid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:changecar')
AddEventHandler('br_events:changecar', function(type, id, model, plate, benzin, pos, source)
    if type == 'car1' then
        MySQL.Async.execute('UPDATE events_data SET car1 = @model, car1_plate = @plate, car1_fuel = @benzin, car1_marker = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@model'] = model,
            ['@plate'] = string.upper(plate),
            ['@benzin'] = benzin,
            ['@pos'] = json.encode(pos),
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Vasile Naghlie Aval Ba Model '..model..' Ba Pelak '..plate..' Ba ' ..benzin.. ' Benzin Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'car2' then
        MySQL.Async.execute('UPDATE events_data SET car2 = @model, car2_plate = @plate, car2_fuel = @benzin, car2_marker = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@model'] = model,
            ['@plate'] = string.upper(plate),
            ['@benzin'] = benzin,
            ['@pos'] = json.encode(pos),
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Vasile Naghlie Dovom Ba Model'..model..' Ba Pelak '..plate..' Ba ' ..benzin.. ' Benzin Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:changecarspawn')
AddEventHandler('br_events:changecarspawn', function(type, id, pos, source)
    if type == 'carspawn1' then
        MySQL.Async.execute('UPDATE events_data SET car_spawn1 = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Mahale Spawn Vasile Naghlie Aval Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'carspawn2' then
        MySQL.Async.execute('UPDATE events_data SET car_spawn2 = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Mahale Spawn Vasile Naghlie Dovom Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:changegun')
AddEventHandler('br_events:changegun', function(type, id, name, tir, pos, source)
    if type == 'gun1' then
        MySQL.Async.execute('UPDATE events_data SET gun1 = @name, gun1_ammo = @tir, gun1_marker = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@name'] = string.upper(name),
            ['@tir'] = tir,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Gun Aval '..BR.GetWeaponLabel(name)..' Ba '..tir..' Tir Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'gun2' then
        MySQL.Async.execute('UPDATE events_data SET gun2 = @name, gun2_ammo = @tir, gun2_marker = @pos WHERE ID = @id', {
            ['@id'] = id,
            ['@name'] = string.upper(name),
            ['@tir'] = tir,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Gun Dovom '..BR.GetWeaponLabel(name)..' Ba '..tir..' Tir Baraye Event Shomare ' .. id .. ' Gharar Dadid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:changeworld')
AddEventHandler('br_events:changeworld', function(id, meghdar, source)
    MySQL.Async.execute('UPDATE events_data SET world = @meghdar WHERE ID = @id', {
        ['@id'] = id,
        ['@meghdar'] = meghdar,
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat World Event Shomare ' .. id .. ' Roye '.. meghdar .. ' Set Kardid')
            TriggerClientEvent('br_events:sync', source, id)
            SetRoutingBucketPopulationEnabled(meghdar, false)
            Event[id].World = meghdar
        end
    end)
end)

RegisterNetEvent('br_events:changevest')
AddEventHandler('br_events:changevest', function(id, meghdar, source)
    MySQL.Async.execute('UPDATE events_data SET vest = @meghdar WHERE ID = @id', {
        ['@id'] = id,
        ['@meghdar'] = meghdar,
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Meghdar %' .. meghdar .. ' Vest Voroudi Baraye Event Shomare ' .. id .. ' Gharar Dadid')
            TriggerClientEvent('br_events:sync', source, id)
        end
    end)
end)

RegisterNetEvent('br_events:changeskin')
AddEventHandler('br_events:changeskin', function(type, id, player, pos, source)
    local xPlayer = BR.GetPlayerFromId(player)

    MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(users)

        local user = users[1]
        local skin = nil

        if user.skin ~= nil then
            skin = json.decode(user.skin)
        end

        if skin.sex == 0 then
            if type == 'skin1' then
                MySQL.Async.execute('UPDATE events_data SET skin1_male = @skin, skin1_marker = @pos WHERE ID = @id', {
                    ['@id'] = id,
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Mard Team Aval Event Shomare ' .. id .. ' Gharar Dadid')
                        TriggerClientEvent('br_events:sync', source, id)
                    end
                end)
            elseif type == 'skin2' then
                MySQL.Async.execute('UPDATE events_data SET skin2_male = @skin, skin2_marker = @pos WHERE ID = @id', {
                    ['@id'] = id,
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Mard Team Dovom Event Shomare ' .. id .. ' Gharar Dadid')
                        TriggerClientEvent('br_events:sync', source, id)
                    end
                end)
            end
        else
            if type == 'skin1' then
                MySQL.Async.execute('UPDATE events_data SET skin1_female = @skin, skin1_marker = @pos WHERE ID = @id', {
                    ['@id'] = id,
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Zan Team Aval Event Shomare ' .. id .. ' Gharar Dadid')
                        TriggerClientEvent('br_events:sync', source, id)
                    end
                end)
            elseif type == 'skin2' then
                MySQL.Async.execute('UPDATE events_data SET skin2_female = @skin, skin2_marker = @pos WHERE ID = @id', {
                    ['@id'] = id,
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Zan Team Dovom Event Shomare ' .. id .. ' Gharar Dadid')
                        TriggerClientEvent('br_events:sync', source, id)
                    end
                end)
            end
        end
    end)
end)

RegisterNetEvent('br_events:savecheckpoint')
AddEventHandler('br_events:savecheckpoint', function(id, points)
    local _source = source
    MySQL.Async.execute('UPDATE events_data SET checkpoints = @points WHERE ID = @id', {
        ['@id'] = id,
        ['@points'] = json.encode(points)
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', _source, 'Shoma Ba Movafaghiyat CheckPoint Haye Event Shomare ' .. id .. ' Ra Zakhire Kardid')
            TriggerClientEvent('br_events:sync', _source, id)
        end
    end)
end)

RegisterNetEvent('br_events:removecar')
AddEventHandler('br_events:removecar', function(id, type, source)
    if type == 'car1' then
        MySQL.Async.execute('UPDATE events_data SET car1 = NULL, car1_plate = NULL, car1_fuel = NULL, car1_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option VasileNaghlie Aval Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'car2' then
        MySQL.Async.execute('UPDATE events_data SET car2 = NULL, car2_plate = NULL, car2_fuel = NULL, car2_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option VasileNaghlie Dovom Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:removegun')
AddEventHandler('br_events:removegun', function(id, type, source)
    if type == 'gun1' then
        MySQL.Async.execute('UPDATE events_data SET gun1 = NULL, gun1_ammo = NULL, gun1_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option Aslahe Aval Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'gun2' then
        MySQL.Async.execute('UPDATE events_data SET gun2 = NULL, gun2_ammo = NULL, gun2_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option Aslahe Dovom Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:removeskin')
AddEventHandler('br_events:removeskin', function(id, type, source)
    if type == 'skin1' then
        MySQL.Async.execute('UPDATE events_data SET skin1_male = NULL, skin1_female = NULL, skin1_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option Skin Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    elseif type == 'skin2' then
        MySQL.Async.execute('UPDATE events_data SET skin2_male = NULL, skin2_female = NULL, skin2_marker = NULL WHERE ID = @id', {
            ['@id'] = id
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Option Skin Event Shomare ' .. id .. ' Ra Reset Kardid')
                TriggerClientEvent('br_events:sync', source, id)
            end
        end)
    end
end)

RegisterNetEvent('br_events:removecheckpoint')
AddEventHandler('br_events:removecheckpoint', function(id, source)
    MySQL.Async.execute('UPDATE events_data SET checkpoints = NULL WHERE ID = @id', {
        ['@id'] = id
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('brt:showNotification', source, 'Shoma Ba Movafaghiyat Checkpoint Haye Event Shomare ' .. id .. ' Ra Reset Kardid')
            TriggerClientEvent('br_events:sync', source, id)
        end
    end)
end)