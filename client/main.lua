BR                            = nil
local HasAlreadyEnteredMarker = false
local GUI                     = {}
GUI.Time                      = 0
local LastPart                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local Br                      = {}
local EventID                 = -1
local DakheleEvent            = false
local recordedCheckpoints     = {}
local PlayerData              = {}
local CheckPointStatus        = {
    state       = 0,
    checkpoint  = 0
}

Citzen.CreateThread(function()
    while BR == nil do
        TriggerEvent('brt:getSharedObject', function(obj) BR = obj end)
        Citzen.Wait(0)
    end

    while BR.GetPlayerData() == nil do
        Citzen.Wait(500)
    end
  
    PlayerData = BR.GetPlayerData()
end)

RegisterNetEvent('brt:playerLoaded')
AddEventHandler('brt:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('brt:setJob')
AddEventHandler('brt:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('brt:onPlayerDeath', function(data)
    if DakheleEvent then
        TriggerServerEvent('br_events:OnPlayerDeath', EventID, data)
    end
end)

RegisterNetEvent('br_events:sync')
AddEventHandler('br_events:sync', function(id)
    BR.TriggerServerCallback('br_events:getData', function(data)
        if data ~= nil then
            Br.tp            = json.decode(data.tp)
            Br.status        = data.status
            Br.vest          = data.vest
            Br.car1          = data.car1
            Br.car1_plate    = data.car1_plate
            Br.car1_fuel     = data.car1_fuel
            Br.car1_marker   = json.decode(data.car1_marker)
            Br.car2          = data.car2
            Br.car2_plate    = data.car2_plate
            Br.car2_fuel     = data.car2_fuel
            Br.car2_marker   = json.decode(data.car2_marker)
            Br.car_spawn1    = json.decode(data.car_spawn1)
            Br.car_spawn2    = json.decode(data.car_spawn2)
            Br.gun1          = data.gun1
            Br.gun1_ammo     = data.gun1_ammo
            Br.gun1_marker   = json.decode(data.gun1_marker)
            Br.gun2          = data.gun2
            Br.gun2_ammo     = data.gun2_ammo
            Br.gun2_marker   = json.decode(data.gun2_marker)
            Br.skin1_male    = json.decode(data.skin1_male)
            Br.skin1_female  = json.decode(data.skin1_female)
            Br.skin1_marker  = json.decode(data.skin1_marker)
            Br.skin2_male    = json.decode(data.skin2_male)
            Br.skin2_female  = json.decode(data.skin2_female)
            Br.skin2_marker  = json.decode(data.skin2_marker)
            Br.checkpoints   = json.decode(data.checkpoints)
        end
    end, tonumber(id))
end)

RegisterCommand('event', function(source, args)
    local playerPed = PlayerPedId()
    local coords   = GetEntityCoords(playerPed)
    local inParking  = GetDistanceBetweenCoords(coords, 225.55, -786.38, 30.73, true) < 50
    if args[1] then
        if tonumber(args[1]) then
            local Id = tonumber(args[1])
            BR.TriggerServerCallback('br_events:getData', function(data)
                if data ~= nil then
                    if data.status == true then
                        if not DakhelEvent then
                            if inParking then
                                if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" or PlayerData.job.name == "artesh" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "taxi" then
                                    TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, 'Baraye Bazi Dar PaintBall Bayad Dar ^2Shoghl Khodeton ^1Off-Duty ^0Bashid')
                                else
                                    exports.vip_cars:PB(true)
                                    DakheleEvent = true
                                    EventID = Id
                                    RequestCollisionAtCoord(Br.tp.x, Br.tp.y, Br.tp.z)
                                    while not HasCollisionLoadedAroundEntity(playerPed) do
                                        RequestCollisionAtCoord(Br.tp.x, Br.tp.y, Br.tp.z)
                                        Citzen.Wait(1)
                                    end
                                    SetEntityCords(playerPed, Br.tp.x, Br.tp.y, Br.tp.z)
                                    TriggerServerEvent('br_events:SetMyData', Id)
                                    TriggerEvent('DakhelEvent', true)
                                    TriggerEvent('brt:updatecoords', false)
                                    TriggerServerEvent('DakhelEvent', true)
                                    TriggerEvent('brt_basicneeds:healPlayer')
                                    SetArmour(playerPed, Br.vest)
                                    if BR.GetPlayerData()['aduty'] == 1 then
                                        TriggerEvent('OffDutyHandler')
                                        TriggerServerEvent('brt_aduty:TagStatus', GetPlayerServerId(PlayerId()), false)
                                    end
                                    cleanupRecording()
                                    for index, checkpoint in pairs(Br.checkpoints) do
                                        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
                                        SetBlipColour(checkpoint.blip, Config.CheckPointBlipColor)
                                        SetBlipAsShortRange(checkpoint.blip, true)
                                        ShowNumberOnBlip(checkpoint.blip, index)
                                    end
                                    SetWaypointOff()
                                    SetBlipRoute(Br.checkpoints[1].blip, true)
                                    SetBlipRouteColour(Br.checkpoints[1].blip, Config.CheckPointBlipColor)
                                    TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Vared Event Shodid, Heal Shoma Poor Va Armor Shoma Bar Asas Event Set Shod Ke Dar Makan Haye Moshakhash Shode Mitonid Mashin, Aslahe Va Lebas Khod Ra Taghir Dahid")
                                end
                            else
                                TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Baraye Voroud Be Event Bayad Dakhele Mohavate Parking Markazi Bashid")
                            end
                        else
                            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Hal Hazer Dakhel Event Hastid!")
                        end
                    else
                        TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0In Event Baste Shode")
                    end
                else
                    TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0In Event Vojod Nadarad")
                end
            end, Id)
        else
            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Event Faghat Bayad Adad Vared Konid")
        end
    else
        TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Shomare Eventi Ra Vared Nakardid")
    end
end, false)

