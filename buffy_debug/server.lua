TriggerEvent("getCore", function(core)
	VorpCore = core
end)
local function getPlayerCoords(source)
	local player = source
	local ped = GetPlayerPed(player)
    if not ped then TriggerClientEvent('chat:addMessage', playerId, {args = {'[Buffy Alerts]', 'Invalid ID specified.'}}); return; end
	return GetEntityCoords(ped)
end

