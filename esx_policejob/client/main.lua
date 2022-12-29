local CurrentActionData, handcuffTimer, blipsCops, currentTask = {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
isInShopMenu = false
ESX = nil
local DragStatus = {}
DragStatus.IsDragged = false
local canplace = true

local keyThread

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while ESX.IsPlayerLoaded() ~= true do
		Citizen.Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	ESX.PlayerData = ESX.GetPlayerData()
	jobName = PlayerData.job.name
	UpdateJob(PlayerData.job, nil)
	keyThread:start()
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

local allVehicles = nil
function LoadGovernmentVehicles()
	allVehicles = {}
	for job, ranks in pairs(Config.AuthorizedVehicles) do
		for rank, vehicles in pairs(ranks) do
			for k, vehicle in pairs(vehicles) do
				allVehicles[vehicle.model] = vehicle
				allVehicles[GetHashKey(vehicle.model)] = vehicle
			end
		end
	end
end

Citizen.CreateThread(function()
	if Config.EnableCarGarageBlip == true then	
		for k,v in pairs(Config.CarZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarGarageSprite)
				SetBlipDisplay(blip, Config.CarGarageDisplay)
				SetBlipScale  (blip, Config.CarGarageScale)
				SetBlipColour (blip, Config.CarGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

local insideMarker = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
		
		if (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceDatabaseName) then
			for k,v in pairs(Config.CarZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 10.0) and insideMarker == false then
						DrawMarker(Config.PoliceCarMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-2.20, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.PoliceCarMarkerScale.x, Config.PoliceCarMarkerScale.y, Config.PoliceCarMarkerScale.y, Config.PoliceCarMarkerColor.r,Config.PoliceCarMarkerColor.g,Config.PoliceCarMarkerColor.b,Config.PoliceCarMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						ESX.ShowHelpNotification("Druk ~INPUT_CONTEXT~ om je voertuig op te slaan")
						if IsControlJustPressed(0, Config.KeyToOpenCarGarage) then
							print(("%s %s %s"):format(coords, veh, pedInVeh))
							PoliceGarage('car')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end
		end
	end
end)

PoliceGarage = function(type)
	local elements = {
		{ label = Config.LabelStoreVeh, action = "store_vehicle" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeGarage_menu",
		{
			title    = Config.TitlePoliceGarage,
			align    = "top-right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		local action = data.current.action
		if action == "get_vehicle" then
			if type == 'car' then
				VehicleMenu('car')
			end
		elseif data.current.action == 'store_vehicle' then
			local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
			if dist < 3 then
				DeleteEntity(veh)
				ESX.ShowNotification(Config.VehicleParked)
			else
				ESX.ShowNotification(Config.NoVehicleNearby)
			end
			insideMarker = false
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

function IsGovernmentVehicle(model)
	if not allVehicles then
		LoadGovernmentVehicles()
	end

	return allVehicles[model] and true or false
end

function IsAuthorizedJobOnly(job)
	job = job or jobName
	return Config.Jobs[job] or false
end

function IsAuthorized(job)
	if OnDuty then
		return true
	end
	job = job or jobName

	return Config.Jobs[job] or false
end

function IsDsi()
	return (Config.DsiJobs[jobName] and Config.DsiRanks[PlayerData.job.grade_name]) or false
end

function IsRecherche()
	return (Config.RechercheJobs[jobName] and Config.RechercheRanks[PlayerData.job.grade_name]) or false
end

function IsOffDsi()
	return (Config.DsiJobs[jobName] and Config.DsiRanks[PlayerData.job.grade_name]) or false
end

function IsOffRecherche()
	return (Config.RechercheJobs[jobName] and Config.RechercheRanks[PlayerData.job.grade_name]) or false
end

function HasLightbars()
	return (Config.HasLightbarsJob[jobName] and Config.HasLightbarRanks[PlayerData.job.grade_name]) or false
end

function IsGovernmentJob(job)
	job = (job or jobName or ""):gsub("off", "")
	if Config.Jobs[job] then
		return true
	end

	if job == "mechanic" or job == "ambulance" then
		return true
	end
	return false
end

function IsGovernmentJobOnDuty(job)
	job = job or jobName or ""
	if Config.Jobs[job] then
		return true
	end

	if job == "mechanic" or job == "ambulance" then
		return true
	end
	return false
end

exports("IsAuthorized", IsAuthorized)
exports("IsDsi", IsDsi)
exports("IsBsb", IsBsb)
exports("IsRecherche", IsRecherche)
exports("IsOffRecherche", IsOffRecherche)
exports("HasLightbars", HasLightbars)
exports("IsGovernmentJob", IsGovernmentJob)
exports("IsGovernmentJobOnDuty", IsGovernmentJobOnDuty)





RegisterCommand('arm', function()
	if IsDsi() then
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		local model = GetEntityModel(vehicle)
		DisableAllVehicleWeapons(vehicle, model, false)
	end
end)

RegisterCommand('disarm', function()
	if IsDsi() then
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		local model = GetEntityModel(vehicle)
		DisableAllVehicleWeapons(vehicle, model, true)
	end
end)

function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = Config.Uniforms[uniform].male
		else
			uniformObject = Config.Uniforms[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = _U('citizen_wear'), value = 'citizen_wear'}
		--{label = '----------------------------------------', uniform = '-'},
	}


	if Config.EnableCustomPeds then
		for k,v in ipairs(Config.CustomPeds.shared) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end

		for k,v in ipairs(Config.CustomPeds[grade]) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableCustomPeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.EnableESXService then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')

						TriggerServerEvent('esx_service:disableService', 'police')
						TriggerEvent('esx_policejob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'police')
			end
		end

		if Config.EnableESXService and data.current.value ~= 'citizen_wear' then
			local awaitService

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					if Config.MaxInService == -1 then
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if not canTakeService then
								ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
							else
								awaitService = true
								playerInService = true

								local notification = {
									title    = _U('service_anonunce'),
									subject  = '',
									msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
									iconType = 1
								}

								TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
								TriggerEvent('esx_policejob:updateBlip')
								ESX.ShowNotification(_U('service_in'))
							end
						end, 'police')
					else
						awaitService = true
						playerInService = true

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
						TriggerEvent('esx_policejob:updateBlip')
						ESX.ShowNotification(_U('service_in'))
					end

				else
					awaitService = true
				end
			end, 'police')

			while awaitService == nil do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not awaitService then
				return
			end
		end

		if data.current.uniform then
			setUniform(data.current.uniform, playerPed)
		elseif data.current.value == 'freemode_ped' then
			local modelHash

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)
					SetPedDefaultComponentVariation(PlayerPedId())

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('buy_weapons'), value = 'buy_weapons'}
	}

	if Config.EnableArmoryManagement then
		table.insert(elements, {label = _U('put_weapon'),     value = 'put_weapon'})
        table.insert(elements, {label = _U('delete_weapon'),  value = 'delete_weapon'})
		table.insert(elements, {label = _U('deposit_object'), value = 'put_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
         elseif data.current.value == 'delete_weapon' then
			OpenPutWeaponMenu(false)
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

----------------- Marker Thread ------------------------------

Citizen.CreateThread(function()
    while true do 
        while Playerjob == nil do Wait(500) end
        Wait(0)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local sleep = true
        while Playerjob == nil do Wait(500) end
        for k,v in pairs(Config.Markers) do 
            local dist = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
            if Playerjob.name == 'police' or Playerjob.name == 'kmar' then 
                if dist < 10 then 
                    slapen = false
                    DrawMarker(20,v.x, v.y, v.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.3, 0.2, 65,105,225, 100, false, true, 2, true, nil, nil, false)

                    if dist < 2 then 
                        DrawScriptText(vector3(v.x, v.y, v.z), v.text) 

                        if IsControlJustReleased(0, v.key) then 
                            TriggerEvent(v.trigger)
                        end
                    end
                end
            else
                Wait(10000)
            end
        end
        if slapen then 
            Wait(500)
        end
    end
end)

function IsStandingBehindPed(ped)
	if IsPedRagdoll(ped) then
		return true
	end
	local offset = GetOffsetFromEntityGivenWorldCoords(ped, GetEntityCoords(PlayerPedId()))

	if offset.y < 0 then
		return true
	end

	return false
end

RegisterNetEvent('esx_policejob:revive')
AddEventHandler('esx_policejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(PlayerPedId(), formattedCoords, 0.0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

function IsStandingBehindPlayer(player)
	return IsStandingBehindPed(GetPlayerPed(player))
end

local jobnaam = ""

function OpenpoliceActionsMenu()
	local playerPed = PlayerPedId()
	local ondelay = false
	local ondelay1 = false
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'Politie',
		align    = 'top-right',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			{label = _U('object_spawner'),		value = 'object_spawner'},
			{label = "Gevangenis Menu",         value = 'jail_menu'},
			{label = "Taakstraffen Menu",       value = 'taakstraf_menu'}
		}
	}, function(data, menu)

		-- esx_qalle_jail-begin
		if data.current.value == 'jail_menu' then
			print("speler naar de gevangenis gestuurt voor %%%%%% maanden")
            TriggerEvent("esx-qalle-jail:openJailMenu")
		end
		-- esx_qalle_jail-end
		-- esx_communityservice-begin

		if data.current.value == 'taakstraf_menu' then
			print("speler naar de gevangenis gestuurt voor %%%%%% maanden")
            TriggerEvent("esx_communityservice:openTaakstrafMenu")
		end

		if data.current.value == 'citizen_interaction' then
			local playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

			print(#playersNearby)
			if #playersNearby > 0 then
				local players, elements = {}, {}

				local playerId = PlayerId()
				for k,player in ipairs(playersNearby) do
					local ped = GetPlayerPed(player)
                    if player ~= playerId then
                        local serverId = GetPlayerServerId(player)
                        table.insert(elements, {
							label = serverId,
							playerId = serverId
						})
                    end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_selection', {
					title    = "Voer actie uit op...",
					align    = 'top-right',
					elements = elements
				}, function(playerSelectData, playerSelectMenu)
					local selectedPlayer = GetPlayerFromServerId(playerSelectData.current.playerId)
					local coords = GetEntityCoords(playerPed)

					local elements = {
						{label = _U('search'),			value = 'body_search'},
						{label = _U('id_card'),			value = 'identity_card'},
						{label = 'Rijbewijs',			value = 'driver_license'},
						--{label = 'DNA monster verzamelen', value = 'grab_dna'},
						{label = _U('handcuff'),		value = 'handcuff'},
						{label = _U('uncuff'),			value = 'uncuff'},
						{label = _U('drag'),			value = 'drag'},
						{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
						{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
						{label = _U('fine'),			value = 'fine'},
						{label = _U('unpaid_bills'),	value = 'unpaid_bills'},
						{label = 'Reanimeren',	value = 'revive'},
					}
					



					if Config.EnableLicenses then
						table.insert(elements, { label = _U('license_check'), value = 'license' })
					end
					
					if #(GetEntityCoords(GetPlayerPed(selectedPlayer)) - coords) < 10.0 then
						ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'citizen_interaction',
						{
							title    = _U('citizen_interaction'),
							align    = 'top-right',
							elements = elements
						}, function(interactionData, interactionMenu)
							coords = GetEntityCoords(PlayerPedId())
							local closestPlayer, closestDistance = selectedPlayer, #(GetEntityCoords(GetPlayerPed(selectedPlayer)) - coords)

							if closestPlayer ~= -1 and #(GetEntityCoords(GetPlayerPed(selectedPlayer)) - coords) <= 10.0 then
								local action = interactionData.current.value
								local serverPlayer = GetPlayerServerId(closestPlayer)
								local ownServerId = GetPlayerServerId(PlayerId())

								if serverPlayer == -1 then
									return
								end
								


								if action == 'identity_card' then
									TriggerServerEvent('jsfour-idcard:open', serverPlayer, GetPlayerServerId(PlayerId()))
									interactionMenu.close()
									local target = closestPlayer
									playerCoords = GetEntityCoords(GetPlayerPed(-1))
									local target_distance = GetEntityCoords(GetPlayerPed(target))
									local distance = #(target_distance - playerCoords)
									if distance <= 5.0 then
										OpenIdentityCardMenu(closestPlayer)
									else
										ESX.ShowNotification('Speler niet gevonden.')
									end
									TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), "Je ~y~ID kaart~s~ is gepakt door de ~b~" .. jobnaam)
									TriggerServerEvent('jsfour-idcard:open', serverPlayer, ownServerId)
									interactionMenu.close()
								elseif action == 'driver_license' then
									TriggerServerEvent('jsfour-idcard:open', serverPlayer, GetPlayerServerId(PlayerId()), 'driver')
									TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), "Je ~y~Rijbewijs~s~ is gepakt door de ~b~" .. jobnaam)
									interactionMenu.close()
								elseif action == 'grab_dna' then
									TriggerEvent('jsfour-dna:get', closestPlayer)
								elseif action == 'body_search' then
									TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), "Je word ~y~gefouilleerd~s~ door de ~b~" .. jobnaam)
									OpenBodySearchMenu(selectedPlayer)
								elseif action == 'handcuff' then
									playerheading = GetEntityHeading(GetPlayerPed(-1))
									playerlocation = GetEntityForwardVector(PlayerPedId())
									playerCoords = GetEntityCoords(GetPlayerPed(-1))
									local target = closestPlayer
									local target_id = GetPlayerServerId(target)
									local target_distance = GetEntityCoords(GetPlayerPed(target))
									local distance = #(target_distance - playerCoords)
									if not IsStandingBehindPlayer(target) then
										ESX.ShowNotification("~r~Je kunt alleen iemand van achter boeien!~s~")
										return
									end
									if distance <= 2.0 then
										if ondelay == false then
											ondelay = true
											TriggerServerEvent('esx_ruski_areszt:startAreszt', GetPlayerServerId(closestPlayer))								-- Rozpoczyna Funkcje na Animacje (Cala Funkcja jest Powyzej^^^)
											Citizen.Wait(1790)																									-- Czeka 2.1 Sekund**
											TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuffeffect', 0.9)
											Citizen.Wait(1500)																									-- Czeka 3.1 Sekund**
											TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
											ondelay = false
										end
									-- elseif action == 'handcuff' then
									-- 	TriggerServerEvent('esx_gangjob:handcuff', GetPlayerServerId(closestPlayer))
									-- elseif action == 'drag' then
									-- 	TriggerServerEvent('esx_gangjob:drag', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('Speler niet gevonden.')
									end
								elseif action == 'uncuff' then
									if not IsStandingBehindPlayer(selectedPlayer) then
										ESX.ShowNotification("~r~Je kunt alleen iemand van achter ontboeien!~s~")
										return
									end
									local target = closestPlayer
									local playerheading = GetEntityHeading(PlayerPedId())
									local playerVector = GetEntityForwardVector(PlayerPedId())
									local playerCoords = GetEntityCoords(PlayerPedId())
									local target_id = GetPlayerServerId(target)
									local target_distance = GetEntityCoords(GetPlayerPed(target))
									local distance = #(target_distance - playerCoords)
									if distance <= 2.0 then
										if ondelay == false then
											ondelay = true
											TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerVector)
											TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
											Wait(6000)
											ondelay = false
										end
									else
										ESX.ShowNotification('Speler niet gevonden.')
									end
								elseif action == 'drag' then
									if not IsStandingBehindPlayer(selectedPlayer) then
										ESX.ShowNotification("~r~Je kunt alleen iemand van achter escorteren!~s~")
										return
									end
									StartDragging(serverPlayer)
								elseif action == 'put_in_vehicle' then
									local target = closestPlayer
									playerCoords = GetEntityCoords(GetPlayerPed(-1))
									local target_distance = GetEntityCoords(GetPlayerPed(target))
									local distance = #(target_distance - playerCoords)
									if distance <= 3.0 then
										TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('Speler niet gevonden.')
									end
								elseif action == 'out_the_vehicle' then
									TriggerServerEvent('esx_policejob:OutVehicle', serverPlayer, `esx_policejob:OutVehicle`)
								elseif action == 'fine' then
									local target = closestPlayer
									playerCoords = GetEntityCoords(GetPlayerPed(-1))
									local target_distance = GetEntityCoords(GetPlayerPed(target))
									local distance = #(target_distance - playerCoords)
									if distance <= 10.0 then
										OpenFineMenu(closestPlayer)
									else
										ESX.ShowNotification('Speler niet gevonden.')
									end
								elseif action == 'license' then
									ShowPlayerLicense(closestPlayer)
								elseif action == 'unpaid_bills' then
									OpenUnpaidBillsMenu(closestPlayer)
								elseif action == 'criminal_record' then
									TriggerEvent('criminalrecord:open')
								elseif action == 'revive' then
									if not IsBusy then
										IsBusy = true
										local closestPlayerPed = GetPlayerPed(closestPlayer)
											if IsPedDeadOrDying(closestPlayerPed, 1) or IsEntityDead(closestPlayerPed) then
												ESX.ShowNotification(_U('revive_inprogress'))

												local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

												for i=1, 15, 1 do
													Citizen.Wait(900)

													LoadAnimDict(lib)
													TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
												end

												TriggerServerEvent('esx_policejob:revive', serverPlayer, `esx_policejob:revive`)

												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											else
												ESX.ShowNotification(_U('player_not_unconscious'))
										end

										IsBusy = false
									end

								elseif action == 'take_pulse' then
									if closestDistance < 10.0 then
										TriggerServerEvent('medSystem:updateMed', GetPlayerServerId(closestPlayer))
									end
								end
							else
								ESX.ShowNotification(_U('no_players_nearby'))
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					else
						ESX.ShowNotification("Deze speler is te ver weg gelopen...")
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				ESX.ShowNotification(_U('no_players_nearby'))
			end
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local vehicle, distance = ESX.Game.GetClosestVehicle()
			
			if distance < 4.0 and DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
			end
			
			table.insert(elements, {label = _U('search_database'),  value = 'search_database'})

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = _U('vehicle_interaction'),
				align    = 'top-right',
				elements = elements
			}, function(data2, menu2)
				coords  = GetEntityCoords(playerPed)
				local vehicle, distance = ESX.Game.GetClosestVehicle()
				action  = data2.current.value
				
				if action == 'search_database' then
					LookupVehicle()

				elseif action == 'fine_vehicle' then
					FineVehicle()
				elseif distance < 4.0 and DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if action == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData, vehicle)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.Wait(20000)
							local timeout = 0
							NetworkRequestControlOfEntity(vehicle)
							while not NetworkHasControlOfEntity(vehicle) and timeout < 2000 do
								timeout = timeout + 100
								Citizen.Wait(100)
								NetworkRequestControlOfEntity(vehicle)
							end
							ClearPedTasks(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							TriggerEvent("unlockvehicle", vehicle)
							TriggerEvent("nocarjack:addVehicle", NetworkGetNetworkIdFromEntity(vehicle))
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
					
						-- is the script busy?
						if CurrentTask.Busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						
						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)
						
						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
							
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('traffic_interaction'),
				align    = 'top-right',
				elements = {
					{label = _U('cone'),		model = 'prop_roadcone02a'},
					{label = _U('barrier'),		model = 'prop_barrier_work05'},
					-- {label = _U('spikestrips'),	model = 'p_ld_stinger_s'},
					{label = _U('box'),			model = 'prop_boxpile_07d'},
					{label = _U('cash'),		model = 'hei_prop_cash_crate_half_full'},
                    {label = 'Hek pijl', 		model = 'prop_mp_arrow_barrier_01'},
					{label = 'Barricade', 		model = 'prop_mp_barrier_01', freeze = true},
					{label = 'LCD',				model = 'prop_trafficdiv_01'},
					{label = 'Schotten', 		model = 'prop_snow_sign_road_06g', freeze = true},
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local objectCoords = (coords + forward * 1.0)
				local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
				if canplace then
					print(("prop coords: %s \ncoords: (%s)"):format(objectCoords, coords))
					ESX.Streaming.RequestAnimDict(dict)
					TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
					ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
						SetEntityHeading(obj, GetEntityHeading(playerPed))
						PlaceObjectOnGroundProperly(obj)
						canplaceprop()
					end)
				else
					ESX.ShowNotification("Wacht even voordat je weer een object plaatst")
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function canplaceprop()
	canplace = false
	Wait(5000)
	canplace = true