RegisterCommand('exitevent', function(source, args, user)
    if DakheleEvent then
        DakheleEvent = false
        TriggerServerEvent('br_events:Exit', EventID)
        EventID = -1
        local playerPed = PlayerPedId()
        local coords   = GetEntityCoords(playerPed)
        cleanupCheckpoints()
        TriggerEvent('brt:updatecoords', true)
        TriggerEvent('DakhelEvent', false)
        TriggerServerEvent('DakhelEvent', false)
        if HasPedGotWeapon(playerPed, GetHashKey(Br.gun1), false) then
            RemoveWeaponFromPed(playerPed, GetHashKey(Br.gun1))
        end
        if HasPedGotWeapon(playerPed, GetHashKey(Br.gun2), false) then
            RemoveWeaponFromPed(playerPed, GetHashKey(Br.gun2))
        end
        TriggerEvent("brt_ambulancejob:revive", source)
        Wait(2000)
        RequestCollisionAtCoord(225.55, -786.38, 30.73)
        while not HasCollisionLoadedAroundEntity(playerPed) do
            RequestCollisionAtCoord(225.55, -786.38, 30.73)
            Citzen.Wait(1)
        end
        SetEntityCords(playerPed, 225.55, -786.38, 30.73)
        SetArmour(playerPed, 0)
        BR.TriggerServerCallback("brt_skin:getPlayerSkin", function(skin)
            TriggerEvent("skinchanger:loadSkin", skin)
        end)
        exports.vip_cars:PB(false)
    else
        TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Hal Hazer Dakhel Hich Eventi Nistid")
    end
end, false)

TriggerEvent('chat:addSuggestion', '/event', 'Vared Shodan Be Event', {
    { name="Shomare Event", help="Faghat Be Sorat Adad" }
})
TriggerEvent('chat:addSuggestion', '/exitevent', 'Khoroj Az Event', {})

RegisterNetEvent('br_events:checkpoint')
AddEventHandler('br_events:checkpoint', function(id, model)
    if model == 'record' then
        SetWaypointOff()
        cleanupRecording()
        CheckPointStatus.state = 1
    elseif model == 'save' then
        if #recordedCheckpoints > 0 then
            TriggerServerEvent('br_events:savecheckpoint', id, recordedCheckpoints)
            CheckPointStatus.state = 0
        else
            BR.ShowNotification('Shoma Hich ~g~CheckPointi ~s~Moshakhas Nakardid!')
        end
    elseif model == 'remove' then
        cleanupRecording()
        CheckPointStatus.checkpoint = 0
        CheckPointStatus.state = 0
    end
end)

