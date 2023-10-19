local sparticleEffects = {}

Citizen.CreateThread(function()
	Wait(3000)
    TriggerEvent('esx_status:registerStatus', 'hygiene', 1000000, '#CFAD0F',
        function(status) -- Visible calllback, if it return true the status will be visible
            return true
			end, function(status)
			status.remove(100)
    end)
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while true do
            TriggerEvent('esx_status:getStatus', 'hygiene', function(status) 
                hygiene = status.val
            end)
            TriggerEvent('esx_status:getStatus', 'hunger', function(status) 
                hunger = status.val  
            end)


            Citizen.Wait(10000)
        end
    end)
end)


RegisterNetEvent('renzu_hygiene:WashFace')
AddEventHandler('renzu_hygiene:WashFace', function(h)
    local plyPed = PlayerPedId()
    LoadDict("switch@michael@wash_face")
    SetEntityHeading(plyPed, h)
    TaskPlayAnim(plyPed, "switch@michael@wash_face", "loop_michael", 8.0, -8.0, 3.0, 0, 0.0, 0, 0, 0)
    Citizen.Wait(3000)
    ClearPedTasks(plyPed)
    TriggerEvent('esx_status:add', config.washface_effectstatus, config.washfaceadd_status)
end)

local showeropen = false
RegisterNetEvent('renzu_hygiene:takeshower')
AddEventHandler('renzu_hygiene:takeshower', function(plyPed,showerpos,s,entity)
    local plyPed = PlayerPedId()
    local showerpos = showerpos
    if GetEntityModel(plyPed) == -1667301416 then
        LoadDict("mp_safehouseshower@female@")
        LoadDict("anim@mp_yacht@shower@female@")
    else
        LoadDict("amb@world_human_bum_wash@male@high@idle_a")
        LoadDict("amb@world_human_bum_wash@male@high@base")
        LoadDict("amb@world_human_bum_wash@male@low@base")
        LoadDict("amb@world_human_bum_wash@male@low@idle_a")
        LoadDict("switch@michael@wash_face")
        LoadDict("anim@mp_yacht@shower@male@")
    end
    if entity ~= nil then -- prop based
        showerpos = GetEntityCoords(entity)
        showerpos = vector3(showerpos.x,showerpos.y,showerpos.z+0.2)
        s = {pos = showerpos, particle = "ent_amb_car_wash_jet", xRot = -180.0, nextWait = 0, h = GetEntityHeading(entity)}
    end
    showerpos = vector3(showerpos.x,showerpos.y,showerpos.z+0.5)
    if not showeropen then
        showeropen = true
        text = "Take Off Shower [E]"
        if entity ~= nil then
            s.pos = vector3(showerpos.x,showerpos.y,showerpos.z-0.8)
            TaskTurnPedToFaceEntity(plyPed,entity, 2000)
        else
            SetEntityHeading(plyPed, s.h)
        end
        TriggerServerEvent("renzu_hygiene:syncshower", s)
        if GetEntityModel(plyPed) == -1667301416 then
            TaskPlayAnim(plyPed, "mp_safehouseshower@female@", "shower_enter_into_idle", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
            Citizen.Wait(5000)
            TaskPlayAnim(plyPed, "anim@mp_yacht@shower@female@", "shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
            Citizen.Wait(5000)
            TaskPlayAnim(plyPed, "anim@mp_yacht@shower@female@", "shower_idle_b", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
            Citizen.Wait(5000)
            TaskPlayAnim(plyPed, "mp_safehouseshower@female@", "shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        else
            TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_d", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
            Citizen.Wait(5000)
            TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
            Citizen.Wait(5000)
            TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_c", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        end
        Citizen.Wait(5000)
        odor = 1000000
        TriggerEvent('esx_status:add', config.hygienestatus, 1000000)
        showeropen = false
        text = "Take Shower [E]"
        --StopAllParticles(showers[i])
        ClearPedTasks(plyPed)
    end
end)

RegisterNetEvent('renzu_hygiene:synclamok')
AddEventHandler('renzu_hygiene:synclamok', function(ent)
	if GetPlayerFromServerId(ent) ~= nil or GetPlayerFromServerId(ent) ~= 0 then
	local ent = GetPlayerPed(GetPlayerFromServerId(ent))
    local mycoords = GetEntityCoords(ent)
	local loopAmount = 25
	createdParticle = {}
	local asset = "core"
	local particleName = 'ent_amb_insect_swarm'
	RequestNamedPtfxAsset(asset)

	while not HasNamedPtfxAssetLoaded(asset) do
		Wait(100)
	end
    local particleEffects = {}
	for x=0,loopAmount do
		UseParticleFxAssetNextCall(asset)
		local particle = StartNetworkedParticleFxLoopedOnEntity(particleName, ent, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.45, false, false, false)
		table.insert(particleEffects, 1, particle)
		Citizen.Wait(0)
	end

	Citizen.Wait(8000)
	for _,particle in pairs(particleEffects) do
		StopParticleFxLooped(particle, true)
		RemoveParticleFx(particle, 0)
	end
	RemoveParticleFxFromEntity(ent)
	RemoveParticleFxInRange(mycoords.x,mycoords.y,mycoords.z)
	end
end)

RegisterNetEvent('renzu_hygiene:Wash')
AddEventHandler('renzu_hygiene:Wash', function(coords, id)
    local plyPed = PlayerPedId()
    TriggerEvent('renzu_notify:Notify','info','Info', 'You are now cleaning off your body dirt.')
    if GetEntityModel(plyPed) == -1667301416 then
        LoadDict("mp_safehouseshower@female@")
        LoadDict("anim@mp_yacht@shower@female@")
    else
        LoadDict("amb@world_human_bum_wash@male@high@idle_a")
        LoadDict("amb@world_human_bum_wash@male@high@base")
        LoadDict("amb@world_human_bum_wash@male@low@base")
        LoadDict("amb@world_human_bum_wash@male@low@idle_a")
        LoadDict("switch@michael@wash_face")
        LoadDict("anim@mp_yacht@shower@male@")
    end
    local hotel = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_ld_dstsign_01'))
    local mycoords = GetEntityCoords(PlayerPedId())
    local ligo = {pos = vector3(mycoords.x,mycoords.y,mycoords.z+0.3), particle = "ent_amb_car_wash_jet", xRot = -180.0, nextWait = 0, h=GetEntityHeading(PlayerPedId())}
    local plyPed = PlayerPedId()
    if GetEntityModel(plyPed) == -1667301416 then
        TaskPlayAnim(plyPed, "mp_safehouseshower@female@", "shower_enter_into_idle", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@female@", "shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@female@", "shower_idle_b", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
        TaskPlayAnim(plyPed, "mp_safehouseshower@female@", "shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
    else
        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_d", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_c", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
        Citizen.Wait(5000)
    end
    ClearPedTasks(plyPed)
    odor = 400
    TriggerEvent('esx_status:add', config.hygienestatus, 100000)
end)

local cdbaho = {}
RegisterNetEvent('renzu_hygiene:odoreffect')
AddEventHandler('renzu_hygiene:odoreffect', function(coords, id)
    if not antiodor and cdbaho[id] == nil or not antiodor and cdbaho[id] ~= nil and cdbaho[id] < GetGameTimer() then
        cdbaho[id] = GetGameTimer() + 10000
        local id = id
        local dist = GetDistance(GetEntityCoords(PlayerPedId()), coords)
        if dist < 40 then
            TriggerEvent('renzu_hygiene:synclamok', id)
        end
        if dist < 5.0 then
            if GetPlayerFromServerId(id) ~= PlayerId() then
                LoadDict("switch@trevor@bear_floyds_face_smell")
                TaskPlayAnim(PlayerPedId(), "switch@trevor@bear_floyds_face_smell", "bear_floyds_face_smell_loop_floyd", 8.0, -8.0, 3.0, 0, 0.0, 0, 0, 0)
                TriggerEvent('renzu_notify:Notify','warning','Oh no!', 'You feel uneasy because you smell something very bad..')
                SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) - config.badhygiene_hp_effect)
                TriggerEvent('esx_status:add', config.badhygienestatus_effect, config.badhygiene_effect_value)
            else
                TriggerEvent('renzu_notify:Notify','warning','Oh no!', 'i Smell like shit')
            end
        end
    end
end)


function GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		print("loading")
		Citizen.Wait(1)
	end
end

function StopAllParticles(actualZone)
    local mycoords = GetEntityCoords(PlayerPedId())
    for _,particle in pairs(sparticleEffects) do
		StopParticleFxLooped(particle, true)
        RemoveParticleFx(particle, 0)
        Citizen.Wait(0)
	end
	RemoveParticleFxFromEntity(PlayerPedId())
    RemoveParticleFxInRange(mycoords.x,mycoords.y,mycoords.z)
end




local text = "Wash Face [E]"
CreateThread(function()
    Wait(1000)
    while true do
        local sleep = 2000
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)
        for i = 1, #washface do
            local showerpos = washface[i].pos

            local distance = GetDistance(plyPos, showerpos)
            if distance < 1.5 then
                sleep = 0
                showerpos = vector3(showerpos.x,showerpos.y,showerpos.z+0.3)
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_hygiene:WashFace',
                    ['title'] = 'Press [E] Wash Face',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fad fa-hands-wash"></i>',
                    ['custom_arg'] = {washface[i].h}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while distance <= 3.2 do
                    distance = GetDistance(GetEntityCoords(plyPed), showerpos)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
        end
        Citizen.Wait(sleep)
    end
end)



Citizen.CreateThread(function()
    Wait(1000)
    if config.enablepropbase then
        while true do
            local sleep = 3000
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            for k,v in pairs(config.showerprop) do
                local shower = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, GetHashKey(v))
                if shower ~= 0 then
                    sleep = 500
                    local showerpos = GetEntityCoords(shower)
                    showerpos = vector3(showerpos.x,showerpos.y,showerpos.z+0.2)
                    distance = #(GetEntityCoords(PlayerPedId()) - showerpos)
                    if distance <= 2 then
                        local table = {
                            ['key'] = 'E', -- key
                            ['event'] = 'renzu_hygiene:takeshower',
                            ['title'] = 'Press [E] Take a Shower',
                            ['server_event'] = false, -- server event or client
                            ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                            ['fa'] = '<i class="fas fa-shower"></i>',
                            ['custom_arg'] = {ped,false,false,shower}, -- example: {1,2,3,4}
                        }
                        TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                        while distance <= 3.4 do
                            distance = #(GetEntityCoords(PlayerPedId()) - showerpos)
                            Wait(500)
                        end
                        TriggerEvent('renzu_popui:closeui')
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end
end)


CreateThread(function()
    Wait(1000)
    while true do
        local sleep = 2000
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)
        for i = 1, #showers do
            local showerpos = showers[i].pos

            local distance = GetDistance(plyPos, showerpos)
            if distance < 1.4 then
                showerpos = vector3(showerpos.x,showerpos.y,showerpos.z+0.2)
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_hygiene:takeshower',
                    ['title'] = 'Press [E] Take a Shower',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-shower"></i>',
                    ['custom_arg'] = {plyPed,showerpos,showers[i]}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while distance <= 3.2 do
                    distance = GetDistance(GetEntityCoords(plyPed), showerpos)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
        end
        Citizen.Wait(sleep)
    end
end)


RegisterNetEvent('renzu_hygiene:syncshower')
AddEventHandler('renzu_hygiene:syncshower', function(actualZone, coord, id, sex)
    Citizen.CreateThread(function ()
        local id = id
        local dist = GetDistance(GetEntityCoords(PlayerPedId()), coord)
        if dist < 40 then
            playsound(coord,4,'shower',0.7)
            if GetPlayerFromServerId(id) ~= nil or GetPlayerFromServerId(id) ~= 0 then
                local PlayerPed = GetPlayerPed(GetPlayerFromServerId(id))
                local asset = "scr_carwash"
                local currentParticle = actualZone
                local loopAmount = 0
                RequestNamedPtfxAsset(asset)

                while not HasNamedPtfxAssetLoaded(asset) do
                    Wait(100)
                end
                sparticleEffects[id] = {}
                -- Loop from 0 to the loop amount defined above.
                for x=0,loopAmount do
                    UseParticleFxAssetNextCall(asset)
                    --bone = GetPedBoneIndex(PlayerPed, 11816)
                    local pos = vector3(currentParticle.pos.x,currentParticle.pos.y,currentParticle.pos.z+1.0)
                    local particle = StartParticleFxLoopedAtCoord(currentParticle.particle, pos.x,pos.y,pos.z, -180.0, 0.0, 0.0, 1.0, 0, 0, 0)
                    table.insert(sparticleEffects[id], 1, particle)
                    Citizen.Wait(500)
                end
                
                Citizen.Wait(20000)
                local mycoords = GetEntityCoords(PlayerPed)
                for _,particle in pairs(sparticleEffects[id]) do
                    StopParticleFxLooped(particle, true)
                    RemoveParticleFx(particle, 0)
                    Citizen.Wait(0)
                end
                RemoveParticleFxFromEntity(PlayerPed)
                sparticleEffects[id] = {}
            end
        end
    end)
end)


Citizen.CreateThread(function()
    Wait(100)
    if config.testcommand then
        RegisterCommand('toilet', function()
            local wheelchair = CreateObject(GetHashKey('prop_toilet_01'), GetEntityCoords(PlayerPedId()), true)
            PlaceObjectOnGroundProperly(wheelchair)
            FreezeEntityPosition(wheelchair, true)
        end, false)

        RegisterCommand('shower', function()
            --LoadModel('boxing')
            LoadModel('ligoshower')
            local wheelchair = CreateObject(GetHashKey('ligoshower'), GetEntityCoords(PlayerPedId()), true)
            PlaceObjectOnGroundProperly(wheelchair)
            FreezeEntityPosition(wheelchair, true)
        end, false)
    end
end)

function playsound(ecoord,max,file,maxvol)
	local volume = maxvol
	local mycoord = GetEntityCoords(PlayerPedId())
	local distIs  = tonumber(string.format("%.1f", #(mycoord - ecoord)))
	if (distIs <= max) then
		distPerc = distIs / max
		volume = (1-distPerc) * maxvol
		local table = {
			['file'] = file,
			['volume'] = volume
		}
		SendNUIMessage({
			type = "playsound",
			content = table
		})
	end
end