end



function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}
		local nameLabel = _U('name', data.name)
		local --[[jobLabel, ]]sexLabel, dobLabel, heightLabel, idLabel

		--[[if data.job.grade_label and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
		]]
		if Config.EnableESXIdentity then
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			--[[if data.name then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end]]
		end

		local elements = {
			{label = nameLabel}--,
			--[[{label = jobLabel}]]
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel})
			table.insert(elements, {label = dobLabel})
			table.insert(elements, {label = heightLabel})
			--table.insert(elements, {label = idLabel})
		end

		--[[if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end]]

		--[[if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end]]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenIdentityCardMenu2(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {
			{label = _U('name', data.name)},
			{label = _U('job', ('%s - %s'):format(data.job, data.grade))}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = _U('sex', _U(data.sex))})
			table.insert(elements, {label = _U('dob', data.dob)})
			table.insert(elements, {label = _U('height', data.height)})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				--ESX.ShowNotification("Je kunt niet confisceren!")
				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-right',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3},
			{label = 'Aangepast bedrag', value = -1}
	}}, function(data, menu)
		if data.current.value == -1 then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fine2', {
				title = 'Boete bedrag',
			}, function (data2, menu)
				local amount = tonumber(data2.value)
				if (amount == nil or amount < 0 or amount > 200000.0) and PlayerData.job.grade_name ~= 'boss' then
					ESX.ShowNotification('Ongeldig of te hoog bedrag (max 200k)')
				else
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fine2', {
						title = 'Boete beschrijving',
					}, function (data3, menu2)
						local label = data3.value
						if label == nil then
							ESX.ShowNotification("Geef aub een geldige boete naam in!")
							return
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', label), amount)
							menu2.close()
						end
					end, function (data3, menu2)
						menu2.close()
					end)
				end
			end, function (data2, menu)
				menu.close()
			end)
		else
			OpenFineCategoryMenu(player, data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function SendToCommunityService(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
		title = "Community Service Menu",
	}, function (data2, menu)
		local community_services_count = tonumber(data2.value)

		if community_services_count == nil then
			ESX.ShowNotification('Invalid services count.')
		else
			TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end



function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if not data.value or length < 2 or length > 8 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
				local elements = {{label = _U('plate', retrivedInfo.plate)}}
				menu.close()

				if not retrivedInfo.owner then
					table.insert(elements, {label = _U('owner_unknown')})
				else
					table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
					title    = _U('vehicle_info'),
					align    = 'top-right',
					elements = elements
				}, nil, function(data2, menu2)
					menu2.close()
				end)
			end, data.value)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(playerData)
		if playerData.licenses then
			for i=1, #playerData.licenses, 1 do
				if playerData.licenses[i].label and playerData.licenses[i].type then
					table.insert(elements, {
						label = playerData.licenses[i].label,
						type = playerData.licenses[i].type
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, playerData.name))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end