function OpenCarMenu(station)
    local elements = {}
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if Br.car1 ~= nil and GetDistanceBetweenCoords(coords, Br.car1_marker.x, Br.car1_marker.y, Br.car1_marker.z, true) < 1.5 then
        local aheadVehName1 = GetDisplayNameFromVehicleModel(Br.car1)
        local vehicleName1  = GetLabelText(aheadVehName1) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName1 , value = 'get_veh1'})
	end
    if Br.car2 ~= nil and GetDistanceBetweenCoords(coords, Br.car2_marker.x, Br.car2_marker.y, Br.car2_marker.z, true) < 1.5 then
        local aheadVehName2 = GetDisplayNameFromVehicleModel(Br.car2)
        local vehicleName2  = GetLabelText(aheadVehName2) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName2 , value = 'get_veh2'})
	end
  
    BR.UI.Menu.CloseAll()

    BR.UI.Menu.Open('default', GetCurrentResourceName(), 'veh', {
        title    = _U('get_car'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
        if data.current.value == "get_veh1" then
            menu.close()
            if Br.car1 ~= nil then
                if Br.car_spawn1 ~= nil then
                    SpawnVasileNaghlie(1, Br.car1, Br.car1_plate, Br.car1_fuel)
                else
                    BR.ShowNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
                end
            else
                BR.ShowNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        elseif data.current.value == "get_veh2" then
            menu.close()
            if Br.car2 ~= nil then
                if Br.car_spawn2 ~= nil then
                    SpawnVasileNaghlie(2, Br.car2, Br.car2_plate, Br.car2_fuel)
                else
                    BR.ShowNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
                end
            else
                BR.ShowNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        end
    end, function(data, menu)
        menu.close()

        CurrentAction     = 'menu_car'
        CurrentActionMsg  = _U('open_car')
    end)
end

function SetVehicleMaxMods(vehicle, plate, window, colors)
    local plate = string.gsub(plate, "-", "")
    local props

    if colors then
        props = {
            modEngine = 3,
            modBrakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate,
            color1 = table.pack(colors.r1, colors.g1, colors.b1),
            color2 = table.pack(colors.r2, colors.g2, colors.b2),
        }
        
    else
        props = {
            modEngine = 3,
            modBrakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate
        }
    end

    BR.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function SpawnVasileNaghlie(kodom, vehicle, plate, fuel)
    local SpawnPoint
    if kodom == 1 then
        SpawnPoint = Br.car_spawn1
    elseif kodom == 2 then
        SpawnPoint = Br.car_spawn2
    end
    if BR.Game.IsSpawnPointClear({x = SpawnPoint.x, y = SpawnPoint.y, z = SpawnPoint.z}, 3.0) then
        BR.Game.SpawnVehicle(vehicle, {
            x = SpawnPoint.x+math.random(-10.0, 20.0),
            y = SpawnPoint.y+math.random(10.0, 20.0),
            z = SpawnPoint.z + 1
        }, SpawnPoint.h, function(callback_vehicle)
            SetVehicleMaxMods(callback_vehicle, plate, 1)
            SetVehRadioStation(callback_vehicle, "OFF")
            exports.BR_fuel:SetFuel(callback_vehicle, tonumber(fuel)+0.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        end)
    else
        BR.ShowNotification('Sabr Konid Ta Mahale Spawn Khali Shavad')
    end
end

function OpenGunMenu(type)
	local elements = {}
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if Br.gun1 ~= nil and GetDistanceBetweenCoords(coords, Br.gun1_marker.x, Br.gun1_marker.y, Br.gun1_marker.z, true) < 1.5 then
		table.insert(elements, {label = 'Daryaft ' .. BR.GetWeaponLabel(Br.gun1), value = 'get_gun1'})
	end
    if Br.gun2 ~= nil and GetDistanceBetweenCoords(coords, Br.gun2_marker.x, Br.gun2_marker.y, Br.gun2_marker.z, true) < 1.5 then
		table.insert(elements, {label = 'Daryaft ' .. BR.GetWeaponLabel(Br.gun2), value = 'get_gun2'})
	end

    BR.UI.Menu.CloseAll()

    BR.UI.Menu.Open('default', GetCurrentResourceName(), 'get_gun', {
        title    = _U('get_gun'),
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == "get_gun1" then
            menu.close()
            if Br.gun1 ~= nil then
                if Br.gun1_ammo ~= nil then
                    GiveWeaponToPlayer(PlayerPedId(), GetHashKey(Br.gun1), Br.gun1_ammo, false, true)
                else
                    BR.ShowNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
                end
            else
                BR.ShowNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        elseif data.current.value == "get_gun2" then
            menu.close()
            if Br.gun2 ~= nil then
                if Br.gun2_ammo ~= nil then
                    GiveWeaponToPlayer(PlayerPedId(), GetHashKey(Br.gun2), Br.gun2_ammo, false, true)
                else
                    BR.ShowNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
                end
            else
                BR.ShowNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        end
    end, function(data, menu)
        menu.close()
        CurrentAction     = 'menu_gun'
        CurrentActionMsg  = _U('open_gun')
    end)
end


function OpenSkinMenu()
    local elements = {
        {label = _U('citizen_wear'), value = 'citizen_wear'},
    }
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if Br.skin1_marker ~= nil and GetDistanceBetweenCoords(coords, Br.skin1_marker.x, Br.skin1_marker.y, Br.skin1_marker.z, true) < 1.5 then
		table.insert(elements, {label = 'Daryaft Lebas Aval' , value = 'get_skin1'})
	end
    if Br.skin2_marker ~= nil and GetDistanceBetweenCoords(coords, Br.skin2_marker.x, Br.skin2_marker.y, Br.skin2_marker.z, true) < 1.5 then
		table.insert(elements, {label = 'Daryaft Lebas Dovom', value = 'get_skin2'})
	end
  
    BR.UI.Menu.CloseAll()
  
    BR.UI.Menu.Open('default', GetCurrentResourceName(), 'get_skin', {
        title    = _U('get_skin'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
    
        menu.close()

        if data.current.value == 'citizen_wear' then
            BR.TriggerServerCallback("brt_skin:getPlayerSkin", function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
        elseif data.current.value == 'get_skin1' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if Br.skin1_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Br.skin1_male)
                    else
                        BR.ShowNotification(_U("no_outfit"))
                    end
                else
                    if Br.skin1_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Br.skin1_female)
                    else
                        BR.ShowNotification(_U("no_outfit"))
                    end
                end
            end)
        elseif data.current.value == 'get_skin2' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if Br.skin2_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Br.skin2_male)
                    else
                        BR.ShowNotification(_U("no_outfit"))
                    end
                else
                    if Br.skin2_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Br.skin2_female)
                    else
                        BR.ShowNotification(_U("no_outfit"))
                    end
                end
            end)
        end
  
    end, function(data, menu)
  
        menu.close()
  
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end)
end

-- Sakht Marker
Citzen.CreateThread(function()
    while true do
        Citzen.Wait(0)
        if Br.status == 1 then
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local canSleep = true
            if Br.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.car1_marker.x,  Br.car1_marker.y,  Br.car1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, Br.car1_marker.x,  Br.car1_marker.y,  Br.car1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end
            if Br.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.car2_marker.x,  Br.car2_marker.y,  Br.car2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, Br.car2_marker.x,  Br.car2_marker.y,  Br.car2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end
            
            if Br.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.gun1_marker.x,  Br.gun1_marker.y,  Br.gun1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, Br.gun1_marker.x,  Br.gun1_marker.y,  Br.gun1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end
            if Br.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.gun2_marker.x,  Br.gun2_marker.y,  Br.gun2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, Br.gun2_marker.x,  Br.gun2_marker.y,  Br.gun2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end
            
            if Br.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.skin1_marker.x,  Br.skin1_marker.y,  Br.skin1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, Br.skin1_marker.x,  Br.skin1_marker.y,  Br.skin1_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end
            if Br.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.skin2_marker.x,  Br.skin2_marker.y,  Br.skin2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, Br.skin2_marker.x,  Br.skin2_marker.y,  Br.skin2_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                    canSleep = false
                end
            end

            if canSleep then
                Citzen.Wait(500)
            end
        else
            Citzen.Wait(1500)
        end
    end
end)
    
Citzen.CreateThread(function()
    while true do
        Wait(0)
        if Br.status == 1 then
            local playerPed      = PlayerPedId()
            local coords         = GetEntityCoords(playerPed)
            local isInMarker     = false
            local currentPart    = nil
            local canSleep = true

            if Br.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.car1_marker.x,  Br.car1_marker.y,  Br.car1_marker.z,  true) < Config.CarMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Car'
                end
            end
            if Br.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.car2_marker.x,  Br.car2_marker.y,  Br.car2_marker.z,  true) < Config.CarMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Car'
                end
            end
            
            if Br.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.gun1_marker.x,  Br.gun1_marker.y,  Br.gun1_marker.z,  true) < Config.GunMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Gun'
                end
            end
            if Br.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.gun2_marker.x,  Br.gun2_marker.y,  Br.gun2_marker.z,  true) < Config.GunMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Gun'
                end
            end
            
            if Br.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.skin1_marker.x,  Br.skin1_marker.y,  Br.skin1_marker.z,  true) < Config.SkinMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Skin'
                end
            end
            if Br.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Br.skin2_marker.x,  Br.skin2_marker.y,  Br.skin2_marker.z,  true) < Config.SkinMarkerSize.x then
                    canSleep = false
                    isInMarker     = true
                    currentPart    = 'Skin'
                end
            end
            
            local hasExited = false
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPart ~= currentPart)) then
                if (LastPart ~= nil) and (LastPart ~= currentPart) then
                    TriggerEvent('br_events:hasExitedMarker', LastPart)
                    hasExited = true
                end
                HasAlreadyEnteredMarker = true
                LastPart                = currentPart
                TriggerEvent('br_events:hasEnteredMarker', currentPart)
            end
            
            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('br_events:hasExitedMarker', LastPart)
            end

            if canSleep then
                Citzen.Wait(500)
            end
        else
            Citzen.Wait(1500)
        end
    end
