local ShowPlayerNames = true
local ShowMyName = false
local ShowIdTags = false
local TagDrawDistance = 50 --unused
local HudIsRevealed = false
local ActivePlayers = {}
local MyCoords = vector3(0, 0, 0)

RegisterCommand('playernames', function(source, args, raw)
	ShowPlayerNames = not ShowPlayerNames
	local onoff = 'on'
	if ShowPlayerNames then onoff = 'on'; else onoff = 'off'; end
  	TriggerEvent('chat:addMessage', {args = {"[System]", 'You toggled player nametags '..onoff}, color = {100, 100, 100}})
end, false)
RegisterCommand('showmyname', function(source, args, raw) --untested
	ShowMyName = not ShowMyName
end, false)
RegisterCommand('showids', function(source, args, raw)
	ShowIdTags = not ShowIdTags
	local onoff = 'on'
	if ShowIdTags then onoff = 'on'; else onoff = 'off'; end
  	TriggerEvent('chat:addMessage', {args = {"[System]", 'You toggled player IDs '..onoff}, color = {100, 100, 100}})
end, false)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(firstFunc, nextFunc, endFunc)
	return coroutine.wrap(function()
		local iter, id = firstFunc()

		if not id or id == 0 then
			endFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = endFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = nextFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		endFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function DrawText3D(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
	SetTextScale(0.5, 0.5)
	SetTextFontForCurrentCommand(18)
	SetTextColor(250, 250, 250, 255)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextCentre(1)
	DisplayText(CreateVarString(10, "LITERAL_STRING", text), screenX, screenY)
end

function GetPedCrouchMovement(ped)
	return Citizen.InvokeNative(0xD5FE956C70FF370B, ped)
end

function OnRevealHud()
	HudIsRevealed = true
	SetTimeout(3000, function()
		HudIsRevealed = false
	end)
end
local maskeds = {}
local buffy_playerNames = {} --locally stored table of all player names sorted by id
RegisterNetEvent('buffy_namedata')
AddEventHandler('buffy_namedata', function(names, masknames)
	if names then buffy_playerNames = names; end
	if masknames then maskeds = masknames; end
end)

local idTag = ' '
function DrawTags()
	if ShowPlayerNames or HudIsRevealed then
		for _, playerId in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(playerId)
			local pedCoords = GetWorldPositionOfEntityBone(ped, 1)
			local pedX = pedCoords.x
			local pedY = pedCoords.y
			local pedZ = pedCoords.z
			if #(MyCoords - pedCoords) <= 12 and not GetPedCrouchMovement(ped) then --tags only visible at 6 units, and invisible if the player crouches
				local id = GetPlayerServerId(playerId)
				local name = ''
				if buffy_playerNames[tostring(id)] == nil then
					name = ' '
				else
					if ShowIdTags or IsControlPressed(0, 0x8FFC75D6) then idTag = ' ['..tostring(id)..']'; else idTag = ' '; end
					if maskeds[id] ~= nil then
						name = tostring(maskeds[id])..idTag
					else
						name = tostring(buffy_playerNames[tostring(id)])..idTag
					end
				end
				if IsPedInAnyVehicle(ped) then pedZ = pedZ + 0.2; end
				if IsPedOnMount(ped) then pedZ = pedZ + 0.1; end
				local text = name
				if not ShowMyName and id == GetPlayerServerId(PlayerId()) then text = ''; end
				if not IsEntityVisible(ped) then text = ''; end
				DrawText3D(pedX, pedY, pedZ + 1, text)
			end
		end
	end
end

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/playernames', 'Show/hide other players nameplates')
	TriggerEvent('chat:addSuggestion', '/showmyname', 'Show/hide your own nameplate')
	TriggerEvent('chat:addSuggestion', '/showids', 'Show/hide all player IDs')
end)

Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, `INPUT_REVEAL_HUD`) then --not an error
			OnRevealHud()
		end

		DrawTags()

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		ActivePlayers = GetActivePlayers()
		MyCoords = GetEntityCoords(PlayerPedId())
		Citizen.Wait(500)
	end
end)