function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bill.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if not retrivedInfo.owner then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.AuthorizedWeapons[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'top-right',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, lastJob)
	UpdateJob(job, lastJob)
	ESX.PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('esx_policejob:forceBlip')

	
end)

function UpdateJob(job, lastJob)
	PlayerData.job = job
	jobName = job.name
	if exports["policeexports"]:ispoliceorkmar() == true or exports["policeexports"]:isneventaak() == true then
		-- Wait one tick, in case job changes from one porto job to another
		Citizen.Wait(0)
		TriggerEvent("VehicleTransport:EnableRamp", true, GetCurrentResourceName())
	else
		if lastJob and IsAuthorized(lastJob.name) then
			exports["porto"]:SetRadioOn(false)
			local channel = exports["porto"]:GetChannel()
		end
		TriggerEvent("VehicleTransport:EnableRamp", false, GetCurrentResourceName())
	end
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Police',
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters2' then
		CurrentAction     = 'Helicopters2'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'VehicleDeleters' then

			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)
		
			if IsPedInAnyVehicle(playerPed,  false) then
		
			  local vehicle = GetVehiclePedIsIn(playerPed, false)
		
			  if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			  end
		
			end
		
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
	end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:CuffPlayerAnim')
AddEventHandler('esx_policejob:CuffPlayerAnim', function()
	LoadAnimationDictionary("mp_arrest_paired")
	TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
	if AnimationComplete(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 0.89, 300) then
		ClearPedTasks(GetPlayerPed(-1))
	end
end)

