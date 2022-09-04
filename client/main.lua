spikeStripModel = "P_ld_stinger_s"
playerSpawnedSpikeSegments = {}
doesPlayerHaveSpikesDown = false
isPlayerNearSpikes = false
vehicleTires = {
    {
        bone = "wheel_lf", 
        index = 0
    },
    {
        bone = "wheel_rf", 
        index = 1
    },
    {
        bone = "wheel_lm", 
        index = 2
    },
    {
        bone = "wheel_rm", 
        index = 3
    },
    {
        bone = "wheel_lr", 
        index = 4
    },
    {
        bone = "wheel_rr", 
        index = 5
    }
}

-- Setup
Citizen.CreateThread(function() 
    Citizen.Wait(50)

    registerCommandSuggestions()

    registerChatTemplates()
end)


-- Checks if the player is in a car and near spikes
Citizen.CreateThread(function()
   
    while true do 
        local playerPed = GetPlayerPed(-1)

        -- Make sure the player exists
        if isPedRealAndAlive(playerPed) then

            -- Make sure their in a vehcile
            if IsPedInAnyVehicle(playerPed, false) then 
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                -- Check if their in the driver seat of the car
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then 
                
                    -- Get the coords of the vehicle
                    local vehicleCoords = GetEntityCoords(vehicle, false)
                    
                    -- Find the closest spike object and it's coords and distance
                    local closestSpikes, closestSpikesCoords, distanceFromSpikes = getClosestSpikesToCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 80.0)

                    -- Set the varriable accordingly
                    if closestSpikes ~= 0 then isPlayerNearSpikes = true 
                    else isPlayerNearSpikes = false end

                else isPlayerNearSpikes = false end

            else isPlayerNearSpikes = false end

        else isPlayerNearSpikes = false end

        Citizen.Wait(0)
    end
    
end)

-- Handle the tire popping when runnig over spikes
Citizen.CreateThread(function() 

    while true do 
        local playerPed = GetPlayerPed(-1)
    
        -- Check if the player is near spike strips
        if isPlayerNearSpikes then

            -- Check if each tire has run over the spikes
            for tire = 1, #vehicleTires do

                -- Get the vehicle the player is in
                local vehicle = GetVehiclePedIsIn(playerPed, false)
            
                -- Get the coords of the vehicle's tire
                local vehicleTireCoords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, vehicleTires[tire].bone))
                
                -- Find the closest spike object and it's coords and distance
                local closestSpikes, closestSpikesCoords, distanceFromSpikes = getClosestSpikesToCoords(vehicleTireCoords.x, vehicleTireCoords.y, vehicleTireCoords.z, 15.0)
                -- print("\n\n" .. tire, closestSpikes, closestSpikesCoords, distanceFromSpikes)

                -- Check if the tire is on the spike
                if distanceFromSpikes ~= nil then
                    if distanceFromSpikes < 1.8 then
                        local isTireCompletelyPopped = IsVehicleTyreBurst(vehicle, vehicleTires[tire].index, true)
                        local isTirePartialyPopped = IsVehicleTyreBurst(vehicle, vehicleTires[tire].index, false)

                        -- If the tire is not completley popped OR is partialy popped, pop the tire
                        if not isTireCompletelyPopped or isTirePartialyPopped then
                            SetVehicleTyreBurst(vehicle, vehicleTires[tire].index, false, 1000.0)
                        end
                    end
                end

            end

        end

        Citizen.Wait(0)
    end

end)


-- Handle the display for removing the spikes
Citizen.CreateThread(function() 

    while true do

        -- Check if the user has a spike strip down
        if doesPlayerHaveSpikesDown then

            -- Display the prompt menu
            drawNotificationRemoveSpikes()

        end

        Citizen.Wait(0)

    end

end)



-- Register commands for the script
RegisterCommand(_("setSpikesCmd_name"), function(source, args, rawCommands) 
    local length = args[1] or nil
    setSpikeCommand(length)
end, false)


RegisterCommand(_("removeSpikesCmd_name"), function(source, args, rawCommands) 
    removeSpikesCommand()
end, false)


