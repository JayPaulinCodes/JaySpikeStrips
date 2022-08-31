--[[
    TriggerEvent("Jay:SpikeStrips:removeSpikeStrip", objectNetworkId)
    TriggerClientEvent("Jay:SpikeStrips:removeSpikeStrip", -1, objectNetworkId)
    
    Removes the spike segment object

    @param {Integer} objectNetworkId - The network id of the spike segment object
]]
RegisterNetEvent("Jay:SpikeStrips:removeSpikeStrip")
AddEventHandler("Jay:SpikeStrips:removeSpikeStrip", function(objectNetworkId) 
    Citizen.CreateThread(function()
        
        -- Find the object from the netword id
        local spikeSegmentObject = NetworkGetEntityFromNetworkId(objectNetworkId)

        -- Delete the spike segment
        DeleteEntity(spikeSegmentObject)

    end)
end)


--[[
    TriggerEvent("Jay:SpikeStrips:runSetSpikeStrip", length)
    TriggerClientEvent("Jay:SpikeStrips:runSetSpikeStrip", -1, length)
    
    Sets down spike strips with a given length

    @param {Integer} length - How many spike segments long the spike strip will be
]]
RegisterNetEvent("Jay:SpikeStrips:runSetSpikeStrip")
AddEventHandler("Jay:SpikeStrips:runSetSpikeStrip", function(length) 

    -- Build the command string
    local commandString = _("setSpikesCmd_name") .. " " .. length
    
    -- Execute the command
    ExecuteCommand(commandString)

end)


--[[
    TriggerEvent("Jay:SpikeStrips:runRemoveSpikeStrip")
    TriggerClientEvent("Jay:SpikeStrips:runRemoveSpikeStrip", -1)
    
    Removes a spike strip you've place down
]]
RegisterNetEvent("Jay:SpikeStrips:runRemoveSpikeStrip")
AddEventHandler("Jay:SpikeStrips:runRemoveSpikeStrip", function() 

    -- Build the command string
    local commandString = _("removeSpikesCmd_name")
    
    -- Execute the command
    ExecuteCommand(commandString)

end)