AddEventHandler("isHandcuffed", function(cb)
	if not cb then
		return
	end

	if IsHandcuffed then
		cb(IsHandcuffed)
	end
end)

function SetHandcuffed(value)
	IsHandcuffed = value
	TriggerEvent("onHandcuff", IsHandcuffed)
	GlobalState.handcuffed = value
	SetResourceKvp(("%s_IsHandcuffed"):format(GetCurrentServerEndpoint()), json.encode(IsHandcuffed))
	if value then
		DecorSetBool(PlayerPedId(), "_IS_HANDCUFFED", true)
	else
		DecorRemove(PlayerPedId(), "_IS_HANDCUFFED")
	end
	StartHandcuff()
end

function StartHandcuff()
	local playerPed = PlayerPedId()


	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			StartHandcuffThread()
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then
				if handcuffTimer.active then
					ESX.ClearTimeout(handcuffTimer.task)
				end
	
				StartHandcuffTimer()
			end
		else

			if Config.EnableHandcuffTimer and handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end
	
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end

local pushingAnimDict = "switch@trevor@escorted_out"
local pushingAnim = "001215_02_trvs_12_escorted_out_idle_guard2"
local running = false
function StartDragging(serverPlayer)
	TriggerServerEvent('esx_policejob:drag', serverPlayer, `esx_policejob:drag`)
	DragStatus.IsDragging = true
	DragStatus.TargetId = serverPlayer
	if running then
		return
	end

	running = true
	Citizen.CreateThread(function()
		while DragStatus.IsDragging do
			Citizen.Wait(0)
			DisableControlAction(2, 21, true)
			local playerPed = PlayerPedId()
			local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.TargetId))
			if not IsEntityAttachedToEntity(targetPed, playerPed) then
				Citizen.Wait(500)
				if not IsEntityAttachedToEntity(targetPed, playerPed) then
					DragStatus.IsDragging = false
				end
			end
			local isWalking = IsPedWalking(playerPed)
			local isPlayingAnim = IsEntityPlayingAnim(playerPed, pushingAnimDict, pushingAnim, 3)
			if isWalking and not isPlayingAnim then
				LoadDict(pushingAnimDict)
				TaskPlayAnim(playerPed, pushingAnimDict, pushingAnim, 2.0, 2.0, -1, 51, 0, false, false, false)
			elseif not isWalking and isPlayingAnim then
				StopAnimTask(playerPed, pushingAnimDict, pushingAnim, -4.0)
			end
		end
		running = false
		ClearPedTasks(GetPlayerPed(-1))
	end)
