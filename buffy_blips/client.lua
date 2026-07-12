
-- looking for RP blips
-- from https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips_mp
local allBlips = {}
local function addBlipForCoords(blipname,bliphash,coords)
	local blip = Citizen.InvokeNative(0x554D9D53F696D002,1664425300, coords[1], coords[2], coords[3])
	local blip_modifier_hash = GetHashKey("BLIP_MODIFIER_MP_COLOR_8") --add color override
	Citizen.InvokeNative(0x662D364ABF16DE2F, blip, blip_modifier_hash)
	SetBlipSprite(blip,bliphash,true)
	SetBlipScale(blip,0.5)
	blipname = 'Looking for RP: '..blipname..' '
	Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipname)
	allBlips[blipname] = blip
end
RegisterNetEvent("buffy_blips:sync")
AddEventHandler("buffy_blips:sync", function(data)
	for k,v in pairs(allBlips) do
		if v == nil then return end
		RemoveBlip(v)
	end
	for _,c in pairs(data) do
		addBlipForCoords(c[1],GetHashKey("blip_adversary_large"),c[2])
	end
end)

RegisterNetEvent("buffy_blips:townactivitysync") --markers around regions where there are a lot of players present
AddEventHandler("buffy_blips:townactivitysync", function(regions)
	local blipstyle = 'BLIP_MODIFIER_MP_COLOR_8'
	local limit = 3
	--turn off all blips
	local hashList = {SaintDenis = 0xC354EAC2, Strawberry = 0x3B4A5D5B, Rhodes = 0x09FAE063, Blackwater = 0x129E1411, Wapiti = 0x4F45BE43, Valentine = 0x2A24C8D9, Annesburg = 0x9CC09C3D, VanHorn = 0x194E52AF, ButchersCreek = 0xB6831F62, NewAustin = 0xD339F6AB}
	for k,v in pairs(hashList) do
		Citizen.InvokeNative(0x6786D7AFAC3162B3, v)
	end
	--now turn on the ones that have people near them
	if regions.SaintDenis    > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.SaintDenis, GetHashKey(blipstyle));
	end
	if regions.Strawberry    > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Strawberry, GetHashKey(blipstyle));
	end
	if regions.Rhodes 	     > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Rhodes, GetHashKey(blipstyle));
	end
	if regions.Blackwater    > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Blackwater, GetHashKey(blipstyle));
	end
	if regions.Wapiti 	     > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Wapiti, GetHashKey(blipstyle));
	end
	if regions.Valentine     > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Valentine, GetHashKey(blipstyle));
	end
	if regions.Annesburg     > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.Annesburg, GetHashKey(blipstyle));
	end
	if regions.VanHorn       > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.VanHorn, GetHashKey(blipstyle));
	end
	if regions.ButchersCreek > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.ButchersCreek, GetHashKey(blipstyle));
	end
	if regions.NewAustin     > limit then
		Citizen.InvokeNative(0x563FCB6620523917, hashList.NewAustin, GetHashKey(blipstyle));
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
	for k,v in pairs(allBlips) do
		RemoveBlip(v)
	end
end)
