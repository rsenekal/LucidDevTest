RegisterNetEvent("repair")

RegisterCommand("repair", function(source, args)
    -- Ensure a player is calling the repair command
    if (source > 0) then
        local callerPed = GetPlayerPed(source)

        -- Ensure the caller is not in a vehicle
        local vehicleCallerIsIn = GetVehiclePedIsIn(callerPed, false)
        if vehicleCallerIsIn ~= 0 then
            return
        end

        local callerName = GetPlayerName(source)
        local closestCoord = math.huge
        local closestPed
        local closestId

        local callerCoords = GetEntityCoords(callerPed)
        local callerX, callerY, callerZ = table.unpack(callerCoords)

        local allPlayers = GetPlayers()
        for _, playerId in ipairs(allPlayers) do
            local playerPed = GetPlayerPed(playerId)

            if playerPed == callerPed then goto continue end

            local playerCoords = GetEntityCoords(playerPed)
            local playerX, playerY, playerZ = table.unpack(playerCoords)
            local distanceBetweenCallerandPlayer = DistanceBetweenCoords(callerCoords, playerCoords)
            
            -- Find and set the closest player's coords, ped, and id
            if distanceBetweenCallerandPlayer < closestCoord then
                closestCoord = distanceBetweenCallerandPlayer
                closestPed = playerPed
                closestId = playerId
            end
            ::continue::
        end

        -- Checks if another player is nearby
        if closestCoord > 5 or closestPed == callerPed then
            TriggerClientEvent("chatMessage", source, callerName .. ': ', { 5, 255, 255 }, { 'No other Players nearby...' })
            return
        end
        
        -- Checks whether or not the closet player is in a vehicle - Note: Can also check if player is in driver seat via GetPedInVehicleSeat()
        local vehiclePedIsIn = GetVehiclePedIsIn(closestPed, false)
        if vehiclePedIsIn == 0 then
            TriggerClientEvent("chatMessage", source, callerName .. ': ', { 5, 255, 255 }, { 'Player not in a vehicle...' })
            return
        end

        -- Trigger repair animation event for caller
        TriggerClientEvent('fixVehicle', source)
        
        -- Trigger repair action for the closest player 
        TriggerClientEvent('setVehicleFixed', closestId)
    end
end, false)

-- Returns the distance (number) between two coordinate vectors
function DistanceBetweenCoords(coordsA, coordsB)
    local firstVec = vector3(coordsA.x, coordsA.y, coordsA.z)
    local secondVec = vector3(coordsB.x, coordsB.y, coordsB.z)

    return #(firstVec - secondVec)
end
