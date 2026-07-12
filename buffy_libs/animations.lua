
--pointing
local isPointing = false
local function point()
    if isPointing then
        ExecuteCommand('sa')
        isPointing = not isPointing
        return
    end
    local animDict = 'script_common@other@unapproved'
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    TaskPlayAnim(PlayerPedId(), 'script_common@other@unapproved', 'loop_0',1.0, -1.0, 100000, 30, 0, true, 0, 0, 0, 0)
    isPointing = not isPointing
end
RegisterCommand('point', function(source, args, rawCommand)
    point()
end, false)

--check if they pressed N, if so then point
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 0xF3830D8E) then
			point()
		end
    end
end)


-- animations
-- from https://raw.githubusercontent.com/kibook/spooner/refs/heads/master/data/rdr3/animations.lua
RegisterCommand("dancebasic", function()
    local animDict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_a" --the parent anim
    local subAnim = "idle_b" --specific anim within the parent anim
    local speed = 2.0 --minimum speed
    local speed2 = 2.0 --max speed i think
    local timeout = -1 --infinite
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    TaskPlayAnim(PlayerPedId(), animDict, subAnim, speed, speed2, timeout, 1, 0, 0, 0, 0 )
    RemoveAnimDict(animDict)
end)

RegisterCommand('crossarms', function(source, args, rawCommand)
    local animDict = 'mech_skin@buck@butcher'
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    TaskPlayAnim(PlayerPedId(),'mech_skin@buck@butcher', 'trans_to_stoic_butcher', 1.0, -1.0, 999999999, 30, 0, true, 0, 0, 0, 0)
end, false)

-- __________________
-- debug command to run an animation ingame on your ped. good for testing anims before putting them into code.
RegisterCommand("runanim", function(source, args)
    local animDict = tostring(args[1]) --the parent anim
    local subAnim = tostring(args[2]) --specific anim within the parent anim
    local timeout = -1 --infinite
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    TaskPlayAnim(PlayerPedId(), animDict, subAnim, 2.0, 2.0, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict(animDict)
end)
TriggerEvent('chat:addSuggestion', '/runanim', 'Run an animation. ex: /runanim mech_skin@buck@butcher trans_to_stoic_butcher')
-- __________________
-- debug command to run a scenario ingame on your ped. good for testing scenarios before putting them into code.
RegisterCommand("runscene", function(source, args)
    local ped = PlayerPedId()
    local string = tostring(args[1])
    local timeout = -1
    if not HasScenarioTypeLoaded(string, 0) then
        GetScenarioPointType(string)
        while not HasScenarioTypeLoaded(string, 0) do
            Citizen.Wait(0)
        end
    end
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey(string), -1)
end)
TriggerEvent('chat:addSuggestion', '/runscene', 'Run a scenario. ex: /runscene WORLD_PLAYER_CAMP_FIRE_SQUAT')
-- __________________

local scenarioProp = ''
local scenarioProp2 = ''
--in place scenarios. get the scenario hash key and run the native function, easy 
RegisterCommand('squat', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_PLAYER_CAMP_FIRE_SQUAT'), -1, 10, 0, 0, 0)
end)

RegisterCommand('trumpet', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_TRUMPET'), -1)
    scenarioProp = 'p_TRUMPET01x_PH_L_HAND'
end)

RegisterCommand('sitgroundguitar', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_GUITAR'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_guitar01x_PH_R_HAND'
end)

RegisterCommand('idlewait', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_STAND_WAITING'), -1, 10, 0, 0, 0)
end)

RegisterCommand('impatient', function(source, args, rawCommand)
    local animDict = 'amb_misc@world_human_waiting_impatient@male_d@idle_b'
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    TaskPlayAnim(PlayerPedId(),animDict, 'idle_d', 1.0, 1.0, 999999999, 1, 0, true, 0, false, 0, false)
end, false)

RegisterCommand('leanrailing', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_LEAN_RAILING_NO_PROPS'), -1, 10, 0, -1, 0)
end)

RegisterCommand('leanrailingsmoke', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_LEAN_RAILING_SMOKING'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_cigarette_cs01x_PH_R_HAND'
    scenarioProp2 = 'p_pipe01x_PH_R_HAND'
end)

RegisterCommand('sitground', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_GROUND'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sitground2', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_CAMP_FIRE_SIT_GROUND_RECLINE'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sitground3', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_CROUCHING_B'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sitground4', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_BACK_EXHAUSTED'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sitground5', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_FALL_ASLEEP'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sitgroundbeer', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_DRINK'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_bottleBeer01x_PH_R_HAND'
end)

RegisterCommand('sitgroundbook', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_GROUND_READING_BOOK'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_cs_book04x_PH_R_HAND'

end)

RegisterCommand('sitgroundcoffee', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_GROUND_COFFEE_DRINK'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_mugCoffee01x_ph_r_hand'
end)

RegisterCommand('sitgroundsmoke', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SIT_SMOKE'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_cigarette_cs01x_PH_R_HAND'
end)

RegisterCommand('smoke', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SMOKE'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_cigarette_cs01x_PH_R_HAND'
    scenarioProp2 = 'p_pipe01x_PH_R_HAND'
end)

RegisterCommand('smokecigar', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SMOKE_CIGAR'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_cigar01x_PH_R_HAND'
end)