RegisterCommand("-Jay:SpikeStrips:removeSpikes", function(source, args, rawCommands) 
    removeSpikesCommand()
end, false)


-- http://tools.povers.fr/hashgenerator/
-- Input context hash: ~INPUT_5965F934~
RegisterKeyMapping("-Jay:SpikeStrips:removeSpikes", _U("removeSpikesMapping_description"), "keyboard", "i")


function setSpikeCommand(length) 
    local playerPed = GetPlayerPed(-1)
    length = tonumber(length)

    -- Validate the length variable and force it to be correct
    if length == nil then
        length = 2
    elseif type(length) ~= "number" then 
        length = 2 
    elseif length < 1 or length > 5 then
        length = 2
    end

    -- Make sure the player doesn't already have spike strips down
    if not doesPlayerHaveSpikesDown then

        -- Make sure the player exists
        if isPedRealAndAlive(playerPed) then

            -- Make sure the player is not in a car
            if not IsPedSittingInAnyVehicle(playerPed) then
                
                -- Get the location to spawn the spike strip
                local spikeStripSpawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0)

                -- Spawn a spike segment for each length of the spike strip
                for segment = 1, length do

                    -- Create the spike segment object
                    local spikeSegmentObject = CreateObject(GetHashKey(spikeStripModel), spikeStripSpawnCoords.x, spikeStripSpawnCoords.y, spikeStripSpawnCoords.z, 1, 1, 1)

                    -- Get the network id for the spike strip segment object
                    local spikeSegmentObject_networkId = NetworkGetNetworkIdFromEntity(spikeSegmentObject)

                    -- Create the object for everyone
                    SetNetworkIdExistsOnAllMachines(spikeSegmentObject_networkId, true)

                    -- Prevent others from taking control of the object
                    SetNetworkIdCanMigrate(spikeSegmentObject_networkId, false)

                    -- Set the heading for the object
                    SetEntityHeading(spikeSegmentObject, GetEntityHeading(playerPed))

                    -- Well, do I really need to document this one...
                    PlaceObjectOnGroundProperly(spikeSegmentObject)

                    -- Update the spawn coords for the next segment based off of this one
                    spikeStripSpawnCoords = GetOffsetFromEntityInWorldCoords(spikeSegmentObject, 0.0, 4.0, 0.0)

                    -- Add the segment to the table so we can remove it later
                    table.insert(playerSpawnedSpikeSegments, spikeSegmentObject_networkId)

                end

                -- Set the variable for having spikes down to true
                doesPlayerHaveSpikesDown = true

                
                -- Notify the player that they have layed down spikes
                drawNotification(_("fiveMColour_green") .. _U("setSpikes"))

            else
                -- Notify the player they cant use spikes from in a vehicle
                drawNotification(_("fiveMColour_red") .. _U("cantSpikeFromVehcile"))
            end

        end

    else
        -- Notify the player they already have a spike strip down
        drawNotification(_("fiveMColour_red") .. _U("spikesAlreadyDown"))
    end

end


function removeSpikesCommand()
    local playerPed = GetPlayerPed(-1)
    
    -- Make sure the player has spike strips down
    if doesPlayerHaveSpikesDown then

        -- Make sure the player exists
        if isPedRealAndAlive(playerPed) then

            -- Loop through the list of spike segments
            for segment = 1, #playerSpawnedSpikeSegments do

                -- Remove the segment for all players
                TriggerServerEvent("Jay:SpikeStrips:removeSpikeStrip", playerSpawnedSpikeSegments[segment])

                -- Set the variable for having spikes down to false
                doesPlayerHaveSpikesDown = false

            end

            -- Clear the table that held the spike strip segments
            playerSpawnedSpikeSegments = {}

            -- Notify the player that they have picked up spikes
            drawNotification(_("fiveMColour_green") .. _U("removedSpikes"))

        end

    else
        -- Notify the player that they don't have any spike strips down
        drawNotification(_("fiveMColour_yellow") .. _U("noSpikesToPickUp"))
    end

end