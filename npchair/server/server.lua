RegisterCommand("womanhair", function(source, _)
    TriggerClientEvent("hair", source)
end, false)

RegisterCommand("manhair", function(source, _)
    TriggerClientEvent("hair2", source)
end, false)


TriggerEvent("getCore", function(core)
	VorpCore = core
end)
local function GetRealPlayerName(src)
    if VorpCore == nil or src == nil or src == 0 then return; end
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

local loaded_data = LoadResourceFile(GetCurrentResourceName(), 'data_hair.json')
local hairData = json.decode(loaded_data)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if hairData == nil then hairData = {} end
    while true do
        SaveResourceFile(GetCurrentResourceName(), 'data_hair.json', json.encode(hairData), -1)
        Citizen.Wait(600000) --save every 10 minutes
    end
end)

RegisterServerEvent('npchair:serversync')
AddEventHandler('npchair:serversync', function(syncTarget, remove)
    if not syncTarget or syncTarget == nil then return; end
    local targetName = GetRealPlayerName(syncTarget)
    if not targetName or targetName == nil then return; end --if vorp cant find them, their character isnt spawned in yet
    if hairData[targetName] == nil or remove then --no custom hair found so lets instantiate an empty table for them in advance. also good for clearing any custom hair as needed.
        hairData[targetName] = {}
        return
    end
    --TriggerClientEvent('chat:addMessage', syncTarget, {args = {'[Buffy Sync]', 'Sending hair data to '..tostring(syncTarget)..' Name: '..targetName..' Data: '..tostring(hairData[targetName][1])}, color = {100, 255, 100}})
    TriggerClientEvent('npchair:clientsync', syncTarget, hairData[targetName]) --send the requesting client any hair data the server json has stored under their name
end)

RegisterServerEvent('npchair:sync')
AddEventHandler('npchair:sync', function(source, hair, color1, color2, color3)
    local src = source
    local key = GetRealPlayerName(src)
    hairData[key] = {hair, color1, color2, color3} --write the hair data the client just gave us here to the servers json db
    TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Sync] ', 'Hair updated. Note: Custom hair settings save to the server every ten minutes.'}, color = {100, 255, 100}})
end
)