end)

AddEventHandler('br_events:hasEnteredMarker', function(part)
    if part == 'Car' then
        CurrentAction     = 'menu_car'
        CurrentActionMsg  = _U('open_car')
    end
        
    if part == 'Gun' then
        CurrentAction     = 'menu_gun'
        CurrentActionMsg  = _U('open_gun')
    end
        
    if part == 'Skin' then
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end  
end)
        
AddEventHandler('br_events:hasExitedMarker', function(part)
    BR.UI.Menu.CloseAll()
    CurrentAction = nil
end)

Citzen.CreateThread(function()
    while true do
        Citzen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        
            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
                if CurrentAction == 'menu_car' then
                    OpenCarMenu()
                elseif CurrentAction == 'menu_gun' then
                    OpenGunMenu()
                elseif CurrentAction == 'menu_skin' then
                    OpenSkinMenu()
                end
                CurrentAction = nil
                GUI.Time      = GetGameTimer()
            end
        else
            Citzen.Wait(600)
        end
    end
end)

Citzen.CreateThread(function()
    while true do
        if DakheleEvent then
            local Ped = PlayerPedId()
            DisableControlAction(0, 166, true)
            DisableControlAction(0, 167, true)
            SetCanPedEquipAllWeapons(Ped, false)
            if Br.gun1 ~= nil then
                SetCanPedSelectWeapon(Ped, GetHashKey(Br.gun1), true)
            end
            if Br.gun2 ~= nil then
                SetCanPedSelectWeapon(Ped, GetHashKey(Br.gun2), true)
            end
            SetCanPedSelectWeapon(Ped, 0xA2719263, true)
            Citzen.Wait(5)
        else
            Citzen.Wait(5000)
            SetCanPedEquipAllWeapons(PlayerPedId(), true)
        end
    end
end)