end


local walkingAnimDict = "anim@move_m@grooving@"
local walkingAnim = "walk"
function SetIsDragged(value)
	if not value and DragStatus.IsDragged then
		ReleasePed()
	end

	DragStatus.IsDragged = value
end

function ReleasePed()
	DragStatus.IsDragged = false
	DetachEntity(PlayerPedId(), true, false)
	StopAnimTask(PlayerPedId(), walkingAnimDict, walkingAnim)
end


RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID)
	if not IsHandcuffed then
		return
	end
	
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
	
end)

RegisterNetEvent('sts:uncuff')
AddEventHandler('sts:uncuff', function(source)
	print("uncuffed")
	if IsHandcuffed then
		TriggerEvent('esx_policejob:handcuff', source)
	end
end)

cancuffself = true
RegisterCommand('cuffme', function(source)
	if cancuffself then
		TriggerEvent('esx_policejob:handcuff', source)
		cancuffself = false
		Wait(1000)
		cancuffself = true
	end
end)

RegisterCommand('sendbill', function(source, args, raw)
	label = args[1]
	amount = args[2]
	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', _U('fine_total', label), amount)
end)

--TriggerServerEvent('esx_billing:sendvrpBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)

function LoadDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end
end

local running = false
function StartHandcuffThread()
	if running then
		return
	end


	running = true
	-- Handcuff
	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(1)
		
			local playerPed = PlayerPedId()
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 137, true)
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			--DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 244, true) -- Disable Phone

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			-- DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		end
	end)

	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(0)
			local playerPed = PlayerPedId()
			SetPedMoveRateOverride(playerPed, 0.8)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 22, true)

			if DragStatus.IsDragged then
				local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.0, 0.64, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					SetIsDragged(false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					SetIsDragged(false)
				end

				local isPlayingAnim = IsEntityPlayingAnim(playerPed, walkingAnimDict, walkingAnim, 3)
				local isCopWalking = IsPedWalking(targetPed)
				if isCopWalking and not isPlayingAnim then
					LoadDict(walkingAnimDict)
					TaskPlayAnim(playerPed, walkingAnimDict, walkingAnim, 2.0, 2.0, -1, 1, 0, false, false, false)
				elseif not isCopWalking and isPlayingAnim then
					StopAnimTask(playerPed, walkingAnimDict, walkingAnim, -4.0)
				end
				
			else
				DetachEntity(playerPed, true, false)
			end
		end

		running = false
	end)
end

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	SetHandcuffed(not IsHandcuffed)
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		SetHandcuffed(false)
		if DragStatus.IsDragged then
			SetIsDragged(false)
		end

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
		TriggerEvent("afkkick:Resume", 'esx_policejob:handcuff')
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)



	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle, distance = ESX.Game.GetClosestVehicle()

		if distance < 4.0 and DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				SetIsDragged(false)
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
    local playerPed = PlayerPedId()

    if IsPedSittingInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        TaskLeaveVehicle(playerPed, vehicle, 64)
    end
end)

-- Handcuff
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if isHandcuffed then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 137, true)
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 244, true) -- Disable Phone

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			-- DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.policeStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.policeStations) do
		local blip2 = AddBlipForCoord(v.Blip2.Coords)

		SetBlipSprite (blip2, v.Blip2.Sprite)
		SetBlipDisplay(blip2, v.Blip2.Display)
		SetBlipScale  (blip2, v.Blip2.Scale)
		SetBlipColour (blip2, v.Blip2.Colour)
		SetBlipAsShortRange(blip2, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.policeStations) do
		local blip3 = AddBlipForCoord(v.Blip3.Coords)

		SetBlipSprite (blip3, v.Blip3.Sprite)
		SetBlipDisplay(blip3, v.Blip3.Display)
		SetBlipScale  (blip3, v.Blip3.Scale)
		SetBlipColour (blip3, v.Blip3.Colour)
		SetBlipAsShortRange(blip3, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Draw markers and more
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.policeStations) do
				for i=1, #v.Cloakrooms, 1 do
					local distance = #(playerCoords - v.Cloakrooms[i])

					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerType.Cloakrooms, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
						end
					end
				end

				for i=1, #v.Armories, 1 do
					local distance = #(playerCoords - v.Armories[i])

					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerType.Armories, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				end

				for i=1, #v.Vehicles, 1 do
					local distance = #(playerCoords - v.Vehicles[i].Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerType.Vehicles, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
						end
					end
				end

				for i=1, #v.Helicopters, 1 do
					local distance =  #(playerCoords - v.Helicopters[i].Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerType.Helicopters, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
						end
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
					  DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				  end

				  for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
					  isInMarker     = true
					  currentStation = k
					  currentPart    = 'VehicleDeleters'
					  currentPartNum = i
					end
				  end

				if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = #(playerCoords - v.BossActions[i])

						if distance < Config.DrawDistance then
							DrawMarker(Config.MarkerType.BossActions, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
							end
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full',
		'prop_mp_arrow_barrier_01',
		'prop_mp_barrier_01',
		'prop_trafficdiv_01',
		'oes_politielint',
		'prop_snow_sign_road_06g',
		'oes_lijktent1',
		'oes_lijktent2',
		'prop_toolchest_01',
		'prop_mp_arrow_barrier_01',
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance = #(playerCoords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then

				if CurrentAction == 'menu_cloakroom' then
					ExecuteCommand('eup')
				elseif CurrentAction == 'menu_armory' then
					if not Config.EnableESXService then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'menu_vehicle_spawner' then
					if not Config.EnableESXService then
						OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					elseif playerInService then
						OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'Helicopters' then
					if not Config.EnableESXService then
						OpenHelicoptersSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					elseif playerInService then
						OpenHelicoptersSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end

				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end -- CurrentAction end


		if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
			if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'kmar' then
				if ESX.PlayerData.job.name == 'police' then
					jobnaam = "Politie"
				elseif ESX.PlayerData.job.name == 'kmar' then
					jobnaam = "Kmar"
				end
				OpenpoliceActionsMenu()
			end
		end
		if IsControlJustReleased(0, 38) and currentTask.busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(currentTask.task)
			ClearPedTasks(PlayerPedId())

			currentTask.busy = false
		end
	end
end)

