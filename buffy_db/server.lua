TriggerEvent("getCore", function(core)
	VorpCore = core
end)
local function getPlayerCoords(source)
	local player = source
	local ped = GetPlayerPed(player)
    if not ped then TriggerClientEvent('chat:addMessage', source, {args = {'[Buffy Alerts]', 'Invalid ID specified.'}}); return; end
	return GetEntityCoords(ped)
end
local function isAdmin(src)
	local group = VorpCore.getUser(src).getGroup
	if group == "owner" or group == "admin" or group == "superadmin" then
		return true
	else
		return false
	end
end
local characterList = {}
Citizen.CreateThread(function()
	Citizen.Wait(10000)
	characterList = MySQL.query.await("SELECT * FROM characters", {})
end)
RegisterServerEvent('buffy_db:checkadmin') --check if they are admin, if they are lets send them the data they asked for
AddEventHandler('buffy_db:checkadmin', function(source, type)
	local src = source
	if isAdmin(src) then
		if type == 'housing' then
			local housingList = MySQL.query.await("SELECT * FROM playerhousing", {})
			TriggerClientEvent('buffy_db:isadmin', src, true, housingList, characterList)
		elseif type == 'clan' then
			local clanList = MySQL.query.await("SELECT * FROM clan", {})
			TriggerClientEvent('buffy_db:isadmin', src, true, clanList, characterList)
		elseif type == 'items' then
			local itemList = MySQL.query.await("SELECT * FROM items", {})
			TriggerClientEvent('buffy_db:isadmin', src, true, itemList)
		end
	end
end)

function sendToWebhook(webhook, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end
RegisterServerEvent('buffy_db:receiveitem')
AddEventHandler('buffy_db:receiveitem', function(source, data)
	local src = source
	if not isAdmin(src) then
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB] ', 'You must be an administrator to use this command.'}})
		return
	end
	local name = data.name
	local label = data.label
	local carryLimit = data.carryLimit or '100'
	local description = data.description or ' '
	local weight = data.weight or '0.1'
	print(GetPlayerName(src)..' submitted a new item to the database with name: '..name..' label:'..label..' desc:'..description..' weight: '..weight..' carry limit:'..carryLimit)
	local webhook = 'https://discord.com/api/webhooks/1332822838872117279/T93RdgrzNyAoL9ZWfWu1duVVogrzd5JFAMuKiUacIdMdaW706gVJpKC_4FGtivTBXtIA'
	sendToWebhook(webhook, '--------------------------------------------\n'..GetPlayerName(src)..' submitted a new item to the database: ```\n Name: '..name..' \n Label: '..label..' \n Desc: '..description..' \n Weight: '..weight..' \n Carry limit: '..carryLimit..' ```')
	if name == nil or carryLimit == nil or description == nil or weight == nil then
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB] ', 'You MUST fill out all fields. Please be careful!'}})
		return
	end
	local parameters = {
		['name'] = name,
		['label'] = label,
		['carryLimit'] = carryLimit,
		['description'] = description,
		['weight'] = weight,
	}
	MySQL.insert("REPLACE INTO items ( `item`, `label`, `limit`, `can_remove`, `type`, `usable`, `groupId`, `metadata`, `desc`, `weight`) VALUES (@name, @label, @carryLimit, '1', 'item_standard', '1', '1', '{}', @description, @weight)", parameters)
	itemList = MySQL.query.await("SELECT * FROM items", {})
end)

RegisterCommand('addsociety', function(source, args)
	local src = source
	if not isAdmin(src) then
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB] ', 'You must be an administrator to use this command.'}})
		return
	end
	if args[1] == nil then
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB] ', 'Syntax: /addsociety societyname startingmoney. e.g. /addsociety sdbank 500 will add a new society after the restart with 500 dollars in their ledger.'}})
	end
	local name = args[1]
	local startingMoney = args[2]
	if startingMoney == nil then
		startingMoney = 0
	end
	local parameters = {
		['name'] = name,
		['startingMoney'] = startingMoney,
	}
	local checkExists = MySQL.query.await("SELECT * FROM container WHERE name = @name", { ["@name"] = name })
	local webhook = 'https://discord.com/api/webhooks/1332823152648130601/dC4z-KW7Ex_kG564oMsurcIgDLUBOwf6pPDF_cFEF8DF5fD-0xL1qVsBb49FW7NsE3K-'
	for k,v in pairs(checkExists) do
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB]', 'Society already exists! Name: '..name..' Container ID: '..v.id..'. No changes were made.'}})
		sendToWebhook(webhook, GetPlayerName(src)..' tried to add a society that already exists! Society name:'..name..' with container ID: '..v.id)
		return
	end
	MySQL.insert("REPLACE INTO container (`name`, `items`) VALUES (@name, '[]')", parameters)
	Wait(200)
	MySQL.insert("REPLACE INTO society (`job`, `jobgrade`, `salary`) VALUES (@name, '1', '0');", parameters)
	Wait(200)
	MySQL.insert("REPLACE INTO society (`job`, `jobgrade`, `salary`) VALUES (@name, '2', '0');", parameters)
	Wait(200)
	MySQL.insert("REPLACE INTO society (`job`, `jobgrade`, `salary`) VALUES (@name, '3', '0');", parameters)
	Wait(200)
	MySQL.insert("REPLACE INTO society_ledger (`job`, `ledger`) VALUES (@name, @startingMoney)", parameters)
	Wait(200)
	local containerID = MySQL.query.await("SELECT * FROM container WHERE name = @name", { ["@name"] = name })
	for k,v in pairs(containerID) do
		TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB]', 'Society created! Name: '..name..' Container ID: '..v.id}})
		sendToWebhook(webhook, GetPlayerName(src)..' added a new society. Society name: '..name..' with container ID: '..v.id..' and ledger funds of: '..startingMoney)
	end
	local hasMoney = '.'
	if tonumber(startingMoney) ~= nil and tonumber(startingMoney) > 0 then
		hasMoney = ' with funds in their ledger totaling: '..tostring(startingMoney)..' dollars.'
	end
	Wait(200)
	TriggerClientEvent('chat:addMessage', src, {args = {'[Buffy DB]', 'If there were no errors, the '..name..' society will have access to their menu, ledger and inventory next restart'..hasMoney}})
end)
--[[
INSERT INTO `container` (`name`, `items`) VALUES
    ('laviniarangers', '[]');

INSERT INTO `society` (`job`, `jobgrade`, `salary`) VALUES
    (@name, 0, 0),
    (@name, 1, 0),
    (@name, 2, 0),
    (@name, 3, 0);

INSERT INTO `society_ledger` (`job`, `ledger`) VALUES
    ('laviniarangers', 400);
]]