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

