--[[ Forza Horizon 4 Speedometer for FiveM ]]--
--[[ Author: Akkariin | Github: https://github.com/kasuganosoras/fh4speed ]]--
--[[ If you like this script, please give me a like on the fivem forum, thanks ]]--

local isShowHUD = false
local activeHUD = true
local isInitial = false
local isUseMetric = true
local carRPM, carSpeed, carGear, carIL, carAcceleration, carHandbrake, carBrakeABS, carLS_r, carLS_o, carLS_h

RegisterNetEvent('fh4speed:setUnitMetric')
AddEventHandler('fh4speed:setUnitMetric',function(isMetric)
	isUseMetric = isMetric
	SendNUIMessage({ 
		Type = "setUnitMetric",
		isUseMetric = isMetric,
	})
end)

if(Config.ToggleHUD['canToggleHUD']) then

	RegisterNetEvent('fh4speed:toggleHUD')
	AddEventHandler('fh4speed:toggleHUD',function()
		ToggleDisplay()
	end)

	function ToggleDisplay()
		activeHUD = not activeHUD
		print("fh4speed active HUD:",activeHUD)
		if(activeHUD) then
			RefreshHUD()
		else
			SendNUIMessage({ 
				Type = "toggleHUD",
				isShowHUD = false,
			})
		end
	end
end

function Initial()
	local configUseMeric = Config.UnitSpeed['useMetric']
	TriggerEvent('fh4speed:setUnitMetric', configUseMeric)
	isInitial=true
end
CreateThread(function()
	Wait(0)
	if(not isInitial) then
		Initial()
	end

	while true do
		Wait(0)
		if(activeHUD) then
			Tick()
		end
	end
end)
function Tick()
	local playerPed = GetPlayerPed(-1)
	local isShouldShowHUD = false
	if playerPed and IsPedInAnyVehicle(playerPed) then
		isShouldShowHUD = true
		local playerCar = GetVehiclePedIsIn(playerPed, false)
		if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
			local NcarRPM                      = GetVehicleCurrentRpm(playerCar)
			local NcarSpeed                    = GetEntitySpeed(playerCar)
			local NcarGear                     = GetVehicleCurrentGear(playerCar)
			local NcarIL                       = GetVehicleIndicatorLights(playerCar)
			local NcarAcceleration             = IsControlPressed(0, 71)
			local NcarHandbrake                = GetVehicleHandbrake(playerCar)
			local NcarBrakeABS                 = (GetVehicleWheelSpeed(playerCar, 0) <= 0.0) and (NcarSpeed > 0.0)
			local NcarLS_r, NcarLS_o, NcarLS_h = GetVehicleLightsState(playerCar)
			local shouldUpdate = false
			
			if NcarRPM ~= carRPM or NcarSpeed ~= carSpeed or NcarGear ~= carGear or NcarIL ~= carIL or NcarAcceleration ~= carAcceleration 
				or NcarHandbrake ~= carHandbrake or NcarBrakeABS ~= carBrakeABS or NcarLS_r ~= carLS_r or NcarLS_o ~= carLS_o or NcarLS_h ~= carLS_h then
				shouldUpdate = true
			end
			
			if shouldUpdate then
				carRPM          = NcarRPM
				carGear         = NcarGear
				carSpeed        = NcarSpeed
				carIL           = NcarIL
				carAcceleration = NcarAcceleration
				carHandbrake    = NcarHandbrake
				carBrakeABS     = NcarBrakeABS
				carLS_r         = NcarLS_r
				carLS_o         = NcarLS_o
				carLS_h         = NcarLS_h
				SendNUIMessage({
					Type                = "update",
					CurrentCarRPM          = carRPM,
					CurrentCarGear         = carGear,
					CurrentCarSpeed        = carSpeed,
					CurrentCarIL           = carIL,
					CurrentCarAcceleration = carAcceleration,
					CurrentCarHandbrake    = carHandbrake,
					CurrentCarABS          = GetVehicleWheelBrakePressure(playerCar, 0) > 0 and not carBrakeABS,
					CurrentCarLS_r         = carLS_r,
					CurrentCarLS_o         = carLS_o,
					CurrentCarLS_h         = carLS_h,
				})
			end
		end
	end
	if(isShouldShowHUD ~= isShowHUD) then
		print("On refresh HUD")
		print(isShouldShowHUD)
		isShowHUD = isShouldShowHUD
		RefreshHUD()
	end
end

function RefreshHUD()
	SendNUIMessage({ 
		Type = "toggleHUD",
		isShowHUD = isShowHUD,
	})
end
