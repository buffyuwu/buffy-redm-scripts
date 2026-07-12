-- buffys random stuff that doesnt belong anywhere else

-- disable grappling, tackling, etc to make melee fun
-- https://github.com/femga/rdr3_discoveries/blob/110a7b14ffaf3eac038322bb229b90c299be4975/AI/COMBAT_ACTION_DISABLE_FLAGS/README.md?plain=1#L9
local function applyMeleeSettingsToPed()
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),1)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),3)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),5)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),6)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),11)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),15)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),16)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),17)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),32)
	Citizen.InvokeNative(0xB8DE69D9473B7593,PlayerPedId(),33)
	--TriggerEvent('chat:addMessage', {args = {"[Buffy Debug] ", "Melee settings updated."}, color = {100, 255, 100}})
end
RegisterCommand('debugcheckvoice', function()
	print(tostring(MumbleIsConnected()))
end)

Citizen.CreateThread( function()
	while true do
		MumbleSetActive(false)
		applyMeleeSettingsToPed()
		Citizen.Wait(60000)
	end
end
)
--disable looting drawers, trunks, etc
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		Citizen.InvokeNative(0xFC094EF26DD153FA,2)
	end
end
)
-- make people ragdoll if they spam jump
Citizen.CreateThread( function()
local resetcounter = 0
local jumpDisabled = false
	while true do
	Citizen.Wait(100)
	if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
		SetPedToRagdoll(PlayerPedId(), 2000, 2000, 3, 0, 0, 0)
		resetcounter = 0
	end
	if not jumpDisabled and IsPedJumping(PlayerPedId()) then
		jumpDisabled = true
		resetcounter = 10
		Citizen.Wait(1200)
	end
	if resetcounter > 0 then
		resetcounter = resetcounter - 1
	else
		if jumpDisabled then
		resetcounter = 0
		jumpDisabled = false
		end
	end
end
end)

local ragdoll = false
function setRagdoll(flag)
  ragdoll = flag
end
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if ragdoll then
    	SetPedToRagdoll(PlayerPedId(), 20000, 20000, 0, 0, 0, 0)
    end
  end
end)

ragdol = true
RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
		TriggerEvent('chat:addMessage', {args = {"", "You fall over."}, color = {100, 100, 100}})
	else
		setRagdoll(false)
		ragdol = true
		TriggerEvent('chat:addMessage', {args = {"", "You start to pick yourself up, this may take some time..."}, color = {100, 100, 100}})
		
	end
end)

RegisterCommand("ragdoll", function(source, args, rawCommand)
	TriggerEvent("Ragdoll", source)
end)
Citizen.CreateThread(function()
   TriggerEvent('chat:addSuggestion', '/ragdoll', 'Fall over or get back up')
	-- rp command suggestions
	TriggerEvent('chat:addSuggestion', '/setmaskname', 'Set a custom descriptor for when your identity is concealed')
	TriggerEvent('chat:addSuggestion', '/removemask', 'Stop concealing your identity')
	TriggerEvent('chat:addSuggestion', '/maskname', 'Conceal your identity | If you use /setmaskname, you can customize this')
	TriggerEvent('chat:addSuggestion', '/me', 'Describe an action for your character. ex /me greets Buffy with a wave.')
	TriggerEvent('chat:addSuggestion', '/do', 'Describe something happening. ex /do The bird on Buffys shoulder barks.')
	TriggerEvent('chat:addSuggestion', '/melow', 'The same as /me, but with a smaller range.')
	TriggerEvent('chat:addSuggestion', '/melong', 'The same as /me, but with a larger range to reach players farther away.')
	TriggerEvent('chat:addSuggestion', '/dolow', 'The same as /do, but with a smaller range.')
	TriggerEvent('chat:addSuggestion', '/dolong', 'The same as /do, but with a larger range to reach players farther away.')
	TriggerEvent('chat:addSuggestion', '/lfrp', 'Create a looking for rp blip, ex /lfrp Rancher seeking help with cattle')
	TriggerEvent('chat:addSuggestion', '/lfrpremove', 'Remove your /lfrp blip from the map')
	TriggerEvent('chat:addSuggestion', '/rolldice', 'Roll a dice by specifying how many dice and how many sides. ex /rolldice 1d20')
	TriggerEvent('chat:addSuggestion', '/examine', 'Examine another players description. /showids to see their ID. /changedescription to set yours. ex /examine 51')
	TriggerEvent('chat:addSuggestion', '/changedescription', 'Change your physical description. ex /changedescription Wearing dirty clothes')
	TriggerEvent('chat:addSuggestion', '/whisper', 'Say something at a smaller range than /low. Does not require specifying a target. ex /whisper Hello world.')
end)