function SetVehicleMaxMods(vehicle)
local props = {
modEngine = 2,
modBrakes = 2,
modTransmission = 2,
modSuspension = 3,
modTurbo = false,
windowTint = 0,
fuelLevel = 100,
}

ESX.Game.SetVehicleProperties(vehicle, props)

end

  function OpenVehicleSpawnerMenu(station, partNum)
  
  
	ESX.UI.Menu.CloseAll()
    
    local vehicles = Config.policeStations[station].Vehicles

	  local elements = {}
  
	  local sharedVehicles = Config.AuthorizedVehicles.Shared
	  for i=1, #sharedVehicles, 1 do
		  table.insert(elements, { label = sharedVehicles[i].label, model = sharedVehicles[i].model})
	  end
  
	  local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]
	  for i=1, #authorizedVehicles, 1 do
		  table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_spawner',
		{
		  title    = _U('vehicle_menu'),
		  align    = 'top-right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  local model = data.current.model
  
		  local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)
  
		  if not DoesEntityExist(vehicle) then
  
			local playerPed = PlayerPedId()
  
			if Config.MaxInService == -1 then
  
			  ESX.Game.SpawnVehicle(model, {
				x = vehicles[partNum].SpawnPoint.x,
				y = vehicles[partNum].SpawnPoint.y,
				z = vehicles[partNum].SpawnPoint.z
			  }, vehicles[partNum].Heading, function(vehicle)

				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

				SetVehicleMaxMods(vehicle)
				SetVehicleNumberPlateText(vehicle, math.random(1,999999))
                TriggerEvent('keizerstad:handler:spawnvehicle', vehicle)
				--DecorSetInt(vehicle, "_DESPAWN_TIMER", 1800)
			  end)
  
			else
  
			  ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
  
				if canTakeService then
  
				  ESX.Game.SpawnVehicle(model, {
					x = vehicles[partNum].SpawnPoint.x,
					y = vehicles[partNum].SpawnPoint.y,
					z = vehicles[partNum].SpawnPoint.z
				  }, vehicles[partNum].Heading, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleMaxMods(vehicle)
					SetVehicleNumberPlateText(vehicle, math.random(1,999999))
                    TriggerEvent('keizerstad:handler:spawnvehicle', vehicle)
					--DecorSetInt(vehicle, "_DESPAWN_TIMER", 1800)
				  end)
  
				else
				  ESX.ShowNotification(_U('service_max', inServiceCount, maxInService) .. inServiceCount .. '/' .. maxInService)
				end
  
			  end, 'police')
  
			end
  
		  else
			ESX.ShowNotification(_U('vehicle_out'))
		  end
  
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_vehicle_spawner'
		  CurrentActionMsg  = _U('vehicle_spawner')
		  CurrentActionData = {station = station, partNum = partNum}
  
		end
	  )
  
  
  end

  function OpenHelicoptersSpawnerMenu(station, partNum)
  
	local helicopters = Config.policeStations[station].Helicopters
  
	ESX.UI.Menu.CloseAll()
  
	if Config.EnableSocietyOwnedVehicles then
  
	  local elements = {}
  
	  ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)
  
		for i=1, #garageVehicles, 1 do
		  table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
		end
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'Helicopters_spawner',
		  {
			title    = _U('helicopter_menu'),
			align    = 'top-right',
			elements = elements,
		  },
		  function(data, menu)
  
			menu.close()
  
			local vehicleProps = data.current.value
  
			ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
			  ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
			  local playerPed = PlayerPedId()
			  TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
			end)
  
			TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)
  
		  end,
		  function(data, menu)
  
			menu.close()
  
			CurrentAction     = 'menu_helicopters_spawner'
			CurrentActionMsg  = _U('helicopter_spawner')
			CurrentActionData = {station = station, partNum = partNum}
  
		  end
		)
  
	  end, 'police')
  
	else
  
	  local elements = {}
  
	  local sharedVehicles = Config.AuthorizedHelicopters.Shared
	  for i=1, #sharedVehicles, 1 do
		  table.insert(elements, { label = sharedVehicles[i].label, model = sharedVehicles[i].model})
	  end
  
	  local authorizedVehicles = Config.AuthorizedHelicopters[PlayerData.job.grade_name]
	  for i=1, #authorizedVehicles, 1 do
		  table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'helicopters_spawner',
		{
		  title    = _U('helicopter_menu'),
		  align    = 'top-right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  local model = data.current.model
  
		  local vehicle = GetClosestVehicle(helicopters[partNum].SpawnPoint.x,  helicopters[partNum].SpawnPoint.y,  helicopters[partNum].SpawnPoint.z,  3.0,  0,  71)
  
		  if not DoesEntityExist(vehicle) then
  
			local playerPed = PlayerPedId()
  
			if Config.MaxInService == -1 then
  
			  ESX.Game.SpawnVehicle(model, {
				x = helicopters[partNum].SpawnPoint.x,
				y = helicopters[partNum].SpawnPoint.y,
				z = helicopters[partNum].SpawnPoint.z
			  }, helicopters[partNum].Heading, function(vehicle)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				SetVehicleMaxMods(vehicle)
				SetVehicleNumberPlateText(vehicle, "KAH 825")
				--DecorSetInt(vehicle, "_DESPAWN_TIMER", 1800)
			  end)
  
			else
  
			  ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
  
				if canTakeService then
  
				  ESX.Game.SpawnVehicle(model, {
					x = vehicles[partNum].SpawnPoint.x,
					y = vehicles[partNum].SpawnPoint.y,
					z = vehicles[partNum].SpawnPoint.z
				  }, vehicles[partNum].Heading, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleMaxMods(vehicle)
					SetVehicleNumberPlateText(vehicle, "KAH 825")
					--DecorSetInt(vehicle, "_DESPAWN_TIMER", 1800)
				  end)
  
				else
				  ESX.ShowNotification(_U('service_max', inServiceCount, maxInService) .. inServiceCount .. '/' .. maxInService)
				end
  
			  end, 'police')
  
			end
  
		  else
			ESX.ShowNotification(_U('helicopter_out'))
		  end
  
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_helicopters_spawner'
		  CurrentActionMsg  = _U('helicopter_spawner')
		  CurrentActionData = {station = station, partNum = partNum}
  
		end
	  )
  
	end
  
  end


AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	IsShackles = false
	ClearPedTasks(GetPlayerPed(-1))
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')

		if Config.EnableESXService then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
		handcuffTimer.active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end

RegisterNetEvent('esx_policejob:loose')
AddEventHandler('esx_policejob:loose', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = true
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)

-- request boei

function cuffrequest(source, args, raw)
    if not IsPedArmed(PlayerPedId(), 1) or not IsPedArmed(PlayerPedId(), 4) then
        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5)
        local data = {}
        local own_id = GetPlayerServerId(PlayerId())
        for k,v in pairs(players) do 
            if GetPlayerServerId(v) ~= own_id then 
                table.insert(data, {
                    label = GetPlayerServerId(v),
                    id = GetPlayerServerId(v)
                })
            end
        end
        if #data < 1 then return end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'request_boei', {
            title = "Boei verzoek",
            align = "top-right",
            elements = data
        }, function(data, menu)
            TriggerServerEvent("sendrequest", data.current.id)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    else
        ESX.ShowNotification("Je moet een wapen hebben voor iemand te fouilleren")
    end
end

RegisterCommand("request_boei", cuffrequest)

RegisterNetEvent("getrequestcuff")
AddEventHandler("getrequestcuff", function(sender)
    being_asked()
    --ESX.ShowNotification("ID ~b~" .. sender .. "~w~ wilt je fouilleren, druk ~g~K~w~ om het te accepteren...  ~r~H~w~ om het te weigeren...")
    exports['esx_rpchat']:PrintToChat("Boeien", ("Iemand wil je boeien, druk op ^3^*Y^0^r om dit te accepteren of op ^*^5L^0^r om dit af te wijzen!"):format(target), { r = 255, important = true })
end)

RegisterNetEvent("requestacceptedcuff")
AddEventHandler("requestacceptedcuff", function(inventory , loadout, money, target)
    
	playerheading = GetEntityHeading(GetPlayerPed(-1))
	playerlocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(GetPlayerPed(-1))
	local target = closestPlayer
	local target_id = GetPlayerServerId(target)
	local target_distance = GetEntityCoords(GetPlayerPed(target))
	local distance = #(target_distance - playerCoords)
	if not IsStandingBehindPlayer(target) then
		ESX.ShowNotification("~r~Je kunt alleen iemand van achter boeien!~s~")
		return
	end
	if distance <= 2.0 then
		TriggerServerEvent('esx_ruski_areszt:startAreszt', GetPlayerServerId(closestPlayer))								-- Rozpoczyna Funkcje na Animacje (Cala Funkcja jest Powyzej^^^)
		Citizen.Wait(1790)																									-- Czeka 2.1 Sekund**
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuffeffect', 0.9)
		Citizen.Wait(1500)																									-- Czeka 3.1 Sekund**
		TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
	-- elseif action == 'handcuff' then
	-- 	TriggerServerEvent('esx_gangjob:handcuff', GetPlayerServerId(closestPlayer))
	-- elseif action == 'drag' then
	-- 	TriggerServerEvent('esx_gangjob:drag', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification('Speler niet gevonden.')
	end
	
end)

RegisterNetEvent("requestdeclinedcuff")
AddEventHandler("requestdeclinedcuff", function(inventory , loadout, money, target) 
    ESX.ShowNotification("Verzoek op boeien afgewezen!")
end)

being_asked = function()
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            if IsControlJustReleased(0,246) then 
                TriggerServerEvent("acceptrequest")
                ESX.ShowNotification("Verzoek op boeien geaccepteerd")
                return
            end


            if IsControlJustReleased(0, 182) then 
                TriggerServerEvent("revokerequest")
                ESX.ShowNotification("Verzoek op boeien afgewezen!")
                return
            end
        end
    end)
end

dialog = function(cb)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'model', {
        title = 'Aantal'
    }, function(data2, menu)

        local price = tonumber(data2.value)
        if price == nil then
            menu.close()
        elseif tonumber(price) <= 0 then 
            menu.close()
        else
            menu.close()
            cb(price)
        end
    end, function(data2,menu)
        menu.close()
    end)
end

local planeModels = {
	[`cuban800`] = true
}

local Vehicle
local InPlane = false
AddEventHandler("baseevents:enteredVehicle", function(vehicle, currentSeat, _, netId, model)
	Vehicle = vehicle
	if IsThisModelAHeli(model) or IsThisModelAPlane(model) or planeModels[model] then
		InPlane = true
		print(netId)
		if currentSeat == -1 then
			TriggerEvent("esx_outlawalert:enteredPlane", PlayerPedId())
			TriggerServerEvent("esx_policejob:enteredPlane", true)
		end
		DecorSetInt(PlayerPedId(), 'InPlane', currentSeat)
	end
end)

CurrentVehicle.AddChangedSeatHandler(function(oldSeat)
	Vehicle = CurrentVehicle.Get()
	if InPlane and oldSeat ~= -1 and CurrentVehicle.GetSeat() == -1 then
		DecorSetInt(PlayerPedId(), 'InPlane', CurrentVehicle.GetSeat())
		TriggerServerEvent("esx_policejob:enteredPlane")
		TriggerEvent("esx_outlawalert:enteredPlane", PlayerPedId())
	end
end)

