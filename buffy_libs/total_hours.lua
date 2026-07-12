
--script to update our total played hours
TriggerEvent("getCore", function(core)
	VorpCore = core
end)
local function GetRealPlayerName(src)
	local User = VorpCore.getUser(src)
	if User then
		local Character = User.getUsedCharacter

		if Character.firstname and Character.lastname then
			local playerName = Character.firstname .. ' ' .. Character.lastname
			--if maskeds[src] then return maskeds[src]; end
			return playerName
		else
			return
		end
	end
end
local loaded_data = LoadResourceFile(GetCurrentResourceName(), 'data_playtime.json')
local playtime = json.decode(loaded_data)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(120000) --save roughly every 2 minutes
        SaveResourceFile(GetCurrentResourceName(), 'data_playtime.json', json.encode(playtime), -1)
        TriggerClientEvent('totalPlaytime:getCurrentTime', -1, os.time())
    end
end)

RegisterServerEvent('totalPlaytime:sync')
if playtime == nil then
    playtime = {}
end
local lastSync = {}
AddEventHandler('playerDropped', function(source)
    local license = GetPlayerIdentifierByType(source, 'license')
    if lastSync[license] == nil then return; end
    lastSync[license] = nil
end)
AddEventHandler('totalPlaytime:sync', function(source)
    local src = source
    if src == nil or src == 0 then return end
    local character = GetRealPlayerName(src)
    local license = GetPlayerIdentifierByType(src, 'license')
    local currentTime = os.time()
    if not license or not character then return end
    if not playtime[license] then
        playtime[license] = {
            total = {firstJoined = os.date("%A, %B %d, %Y"), days = 0, hours = 0, minutes = 0, seconds = 0},
            characters = {}
        }
    end

    if not playtime[license].characters[character] then
        playtime[license].characters[character] = {days = 0, hours = 0, minutes = 0, seconds = 0}
    end

    if not lastSync[license] then
        lastSync[license] = currentTime
        return
    end
    local elapsedSeconds = currentTime - lastSync[license]
    lastSync[license] = currentTime
    local charData = playtime[license].characters[character]
    charData.seconds = charData.seconds + elapsedSeconds

    if charData.seconds >= 60 then
        charData.minutes = charData.minutes + math.floor(charData.seconds / 60)
        charData.seconds = charData.seconds % 60
    end
    if charData.minutes >= 60 then
        charData.hours = charData.hours + math.floor(charData.minutes / 60)
        charData.minutes = charData.minutes % 60
    end
    if charData.hours >= 24 then
        charData.days = charData.days + math.floor(charData.hours / 24)
        charData.hours = charData.hours % 24
    end
    local totalData = playtime[license].total
    totalData.seconds = totalData.seconds + elapsedSeconds

    if totalData.seconds >= 60 then
        totalData.minutes = totalData.minutes + math.floor(totalData.seconds / 60)
        totalData.seconds = totalData.seconds % 60
    end
    if totalData.minutes >= 60 then
        totalData.hours = totalData.hours + math.floor(totalData.minutes / 60)
        totalData.minutes = totalData.minutes % 60
    end
    if totalData.hours >= 24 then
        totalData.days = totalData.days + math.floor(totalData.hours / 24)
        totalData.hours = totalData.hours % 24
    end
end)

RegisterCommand('stats', function(source, args)
    local license = GetPlayerIdentifierByType(source, 'license')
    local characterName = GetRealPlayerName(source)
    if playtime[license] == nil then 
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Buffy Sync] ', 'No playtime recorded yet.'},
            color = {100, 255, 100}
        })
        return
    end
    local totalPlaytime = playtime[license].total
    local characterPlaytime = playtime[license].characters[characterName]
    if playtime[license] ~= nil then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Buffy Sync] ', 
                    '^2 Account First Connection: '..tostring(totalPlaytime.firstJoined)},
            color = {100, 255, 100},
        })
        TriggerClientEvent('chat:addMessage', source, {
            args = {'', 
                    '^4 | Stats for Character: ' .. tostring(characterName)},
            color = {100, 255, 100},
        })
        TriggerClientEvent('chat:addMessage', source, {
            args = {'', 
                    '^4Total Character Playtime: ' .. tostring(characterPlaytime.days) .. ' days, ' ..
                    tostring(characterPlaytime.hours) .. ' hours, ' ..
                    tostring(characterPlaytime.minutes) .. ' minutes, ' ..
                    tostring(characterPlaytime.seconds) .. ' seconds. | '},
            color = {100, 255, 100},
        })
        TriggerClientEvent('chat:addMessage', source, {
            args = {'', 
                    '^5 | Stats for Account: ' .. tostring(GetPlayerName(source))},
            color = {100, 255, 100},
        })
        TriggerClientEvent('chat:addMessage', source, {
            args = {'', 
                    ' ^5Total Account Playtime: ' .. tostring(totalPlaytime.days) .. ' days, ' ..
                    tostring(totalPlaytime.hours) .. ' hours, ' ..
                    tostring(totalPlaytime.minutes) .. ' minutes, ' ..
                    tostring(totalPlaytime.seconds) .. ' seconds. |'},
            color = {100, 255, 100},
        })
    end
end)

RegisterCommand('getLicense', function(source, args)
    TriggerClientEvent('chat:addMessage', source, {
        args = {'[Buffy Sync] ', tostring(GetPlayerIdentifierByType(source, 'license'))},
        color = {100, 255, 100}
    })

end)

RegisterCommand('getRealTime', function(source, args)
    TriggerClientEvent('chat:addMessage', source, {
        args = {'[Buffy Sync] ', tostring(os.time())},
        color = {100, 255, 100}
    })

end)
RegisterCommand('clearPlaytime', function(source, args)
    local license = GetPlayerIdentifierByType(source, 'license')
    playtime[license] = nil
end)
