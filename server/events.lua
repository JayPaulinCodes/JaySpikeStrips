--[[
    TriggerServerEvent("Jay:SpikeStrips:removeSpikeStrip", objectNetworkId)
    
    Removes the object for all users on the server

    @param {Integer} objectNetworkId - The network id of the spike segment object
]]
RegisterServerEvent("Jay:SpikeStrips:removeSpikeStrip")
AddEventHandler("Jay:SpikeStrips:removeSpikeStrip", function(objectNetworkId) 

    -- Trigger the client event for everyone
    TriggerClientEvent("Jay:SpikeStrips:removeSpikeStrip", -1, objectNetworkId)
end)


--[[
    TriggerServerEvent("Jay:SpikeStrips:runSetSpikeStrip", objectNetworkId)
    
    Runs the set spike strip command for a user

    @param {Player} targetPlayer - The player who is executing the command

    @param {Integer} length - The number of segments the spike strip will have
]]
RegisterServerEvent("Jay:SpikeStrips:runSetSpikeStrip")
AddEventHandler("Jay:SpikeStrips:runSetSpikeStrip", function(targetPlayer, length) 

    -- Trigger the client event for the target
    TriggerClientEvent("Jay:SpikeStrips:runSetSpikeStrip", targetPlayer, length)
end)


--[[
    TriggerServerEvent("Jay:SpikeStrips:runRemoveSpikeStrip")
    
    Runs the remove spike strip command for a user

    @param {Player} targetPlayer - The player who is executing the command
]]
RegisterServerEvent("Jay:SpikeStrips:runRemoveSpikeStrip")
AddEventHandler("Jay:SpikeStrips:runRemoveSpikeStrip", function(targetPlayer) 

    -- Trigger the client event for the target
    TriggerClientEvent("Jay:SpikeStrips:runRemoveSpikeStrip", targetPlayer)
end)