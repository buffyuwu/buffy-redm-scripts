-- github.com/buffyuwu
-- simple getter for the latest player names, send them after a delay via the citizencreatethread
TriggerEvent("getCore", function(core)
	VorpCore = core
end)

local function GetRealPlayerName(src)
	local User = VorpCore.getUser(src)

	if User then
		local Character = User.getUsedCharacter
		if Character.firstname and Character.lastname then
			local playerName = Character.firstname .. ' ' .. Character.lastname
			return playerName
		else
			return ' '
		end
	end
end

local function buffy_sendNameData()
    local buffy_data = {}
    local buffy_ActivePlayers = GetPlayers()
    for _, playerId in ipairs(buffy_ActivePlayers) do
        if playerId ~= 0 then
            local realName = GetRealPlayerName(playerId) --vorp global, get the 'player name' aka first and last name for that ID
            buffy_data[playerId] = realName
        end
    end
    TriggerClientEvent('buffy_namedata', -1, buffy_data) -- send to -1 to reach all clients with the update
end

Citizen.CreateThread(function()
	Citizen.Wait(20000)
	buffy_sendNameData()
	while true do
		Citizen.Wait(25000)
		buffy_sendNameData()
	end
end)
