TriggerEvent("getCore", function(core)
	VorpCore = core
end)
function sendToWebhook(webhook, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

local function GetRealPlayerName(src)
	local User = VorpCore.getUser(src)
	if User then
		local Character = User.getUsedCharacter

		if Character.firstname and Character.lastname then
			local playerName = Character.firstname .. ' ' .. Character.lastname
			--if maskeds[src] then return maskeds[src]; end
			return playerName
		else
			return ' '
		end
	end
end

local function isAdmin(src)
    if not src then return false; end
	local group = VorpCore.getUser(src).getGroup
	--identifier = Character.identifier
	if group == "owner" or group == "admin" or group == "superadmin" then
		return true
	else
		return false
	end
end
local function getPlayerCoords(source)
	local player = source
	local ped = GetPlayerPed(player)
    if not ped then TriggerClientEvent('chat:addMessage', playerId, {args = {'[Buffy Admin] ', 'Invalid ID specified.'}}); return; end
	return GetEntityCoords(ped)
end
local function isValidID(ID)
	local buffy_ActivePlayers = GetPlayers()
	for _, playerID in ipairs(buffy_ActivePlayers) do
		if playerID ~= 0 then
			if ID == playerID then return true; end
		end
	end
    return false
end
RegisterCommand('goto', function(source, args, rawCommand)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
	if args == nil then args = ''; end
    if not isValidID(args[1]) then TriggerClientEvent('esfer_rpchat:sendProximityMessage', src, source, '[Buffy Admin] Please enter a valid ID.', {100, 255, 100}, 99999, true, 'none', getPlayerCoords(source)); return; end
	sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." went to "..GetRealPlayerName(args[1]).." via /goto")
	TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'Going to player with server ID: '..args[1]}, color = {100, 255, 100}})
    TriggerClientEvent('buffy_libs:goto', source, getPlayerCoords(args[1]))
end, false)

RegisterCommand('bring', function(source, args, rawCommand)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
	if args == nil then args = ''; end
    if not isValidID(args[1]) then TriggerClientEvent('esfer_rpchat:sendProximityMessage', src, source, '[Buffy Admin] Please enter a valid ID.', {100, 255, 100}, 99999, true, 'none', getPlayerCoords(source)); return; end
	sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." brought "..GetRealPlayerName(args[1]).." via /bring")
	TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'Bringing player with server ID: '..args[1]}, color = {100, 255, 100}})
    TriggerClientEvent('chat:addMessage', args[1], {args = {'[Buffy Admin] ', 'You were teleported by a staff member. '}, color = {100, 255, 100}})
    TriggerClientEvent('buffy_libs:bring', args[1], getPlayerCoords(source))
end, false)
RegisterCommand('noclip', function(source, args, rawCommand)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
	TriggerClientEvent('buffy_libs:noclip_toggle', source)
	sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." toggled noclip.")
	TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'Toggled Noclip.'}, color = {100, 255, 100}})
end, false)
RegisterCommand('spectate', function(source, args, rawCommand)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
	sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." tried to access /spectate.")
end, false)
RegisterCommand('godmode', function(source, args, rawCommand)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
    sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." toggled godmode.")
	TriggerClientEvent('buffy_libs:godmode', source)
end, false)

RegisterCommand('yeet', function(source, args)
    local src = source
    if not isAdmin(src) then
       TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Admin] ', 'You must be an administrator to use this command.'}})
        return
    end
	if not args[1] then return; end
	TriggerClientEvent('buffy_libs:getyote', tonumber(args[1]))
	sendToWebhook("https://discord.com/api/webhooks/1322993012569014272/wONLFoXHI37V0KEZTNg_JChbKkqWu9PMprDfzLP91teD9ngQvRefwBoe7FFx6Cf97Xlw", "ADMIN: "..GetPlayerName(source).." yeeted "..GetRealPlayerName(args[1]))
end)

RegisterNetEvent("buffy_libs:deathWebhook", function(killerID, causeofdeath)
	if killerID == nil or killerID == 0 then
		killerID = 'suicide'
	else
		killerID = GetRealPlayerName(killerID)
		if killerID == ' ' then killerID = 'nature' end
	end
    sendToWebhook("https://discord.com/api/webhooks/1308695423715639296/I2J6f-9LnQR1Dfprvvx0ctgT-40FhQJXmOQg_3TyJe033xU8JjPU5fkY_hRg9UxCXxSd", "# [Death Log] "..GetRealPlayerName(source)..' was killed by '..killerID)
end)

