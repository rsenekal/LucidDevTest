RegisterNetEvent("fixVehicle")
RegisterNetEvent("setVehicleFixed")

-- Event handler to account for your vehicle being repaired
AddEventHandler("setVehicleFixed", function()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        local vehiclePedIsIn = GetVehiclePedIsIn(ped, false)
        Citizen.Wait(4000)
        SetVehicleEngineHealth(vehiclePedIsIn, 1000)
        SetVehicleEngineOn(vehiclePedIsIn, true, true)
        SetVehicleFixed(vehiclePedIsIn)
        notification("~b~Your vehicle has been fixed!")
    end)
end)

-- Event handler for the animation of fixing the vehicle near you
AddEventHandler("fixVehicle", function()
    Citizen.CreateThread(function()
        local myPed = GetPlayerPed(-1)
        TaskStartScenarioInPlace(myPed, 'world_human_welding', 0, true)
        Citizen.Wait(4000)
        ClearPedTasks(myPed)
        notification("~b~The vehicle has been fixed!")
    end)
end)

-- Simple notification pop-up above minimap
function notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end
