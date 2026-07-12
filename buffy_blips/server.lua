
function sendToWebhook(webhook, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end
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
			return
		end
	end
end

local function getPlayerCoords(source)
	local player = source
	local ped = GetPlayerPed(player)
    if not ped then return; end
	return GetEntityCoords(ped)
end

local allBlips = {}
local function refreshBlips(removeMe)
    local activePlayers = GetPlayers()
    local activePlayerIDs = {}
    for _, playerID in ipairs(activePlayers) do
        activePlayerIDs[tonumber(playerID)] = true
    end
    for playerName, blipData in pairs(allBlips) do
        local blipPlayerID = blipData[4]
        if not activePlayerIDs[blipPlayerID] then
            allBlips[playerName] = nil
        else
            local currentName = GetRealPlayerName(blipPlayerID)
            if currentName == nil or currentName ~= playerName then
                allBlips[playerName] = nil
            else
                blipData[2] = getPlayerCoords(blipPlayerID)
            end
        end
        
    end
    TriggerClientEvent('buffy_blips:sync', -1, allBlips)
end
AddEventHandler('playerDropped', function(reason)
	refreshBlips()
end)

local function sendBlipToClients(blipName, blipCoords, playerName, playerID)
    local blipSprite = GetHashKey("blip_adversary_large")
    allBlips[playerName] = {blipName, blipCoords, playerName, playerID}
    TriggerClientEvent('buffy_blips:sync', -1, allBlips)
end

RegisterCommand('lfrp', function(source, args)
    if args[1] == nil then return end
    local blipCoords = getPlayerCoords(source)
    local blipName = table.concat(args, ' ')
    local playerName = GetRealPlayerName(source)
    local playerID = source
    if not playerName then return; end
    sendBlipToClients(blipName, blipCoords, playerName, playerID)
    sendToWebhook("https://discord.com/api/webhooks/1313960996804628621/GR41GEszzK7YSnDUX2cCOl4qyjdZDayPMQNQRvu6qNVDbBUTN_ZiZwA10T6HsyxJzKwr", "Looking for RP: "..blipName.." (/PM "..tostring(playerID)..")")
    sendToWebhook("https://discord.com/api/webhooks/1313969516321177622/8dyGgtzI-4oajGoxcfMtI0Csrvqp1ffh8QyWmN1Sd8Y7ZxFlXEMDUdGKFL_S3Wq4-h43", "[ADMIN LOG] [CHAR: "..tostring(playerName).." ] [Original Message: 'Looking for RP: "..blipName.." (/PM "..tostring(playerID)..")' ]")
	TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Blips] ', 'Your LFRP blip is active. Use /lfrpremove to disable it.'}})
end)
RegisterCommand('lfrpremove', function(source, args)
    local playerName = GetRealPlayerName(source)
    allBlips[playerName] = nil
	refreshBlips()
	TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Blips] ', 'If you had an LFRP blip, it was removed.'}})
end)
function sendToWebhook(webhook, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

local function isInSD(playerCoords)
    local distX = playerCoords.x - 2606.91
    local distY = playerCoords.y - -1259.82
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 600)
end
local function isInStrawberry(playerCoords)
    local distX = playerCoords.x - -1812.56
    local distY = playerCoords.y - -391.12
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 200)
end
local function isInRhodes(playerCoords)
    local distX = playerCoords.x - 1353.58
    local distY = playerCoords.y - -1314.62
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 200)
end
local function isInBlackwater(playerCoords)
    local distX = playerCoords.x - -800.34
    local distY = playerCoords.y - -1292.22
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 250)
end
local function isInWapiti(playerCoords)
    local distX = playerCoords.x - 455.48
    local distY = playerCoords.y - 2228.88
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 100)
end
local function isInValentine(playerCoords)
    local distX = playerCoords.x - -317.41
    local distY = playerCoords.y - 788.76
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 200)
end
local function isInAnnesburg(playerCoords)
    local distX = playerCoords.x - 2931.81
    local distY = playerCoords.y - 1341.06
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 250)
end
local function isInVanHorn(playerCoords)
    local distX = playerCoords.x - 2991.12
    local distY = playerCoords.y - 514.68
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 175)
end
local function isInButchersCreek(playerCoords)
    local distX = playerCoords.x - 2553.52
    local distY = playerCoords.y - 793.45
    local distance = math.sqrt(distX*distX + distY*distY)
    --print(distance)
    return (distance < 125)
end
local function isInNewAustin(playerCoords)
    return playerCoords.x <= -1300 and playerCoords.y <= -2000
end
local function getAllPlayerActivity()
    local activePlayers = GetPlayers()
    local playerLocations = {}
    local regionList = {SaintDenis = 0, Strawberry = 0, Rhodes = 0, Blackwater = 0, Wapiti = 0, Valentine = 0, Annesburg = 0, VanHorn = 0, ButchersCreek = 0, NewAustin = 0}
    --print('fired')
    for _, playerID in ipairs(activePlayers) do
        if playerID ~= nil and playerID ~= 0 then
            local location = getPlayerCoords(playerID)
            if location ~= nil then
                --print(location.x..' '..location.y..' '..location.z..' is not within any boundary')
                if isInSD(location) then
                    regionList.SaintDenis = regionList.SaintDenis + 1
                elseif isInStrawberry(location) then
                    regionList.Strawberry = regionList.Strawberry + 1
                elseif isInRhodes(location) then
                    regionList.Rhodes = regionList.Rhodes + 1
                elseif isInBlackwater(location) then
                    regionList.Blackwater = regionList.Blackwater + 1
                elseif isInWapiti(location) then
                    regionList.Wapiti = regionList.Wapiti + 1
                elseif isInValentine(location) then
                    regionList.Valentine = regionList.Valentine + 1
                elseif isInAnnesburg(location) then
                    regionList.Annesburg = regionList.Annesburg + 1
                elseif isInVanHorn(location) then
                    regionList.VanHorn = regionList.VanHorn + 1
                elseif isInButchersCreek(location) then
                    regionList.ButchersCreek = regionList.ButchersCreek + 1
                elseif isInNewAustin(location) then
                    regionList.NewAustin = regionList.NewAustin + 1
                end
            end
        end
    end
    TriggerClientEvent('buffy_blips:townactivitysync', -1, regionList)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        refreshBlips()
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(120000)
        getAllPlayerActivity()
    end
end)