RegisterNetEvent("buffy_libs:goto")
AddEventHandler("buffy_libs:goto", function(coords)
	DoScreenFadeOut(1000)
	Wait(2000)
	SetEntityCoordsNoOffset(PlayerPedId(), coords.x,coords.y,coords.z)
	--SetEntityHeading(PlayerPedId(),211.93)
	DoScreenFadeIn(3000)
end)

RegisterNetEvent("buffy_libs:bring")
AddEventHandler("buffy_libs:bring", function(coords)
	DoScreenFadeOut(1000)
	Wait(2000)
	SetEntityCoordsNoOffset(PlayerPedId(), coords.x,coords.y,coords.z)
	--SetEntityHeading(PlayerPedId(),211.93)
	DoScreenFadeIn(3000)
end)

RegisterNetEvent("buffy_libs:godmode")
AddEventHandler("buffy_libs:godmode", function()
    local player = PlayerPedId()
    if not god then
        SetEntityCanBeDamaged(player, false)
        SetEntityInvincible(player, true)
        SetPedConfigFlag(player, 2, true) -- no critical hits
        SetPedCanRagdoll(player, false)
        SetPedCanBeTargetted(player, false)
        Citizen.InvokeNative(0x5240864E847C691C, player, false) --set ped can be incapacitaded
        SetPlayerInvincible(player, true)
        Citizen.InvokeNative(0xFD6943B6DF77E449, player, false) -- set ped can be lassoed
        god = true
		TriggerEvent('chat:addMessage', {args = {"[Buffy Admin] ", "Godmode Enabled."}, color = {100, 255, 100}})
    else
        SetEntityCanBeDamaged(player, true)
        SetEntityInvincible(player, false)
        SetPedConfigFlag(player, 2, false)
        SetPedCanRagdoll(player, true)
        SetPedCanBeTargetted(player, true)
        Citizen.InvokeNative(0x5240864E847C691C, player, true)
        SetPlayerInvincible(PlayerId(), false)
        Citizen.InvokeNative(0xFD6943B6DF77E449, player, true)
        god = false
		TriggerEvent('chat:addMessage', {args = {"[Buffy Admin] ", "Godmode disabled."}, color = {100, 255, 100}})
    end
end)

--yeet, yote
RegisterNetEvent("buffy_libs:getyote")
AddEventHandler("buffy_libs:getyote", function()
	local rightVector = GetEntityMatrix(PlayerPedId())
	SetPedToRagdoll(PlayerPedId(), 10000, 15000, 0, 0, 0, 0)
	ApplyForceToEntity(PlayerPedId(), 3, rightVector.x * 80, rightVector.y * 80, rightVector.z * 180, 0.0, 0.0, 0.0, 0, 0, 0, 1, 0, 1)
	TriggerEvent('chat:addMessage', {args = {"[Buffy Admin]", "You were yeeted by an admin."}, color = {255, 100, 100}})
end)




-- debug commands
RegisterCommand('hasitem',function(source, args, rawCommand)
	local hasItem = exports.vorp_inventory:GetItem(tostring(args[1]))
	TriggerEvent('chat:addMessage', {args = {"[Buffy Debug] ", "Checking if player has "..tostring(args[1])..": "..tostring(hasItem[1])}, color = {100, 255, 100}})
end)

--stats stuff
--save session time data
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50000)
		TriggerServerEvent('totalPlaytime:sync', GetPlayerServerId(PlayerId()))
    end
end)