CurrentVehicle.AddLeftHandler(function(data)
	Vehicle = nil

	if InPlane then
		InPlane = false
		DecorSetInt(PlayerPedId(), 'InPlane', 0)
		DecorRemove(PlayerPedId(), 'InPlane')
		if data.seat == -1 then
			TriggerEvent("esx_outlawalert:exitedPlane", PlayerPedId())
			TriggerServerEvent("esx_policejob:exitedPlane")
		end
	end
	DecorRemove(PlayerPedId(), 'InPlane')
end)

RegisterNetEvent('airspace:entered')
AddEventHandler('airspace:entered', function(numPilots)
	if IsAuthorized() and numPilots then
		print("Joined = "..numPilots)
		ESX.ShowNotification(_U('entered_plane', numPilots))
	end
end)

RegisterNetEvent('airspace:notification')
AddEventHandler('airspace:notification', function(numPilots)
	if IsAuthorized() and numPilots then
		print("Left = "..numPilots)
		ESX.ShowNotification(_U('exited_plane', numPilots))
	end
end)




function CanSendDistressSignal()
	return true
	--return ESX.PlayerData.job.grade >= 600
end

function SendPoliceDistressSignal()
	if IsPedRagdoll(PlayerPedId()) then
		ESX.ShowNotification("Je kunt de noodknop niet indrukken terwijl je in ragdoll zit!")
		return
	end

	local broadcastDictionary = "random@arrests"
	local broadcastAnimation = "generic_radio_chatter"
	local playerPed = PlayerPedId()
	local coords	= GetEntityCoords(playerPed)
	ESX.ShowNotification("Houdt de knop 3 seconden ingedrukt om het noodsignaal te versturen!")

	RequestAnimDict(broadcastDictionary)

	while not HasAnimDictLoaded(broadcastDictionary) do
		Citizen.Wait(150)
	end

	local running, cancel = true, false
	Citizen.CreateThread(function()
		while running do
			if not IsControlPressed(0, 56) --[[56 F9]] and not IsControlPressed(0, 21) then
				ESX.ShowNotification("Noodsignaal geannuleerd!")
				cancel = true
				break
			end

			if not IsEntityPlayingAnim(playerPed, broadcastDictionary, broadcastAnimation, 3) then
				TaskPlayAnim(PlayerPedId(), broadcastDictionary, broadcastAnimation, 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			end
			Citizen.Wait(0)
		end
		StopAnimTask(playerPed, broadcastDictionary, broadcastAnimation, -4.0)
	end)

	Citizen.Wait(3000)
	running = false
	if cancel then
		return
	end

	if PlayerData.job.name == 'police' then
		jobnaam = "Politie"
	elseif PlayerData.job.name == 'offpolice' then
		jobnaam = "Uitdienst Politie"
	elseif PlayerData.job.name == 'kmar' then
		jobnaam = "Kmar"
	elseif PlayerData.job.name == 'offkmar' then
		jobnaam = "Uitdienst Kmar"
	elseif PlayerData.job.name == 'ambulance' then
		jobnaam = "Ambulance"
	elseif PlayerData.job.name == 'mechanic' then
		jobnaam = "ANWB"
	end

	if not IsPlayerDead(PlayerId()) and not IsEntityDead(PlayerPedId()) then
		ESX.ShowNotification('Noodsignaal is verzonden naar alle collega\'s')
		local posx,posy,posz = table.unpack(GetEntityCoords(PlayerPedId(),false))
		TriggerServerEvent('gitta-noodknop', jobnaam, posx,posy,posz)
		PlayDistressNotificationSound() -- alleen voor jezelf
	end

	RemoveAnimDict(broadcastDictionary)
	Wait(5000)
end

local function keyTick(thread)
	if not IsDead then
		if CanSendDistressSignal() and IsControlPressed(0, 56) and IsControlPressed(0, 21) and IsInputDisabled(2) then -- F9 56
			if PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' or PlayerData.job.name == 'kmar' or PlayerData.job.name == 'offkmar' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mechanic' then
				SendPoliceDistressSignal()
			end
		end
	end
end

keyThread = Thread:new(keyTick, "keyThread")

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

NoodknopBlip = nil
RegisterNetEvent('gitta-noodknop_client')
AddEventHandler('gitta-noodknop_client', function(x,y,z, name, jobnaam)
	if (PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' or PlayerData.job.name == 'kmar' or PlayerData.job.name == 'offkmar') ) then
		if NoodknopBlip ~= nil then
			RemoveBlip(NoodknopBlip)
		end
		NoodknopBlip = AddBlipForCoord(x, y, z)
		SetBlipSprite(NoodknopBlip , 1)
		SetBlipColour(NoodknopBlip, 1)
		SetBlipRoute(NoodknopBlip, true)
		SetBlipRouteColour(NoodknopBlip, 1)
		-- PulseBlip(NoodknopBlip)
		SetBlipHighDetail(NoodknopBlip, true)
		-- ShowNumberOnBlip(NoodknopBlip, GetPlayerServerId(PlayerId()))
		-- SetBlipBright(NoodknopBlip, true)
		-- SetBlipShowCone(NoodknopBlip, true)
		--PlayDistressNotificationSound()
		--max zn geluidje --TriggerServerEvent('InteractSound_SV:PlayOnOne', GetPlayerServerId(PlayerId()), "noodknop", 0.5)
		local streetName, crossing = GetStreetNameAtCoord(x, y, z)
		streetName = GetStreetNameFromHashKey(streetName)
		local message = ""
		if message.distress then
			crossing = GetStreetNameFromHashKey(crossing)
			message = "~r~NOODSIGNAAL VAN ~y~" .. jobnaam
		else
			message = "~r~NOODSIGNAAL VAN ~y~" .. jobnaam
		end
		
		TriggerEvent('esx:showNotification', message)
		Citizen.CreateThread(function() 
			Citizen.Wait(160000*1)
			if NoodknopBlip ~= nil then
				RemoveBlip(NoodknopBlip)
				if message.distress then
					--PlayDistressNotificationSound()
				end
			end
		end)
	end
end)

function PlayDistressNotificationSound()
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(200)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(800)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(200)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(800)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(200)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
	Citizen.Wait(800)
end