Citzen.CreateThread(function()
    while true do
        Citzen.Wait(0)
        if DakheleEvent and Br.checkpoints ~= nil then
            local player = PlayerPedId()
            local position = GetEntityCoords(player)
            if CheckPointStatus.checkpoint == 0 then
                CheckPointStatus.checkpoint = 1
                local checkpoint = Br.checkpoints[CheckPointStatus.checkpoint]

                if Config.CheckPointRadius > 0 then
                    local checkpointType = CheckPointStatus.checkpoint < #Br.checkpoints and Config.CheckPointType or Config.CheckPointFinishType
                    checkpoint.checkpoint = CreateCheckpoint(checkpointType, checkpoint.coords.x,  checkpoint.coords.y, checkpoint.coords.z+1.2, 0, 0, 0, Config.CheckPointRadius, 255, 255, 0, 127, 0)
                    SetCheckpointCylinderHeight(checkpoint.checkpoint, Config.CheckPointHeight, Config.CheckPointHeight, Config.CheckPointRadius)
                end

                SetBlipRoute(checkpoint.blip, true)
                SetBlipRouteColour(checkpoint.blip, Config.CheckPointBlipColor)
            else
                local checkpoint = Br.checkpoints[CheckPointStatus.checkpoint]
                if GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false) < Config.CheckPointProximity then
                    RemoveBlip(checkpoint.blip)
                    if Config.CheckPointRadius > 0 then
                        DeleteCheckpoint(checkpoint.checkpoint)
                    end
                        
                    if CheckPointStatus.checkpoint == #(Br.checkpoints) then
                        CheckPointStatus.state = 0
                    else
                        PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
                        CheckPointStatus.checkpoint = CheckPointStatus.checkpoint + 1
                        local nextCheckpoint = Br.checkpoints[CheckPointStatus.checkpoint]

                        if Config.CheckPointRadius > 0 then
                            local checkpointType = CheckPointStatus.checkpoint < #Br.checkpoints and Config.CheckPointType or Config.CheckPointFinishType
                            nextCheckpoint.checkpoint = CreateCheckpoint(checkpointType, nextCheckpoint.coords.x,  nextCheckpoint.coords.y, nextCheckpoint.coords.z+1.2, 0, 0, 0, Config.CheckPointRadius, 255, 255, 0, 127, 0)
                            SetCheckpointCylinderHeight(nextCheckpoint.checkpoint, Config.CheckPointHeight, Config.CheckPointHeight, Config.CheckPointRadius)
                        end

                        SetBlipRoute(nextCheckpoint.blip, true)
                        SetBlipRouteColour(nextCheckpoint.blip, Config.CheckPointBlipColor)
                    end
                end
            end
        else
            Citzen.Wait(1000)
        end  
    end