RegisterCommand('sleepgroundarm', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SLEEP_GROUND_ARM'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sleepground', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SLEEP_GROUND_PILLOW'), -1, 10, 0, 0, 0)
end)

RegisterCommand('takenotes', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_WRITE_NOTEBOOK'), -1, 10, 0, 0, 0)
end)

RegisterCommand('clipboard', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CLIPBOARD'), -1, 10, 0, 0, 0)
    scenarioProp = 'P_AMB_clipboard_01_PH_L_HAND'
    scenarioProp2 = 'p_pen01x_PH_R_HAND'
end)

RegisterCommand('sweep', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_STRAW_BROOM_WORKING'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_broom02x_PH_R_HAND'
end)

RegisterCommand('inspectground', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, 10, 0, 0, 0)
end)

RegisterCommand('cleantable', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CLEAN_TABLE'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handbelt', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_INSPECT'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handbelt2', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_B'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handbelt3', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_F'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handbelt4', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_G'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handbelt5', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_H'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handhip', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_A'), -1, 10, 0, 0, 0)
end)

RegisterCommand('handhip2', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_STERNGUY_IDLES'), -1, 10, 0, 0, 0)
end)
TriggerEvent('chat:addSuggestion', '/handhip2', 'Male only emote')

RegisterCommand('tossfeed', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_FEED_CHICKEN'), -1, 10, 0, 0, 0)
    scenarioProp = 'p_feedBag01bx_PH_L_HAND'
end)

RegisterCommand('guard', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_COOP_LOBBY_STANDING_A'), -1, 10, 0, 0, 0)
end)
TriggerEvent('chat:addSuggestion', '/guard', 'Optional: Draw your revolver beforehand!')

RegisterCommand('legupresting', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('MP_LOBBY_STANDING_E'), -1, 10, 0, 0, 0)
end)

RegisterCommand('sledgehammer', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_SLEDGEHAMMER'), -1, 10, 0, 0, 0)
    scenarioProp = 'SLEDGEHAMMER'
end)

RegisterCommand('mournstand', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_GRAVE_MOURNING'), -1, 10, 0, 0, 0)
end)

RegisterCommand('mournkneel', function()
    local ped = PlayerPedId()
    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_GRAVE_MOURNING_KNEEL'), -1, 10, 0, 0, 0)
end)
RegisterCommand('tiphat', function(source, args, rawCommand)
    TaskEmote(PlayerPedId(), emoteClass, 2, GetHashKey('KIT_EMOTE_GREET_HAT_TIP_1'), true, true, true, true, true)
end, false)
RegisterCommand('tiphatsimple', function(source, args, rawCommand)
    RequestAnimDict('mech_loco_m@character@dutch@fancy@unarmed@idle@_variations')
    while not HasAnimDictLoaded('mech_loco_m@character@dutch@fancy@unarmed@idle@_variations') do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), 'mech_loco_m@character@dutch@fancy@unarmed@idle@_variations', 'idle_b', 1.0, -1.0, 2500, 31, 0, true, 0, false, 0, false)
end, false)

local prop -- props for use in animations
RegisterCommand('smokecig', function()
    ExecuteCommand('deleteprop')
    local animDict = 'amb_rest@world_human_smoke_cigar@male_a@idle_c'
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
        end
    end
    local playerCoords = GetEntityCoords(PlayerPedId())
    prop = CreateObject(GetHashKey('p_cigarette01x'), playerCoords.x, playerCoords.y, playerCoords.z, 1, 0, 1)
    SetEntityAsMissionEntity(prop, true, true)
    Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop,PlayerPedId(),GetEntityBoneIndexByName(PlayerPedId(),'PH_R_Hand'), 0.0, 0.0, 0.0, 0.0, 0.0, -90.0, true, true, false, true, 1, true)
    TaskPlayAnim(PlayerPedId(), animDict, 'idle_g',1.0, -1.0, 100000, 30, 0, true, 0, 0, 0, 0)
end)

RegisterCommand('deleteprop', function()
    ClearPedTasks(PlayerPedId())
    DeleteObject(prop)
    RemovePedProp(PlayerPedId(), scenarioProp)
    local findProp = GetPedRegisterProp(PlayerPedId(), scenarioProp, true) -- must invoke native
    if findProp then
        Citizen.Wait(100)
        DeleteEntity(findProp)
    end
    local findProp2 = GetPedRegisterProp(PlayerPedId(), scenarioProp2, true)
    if findProp2 then
        Citizen.Wait(100)
        DeleteEntity(findProp2)
    end
end)
TriggerEvent('chat:addSuggestion', '/deleteprop', 'Removes any props stuck on your character after a slash animation')
-- stop anim
RegisterCommand('sa', function(source, args, rawCommand)
	local ped = PlayerPedId()
	local hogtied = IsPedHogtied(ped) == 1 or IsPedHogtied(ped) == true
	local IsBeingHogtied = IsPedBeingHogtied(ped) == 1 or IsPedBeingHogtied(ped) == true
	local beingGrappled = Citizen.InvokeNative(0x3BDFCF25B58B0415, ped)
	if hogtied or IsPedCuffed(ped) or IsBeingHogtied or beingGrappled then
		return
	end
	ClearPedTasks(PlayerPedId())
    ExecuteCommand('deleteprop')
end)
TriggerEvent('chat:addSuggestion', '/sa', 'Stop all animations')

