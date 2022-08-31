--[[
    sendChatMessage(templateID, arguments) 

    @param {String} templateID - The tempalte ID of the template to use
    @param {Array} arguments - Array of the arguments for the message
]]
function sendChatMessage(templateID, arguments) 
    TriggerEvent('chat:addMessage', 
        { 
            templateId = templateID, 
            multiline = true, 
            args = arguments
        }
    )
end


--[[
    Registers command suggestions for each command
    in the common/commands.lua file
]]
function registerCommandSuggestions()
    for i, command in ipairs(COMMANDS) do
        
        if #command.parameters == 0 then
            TriggerEvent("chat:addSuggestion", "/" .. command.name, command.description)
        else 
            TriggerEvent("chat:addSuggestion", "/" .. command.name, command.description, command.parameters)
        end

        print(GetThisScriptName() .. _("registeredCommand") .. command.name)
        Citizen.Wait(25)
        
    end
end


--[[
    Registers chat templates for each template
    in the common/chatTemplates.lua file
]]
function registerChatTemplates()
    for i, chatTemplate in ipairs(CHAT_TEMPLATES) do
        TriggerEvent("chat:addTemplate", chatTemplate.templateId, chatTemplate.htmlString)
    
        print(GetThisScriptName() .. _("registeredChatTemplate") .. chatTemplate.templateId)
        Citizen.Wait(25)
    end
end


--[[
    drawNotification(message)
    Displayes a message above the map

    @param {String} message - The message to display
]]
function drawNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end


--[[
    isPedRealAndAlive(playerPed)
    Checks to make sure a player exists and is not dead

    @param {Entity} - The player ped of the entity to test (See GetPlayerPed())

    @returns {Boolean} Returns true when the ped is real and alive and false otherwise
]]
function isPedRealAndAlive(playerPed) 

    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then 
        return true 
    else
        return false 
    end

end


--[[
    TODO: Document Function
]]
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end


--[[
    TODO: Document Function
]]
function getClosestSpikesToCoords(x, y, z, maxRadius)
    local closestSpikes = nil
    local closestSpikesCoords = nil
    local distanceFromSpikes = nil
    local spikeModelHashKey = GetHashKey(spikeStripModel)
    maxRadius = maxRadius or 80.0

    -- Make sure the maxRadius parameter is valid
    if type(maxRadius) ~= "number" then maxRadius = 80.0 end

    -- Make sure the coords are numbers and valid
    if type(x) == "number" and type(y) == "number" and type(z) == "number" then

        -- Try to find the closest spike strip in the radius
        closestSpikes = GetClosestObjectOfType(x, y, z, maxRadius, spikeModelHashKey, true, true, true)

        if closestSpikes ~= nil and closestSpikes ~= 0 then
            
            -- Find the coords of the closest spike strip
            closestSpikesCoords = GetEntityCoords(closestSpikes, false)

            -- Find the distance to the closest spike strip
            distanceFromSpikes = Vdist(x, y, z, closestSpikesCoords.x, closestSpikesCoords.y, closestSpikesCoords.z)

        end

    end

    return closestSpikes, closestSpikesCoords, distanceFromSpikes

end


--[[
    drawNotificationRemoveSpikes()
    Displayes a message to tell the player how to remove the spikes
]]
function drawNotificationRemoveSpikes()
    AddTextEntry("Jay:SpikeStrip:removeSpikes", _U("removeSpikes", "~INPUT_5965F934~"))
    BeginTextCommandDisplayHelp("Jay:SpikeStrip:removeSpikes")
    EndTextCommandDisplayHelp(0, false, true, -1)
end