end)

Citzen.CreateThread(function()
    while true do
        Citzen.Wait(700)
        if CheckPointStatus.state == 1 then
            if IsWaypointActive() then
                local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
                local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
                SetWaypointOff()

                for index, checkpoint in pairs(recordedCheckpoints) do
                    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z, false) < 1.0 then
                        RemoveBlip(checkpoint.blip)
                        table.remove(recordedCheckpoints, index)
                        coords = nil

                        for i = index, #recordedCheckpoints do
                            ShowNumberOnBlip(recordedCheckpoints[i].blip, i)
                        end
                        break
                    end
                end

                if (coords ~= nil) then
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipColour(blip, Config.CheckPointBlipColor)
                    SetBlipAsShortRange(blip, true)
                    ShowNumberOnBlip(blip, #recordedCheckpoints + 1)

                    table.insert(recordedCheckpoints, {blip = blip, coords = coords})
                end
            end
        else
            cleanupRecording()
        end
    end
end)

RegisterNetEvent('br_events:NewKill')
AddEventHandler('br_events:NewKill',function(killername, killedname, wname, head)
	if DakhelEvent then
        SendNUIMessage({
            type = 'newkill',
            killer = killername,
            weapon = wname,
            killed = killedname,
            headshot = head
        })
	end
end)

function cleanupRecording()
    for _, checkpoint in pairs(recordedCheckpoints) do
        RemoveBlip(checkpoint.blip)
        checkpoint.blip = nil
    end
    recordedCheckpoints = {}
end

function cleanupCheckpoints()
    local checkpoints = Br.checkpoints
    if checkpoints ~= nil then
        for _, checkpoint in pairs(checkpoints) do
            if checkpoint.blip then
                RemoveBlip(checkpoint.blip)
            end
            if checkpoint.checkpoint then
                DeleteCheckpoint(checkpoint.checkpoint)
            end
        end
    end
end