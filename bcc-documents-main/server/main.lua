---@diagnostic disable: undefined-global
VORPcore = exports.vorp_core:GetCore()

-- Function to print debug information if devMode is enabled
local function devPrint(...)
    if Config.devMode then
        print(...)
    end
end

--character records like date of birth
local loaded_records = LoadResourceFile(GetCurrentResourceName(), 'data_character_records.json')
local character_records = json.decode(loaded_records)
Citizen.CreateThread(function()
    while true do
        SaveResourceFile(GetCurrentResourceName(), 'data_character_records.json', json.encode(character_records), -1)
        --TriggerClientEvent('chat:addMessage', -1, {args = {'','saved '..tableToString(playerLanguage)}})
        Citizen.Wait(700000) --save every 700 seconds
    end
end)

-- Function to handle the usage of a document
function handleDocumentUse(src, docType, docDisplayName)
    local User = VORPcore.getUser(src)

    if User then
        local Character = User.getUsedCharacter
        if Character then
            local charidentifier = Character.charIdentifier
            local date_of_birth
            local place_of_birth
            local occupation
            if character_records[tostring(Character.charIdentifier)] ~= nil then
                date_of_birth = character_records[tostring(Character.charIdentifier)].date_of_birth
                place_of_birth = character_records[tostring(Character.charIdentifier)].place_of_birth
                occupation = character_records[tostring(Character.charIdentifier)].occupation or ""
            end
            devPrint("Checking document for user:", charidentifier, "docType:", docType)

            MySQL.query('SELECT * FROM `bcc_documents` WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
                if result and #result > 0 then
                    local doc = result[1]
                    devPrint("Document found:", json.encode(doc))  -- Use json.encode to print the table contents
                    TriggerClientEvent('bcc-documents:client:opendocument', src, docType, doc.firstname, doc.lastname, doc.nickname, doc.job, doc.age, doc.gender, doc.date, doc.picture, doc.expire_date, date_of_birth, place_of_birth, occupation)
                else
                    print("ERROR: No document found for user:", charidentifier, "docType:", docType)
                end
                -- Close inventory only after event handling
                exports.vorp_inventory:closeInventory(src)
            end)
        else
            devPrint("Error: Character data not found for user:", src)
        end
    else
        devPrint("Error: User not found for source:", src)
    end
end

-- Iterate over each document type and register it as a usable item
for docType, docData in pairs(Config.DocumentTypes) do
    exports.vorp_inventory:registerUsableItem(docType, function(data)
        local src = data.source
        exports.vorp_inventory:closeInventory(src)  -- Close inventory on use
        handleDocumentUse(src, docType, docData.displayName)  -- Pass the display name
    end)
end

-- Register other server events
RegisterServerEvent('bcc-documents:server:createDocument')
AddEventHandler('bcc-documents:server:createDocument', function(docType)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local price = Config.DocumentTypes[docType].price
    local year = Config.PlayYear
    local date = os.date(year..'-%m-%d %H:%M:%S')
    local newExpiryDate = os.date(year..'-%m-%d %H:%M:%S', os.time() + (Config.DocumentTypes[docType].expiryDays * 86400))
    local picture = Config.DocumentTypes[docType].defaultPicture

    devPrint("Creating document for user:", charidentifier, "docType:", docType)

    MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
        if Money >= price then
            if exports.vorp_inventory:canCarryItems(src, 1) and exports.vorp_inventory:canCarryItem(src, docType, 1) then
                MySQL.insert('INSERT INTO bcc_documents (identifier, charidentifier, doc_type, firstname, lastname, nickname, job, age, gender, date, picture, expire_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                {
                    Character.identifier, charidentifier, docType,
                    Character.firstname, Character.lastname, Character.nickname,
                    Character.jobLabel, Character.age, Character.gender,
                    date, picture, newExpiryDate
                }, function()
                    Character.removeCurrency(0, price)
                    exports.vorp_inventory:addItem(src, docType, 1)
                end)
                VORPcore.NotifyRightTip(src, _U('BoughtDocument') .. " for $"..price, "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
            else
                VORPcore.NotifyRightTip(src, _U('PocketFull'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
            end
        else
            VORPcore.NotifyRightTip(src, _U('NotEnoughMoney'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end)
end)

RegisterServerEvent('bcc-documents:server:createDocumentCommand')
AddEventHandler('bcc-documents:server:createDocumentCommand', function(src, document, job, args)
    local src = src
    local Character = VORPcore.getUser(src).getUsedCharacter
    local targetID = tonumber(args[1])
    local target = VORPcore.getUser(targetID).getUsedCharacter
    local targetIdentifier = target.charIdentifier
    local docType = document
    local year = Config.PlayYear
    local date = os.date(year..'-%m-%d %H:%M:%S')
    local newExpiryDate = os.date(year..'-%m-%d %H:%M:%S', os.time() + (Config.DocumentTypes[docType].expiryDays * 86400))
    local picture = Config.DocumentTypes[docType].defaultPicture
    local itemNeedCount = exports.vorp_inventory:getItemCount(src, nil, Config.NeedItemName)
    if Config.NeedItem then
        if itemNeedCount <= 1 then
            Giveable = false
            VORPcore.NotifyRightTip(src, _U('NoNeedItem') .. Config.NeedItemName, "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
            return
        else
            Giveable = true
        end
    else
        Giveable = true
    end
    if Giveable then
        if Character.job == job or Character.job == Config.AdminJob then
            devPrint("Creating document for user:", targetIdentifier, "docType:", docType)
            MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {targetIdentifier, docType}, function(result2)
                if exports.vorp_inventory:canCarryItems(targetID, 1) and exports.vorp_inventory:canCarryItem(targetID, docType, 1) then
                    MySQL.insert('INSERT INTO bcc_documents (identifier, charidentifier, doc_type, firstname, lastname, nickname, job, age, gender, date, picture, expire_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                    {
                        target.identifier, targetIdentifier, docType,
                        target.firstname, target.lastname, target.nickname,
                        target.jobLabel, target.age, target.gender,
                        date, picture, newExpiryDate
                    }, function()
                        VORPcore.NotifyRightTip(src, _U('GiveDocument') .. docType, "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
                        VORPcore.NotifyRightTip(targetID, _U('GetDocument') .. docType, "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
                        exports.vorp_inventory:addItem(targetID, docType, 1)
                        if Config.NeedItem then
                            exports.vorp_inventory:subItem(src, Config.NeedItemName, 1)
                        end
                    end)
                else
                    VORPcore.NotifyRightTip(src, _U('PocketFull'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
                end
            end)
        else
            VORPcore.NotifyRightTip(src, _U('NoJob'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end
end)

RegisterServerEvent('bcc-documents:server:reissueDocument')
AddEventHandler('bcc-documents:server:reissueDocument', function(docType)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local docReissuePrice = Config.DocumentTypes[docType].reissuePrice

    devPrint("Reissuing document for user:", charidentifier, "docType:", docType)
    MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
        if result and result[1] then
            if Money >= docReissuePrice then
                if exports.vorp_inventory:canCarryItems(src, 1) and exports.vorp_inventory:canCarryItem(src, docType, 1) then
                    MySQL.update('UPDATE bcc_documents SET job = ? WHERE charidentifier = ? AND doc_type = ?',
                    {Character.jobLabel, charidentifier, docType}, function(affectedRows)
                        if affectedRows > 0 then
                            Character.removeCurrency(0, docReissuePrice)
                            exports.vorp_inventory:addItem(src, docType, 1)
                            VORPcore.NotifyRightTip(src, _U('DocumentUpdated') .. docReissuePrice .. '$', "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
                        else
                            VORPcore.NotifyRightTip(src, _U('DocumentUpdateFail'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
                        end
                    end)
                else
                    VORPcore.NotifyRightTip(src, _U('PocketFull'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
                end
            else
                VORPcore.NotifyRightTip(src, _U('NotEnoughMoney'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
            end
        else
            VORPcore.NotifyRightTip(src, _U('GotNoDocument'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end)
end)

RegisterServerEvent('bcc-documents:server:revokeMyDocument')
AddEventHandler('bcc-documents:server:revokeMyDocument', function(docType)
    if not docType or docType == '' then
        devPrint("Error: docType is nil or empty")
        return
    end

    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter

    if Character then
        local charidentifier = Character.charIdentifier
        devPrint("Revoking document for user:", charidentifier, "docType:", docType)

        MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
            if result and result[1] then
                MySQL.execute('DELETE FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function()
                    exports.vorp_inventory:subItem(src, docType, 1)
                    VORPcore.NotifyRightTip(src, _U('YouRevokedDocument')..Config.DocumentTypes[docType].displayName, "", Config.Textures.cross[1], Config.Textures.cross[2], 4000)
                end)
            else
                VORPcore.NotifyRightTip(src, "No document found to remove.", "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
            end
        end)
    else
        VORPcore.NotifyRightTip(src, "No character found, try again and be careful to get the info correct!", "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
    end
end)

RegisterServerEvent('bcc-documents:server:changeDocumentPhoto')
AddEventHandler('bcc-documents:server:changeDocumentPhoto', function(docType, photoLink)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local Money = Character.money
    local photoChangePrice = Config.DocumentTypes[docType].changePhotoPrice

    devPrint("Changing document photo for user:", charidentifier, "docType:", docType, "photoLink:", photoLink)

    MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
        if result and result[1] then
            if Money >= photoChangePrice then
                Character.removeCurrency(0, photoChangePrice)
                VORPcore.NotifyRightTip(src, _U('ChangedPicture') .. photoChangePrice .. '$', "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
                MySQL.update('UPDATE bcc_documents SET picture = ? WHERE charidentifier = ? AND doc_type = ?', {photoLink, charidentifier, docType})
            else
                VORPcore.NotifyRightTip(src, _U('NotEnoughMoney'), "", Config.Textures.cross[1], Config.Textures.cross[2], 4000)
            end
        else
            VORPcore.NotifyRightTip(src, _U('GotNoDocument'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end)
end)

RegisterServerEvent('bcc-documents:server:showDocumentClosestPlayer')
AddEventHandler('bcc-documents:server:showDocumentClosestPlayer', function(docType)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local MyPedId = GetPlayerPed(src)
    local MyCoords = GetEntityCoords(MyPedId)

    devPrint("Showing document to closest player for user:", charidentifier, "docType:", docType)

    MySQL.query('SELECT * FROM `bcc_documents` WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
        if result and #result > 0 then
            local doc = result[1]
            local closestPlayer, closestDistance = nil, math.huge
            local date_of_birth
            local place_of_birth
            local occupation
            if character_records[tostring(Character.charIdentifier)] ~= nil then
                date_of_birth = character_records[tostring(Character.charIdentifier)].date_of_birth
                place_of_birth = character_records[tostring(Character.charIdentifier)].place_of_birth
                occupation = character_records[tostring(Character.charIdentifier)].occupation or ""
            end
            for _, playerId in ipairs(GetPlayers()) do
                local playerPedId = GetPlayerPed(playerId)
                local playerCoords = GetEntityCoords(playerPedId)
                local distance = #(MyCoords - playerCoords)

                if distance < closestDistance and distance <= 3.0 and distance > 0.3 and playerId ~= src then
                    closestPlayer, closestDistance = playerId, distance
                end
            end

            if closestPlayer then
                devPrint("Found closest player:", closestPlayer)
                TriggerClientEvent('bcc-documents:client:showdocument', closestPlayer, docType, doc.firstname, doc.lastname, doc.nickname, doc.job, doc.age, doc.gender, doc.date, doc.picture, doc.expire_date, date_of_birth, place_of_birth, occupation)
            else
                VORPcore.NotifyRightTip(src, _U('NoNearbyPlayer'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
            end
        else
            VORPcore.NotifyRightTip(src, _U('GotNoDocument'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end)
end)

RegisterServerEvent('bcc-documents:server:showDocumentToPlayer')
AddEventHandler('bcc-documents:server:showDocumentToPlayer', function(targetPlayerId, docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    if Character then
        devPrint("Showing document to player ID:", targetPlayerId)
        TriggerClientEvent('bcc-documents:client:showdocument', targetPlayerId, docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    end
end)

RegisterNetEvent('bcc-documents:server:updateExpiryDate')
AddEventHandler('bcc-documents:server:updateExpiryDate', function(docType, daysToAdd)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local Money = Character.money

    local days = tonumber(daysToAdd) or 0
    local extendChangePricePerDay = Config.DocumentTypes[docType].extendPrice
    local totalExtendPrice = extendChangePricePerDay * days

    devPrint("Updating expiry date for user:", charidentifier, "docType:", docType, "daysToAdd:", daysToAdd)

    MySQL.query('SELECT * FROM bcc_documents WHERE charidentifier = ? AND doc_type = ?', {charidentifier, docType}, function(result)
        if result and result[1] then
            if Money >= totalExtendPrice then
                local currentTime = os.time()
                local year = Config.PlayYear
                local newExpiryDate = os.date(year..'-%m-%d %H:%M:%S', currentTime + (days * 86400))

                MySQL.update('UPDATE bcc_documents SET expire_date = ? WHERE charidentifier = ? AND doc_type = ?', {newExpiryDate, charidentifier, docType}, function(affectedRows)
                    if affectedRows > 0 then
                        Character.removeCurrency(0, totalExtendPrice)
                        VORPcore.NotifyRightTip(src, _U('ExpiryDateExtended') .. newExpiryDate, "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
                    else
                        VORPcore.NotifyRightTip(src, _U('ExpiryDateUpdateFailed'), "", Config.Textures.cross[1], Config.Textures.cross[2], 4000)
                    end
                end)
            else
                VORPcore.NotifyRightTip(src, _U('NotEnoughMoney'), "", Config.Textures.cross[1], Config.Textures.cross[2], 4000)
            end
        else
            VORPcore.NotifyRightTip(src, _U('GotNoDocument'), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        end
    end)
end)


RegisterServerEvent('bcc-documents:server:changeBirthDate')
AddEventHandler('bcc-documents:server:changeBirthDate', function(date)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = tostring(Character.charIdentifier)
    local Money = Character.money
    local changeBirthDatePrice = Config.UpdateRecordPrice or 15

    print("[BCC Documents] "..Character.firstname.." "..Character.lastname.." updated their date of birth to "..tostring(date))
    if date then
        if Money >= changeBirthDatePrice then
            Character.removeCurrency(0, changeBirthDatePrice)
            if character_records[charidentifier] ~= nil then
                character_records[charidentifier].date_of_birth = date
            end
            VORPcore.NotifyRightTip(src, "You updated your birth records for $" .. changeBirthDatePrice, "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
            print("[BCC Documents] "..Character.firstname.." "..Character.lastname.." updated their date of birth to "..tostring(date))
        else
            VORPcore.NotifyRightTip(src, _U('NotEnoughMoney'), "", Config.Textures.cross[1], Config.Textures.cross[2], 4000)
        end
    else
        VORPcore.NotifyRightTip(src, "[Buffy Alert] Something went wrong. Debug info: "..tostring(date).." "..tostring(charidentifier), "", Config.Textures.cross[1], Config.Textures.cross[2], 5000)
        print("[Buffy Alert] Something went wrong. Debug info: "..tostring(date).." "..tostring(charidentifier))
    end
end)
RegisterServerEvent('bcc-documents:server:changeBirthPlace')
AddEventHandler('bcc-documents:server:changeBirthPlace', function(place)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = tostring(Character.charIdentifier)
    local Money = Character.money
    local changeBirthPlacePrice = Config.UpdateRecordPrice or 15
    if place then
        if Money >= changeBirthPlacePrice then
            Character.removeCurrency(0, changeBirthPlacePrice)
            if character_records[charidentifier] ~= nil then
                character_records[charidentifier].place_of_birth = place
                print("[BCC Documents] "..Character.firstname.." "..Character.lastname.." updated their place of birth to "..tostring(place))
            end
        end
    else
        print("[Buffy Alert] Something went wrong. Debug info: "..tostring(place).." "..tostring(charidentifier))
    end
end)
RegisterServerEvent('bcc-documents:server:changeOccupation')
AddEventHandler('bcc-documents:server:changeOccupation', function(occupation)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = tostring(Character.charIdentifier)
    local Money = Character.money
    local changeOccupationPrice = Config.UpdateRecordPrice or 15
    if occupation then
        if Money >= changeOccupationPrice then
            Character.removeCurrency(0, changeOccupationPrice)
            if character_records[charidentifier] ~= nil then
                character_records[charidentifier].occupation = occupation
                print("[BCC Documents] "..Character.firstname.." "..Character.lastname.." updated their occupation to "..tostring(occupation))
            else
                VORPcore.NotifyRightTip(src, "The license office is loading, please try again in a moment.", "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
            end
        end
    else
        print("[Buffy Alert] Something went wrong. Debug info: "..tostring(occupation).." "..tostring(charidentifier))
    end
end)

RegisterServerEvent('bcc-documents:server:checkRecordsExist')
AddEventHandler('bcc-documents:server:checkRecordsExist', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local charidentifier = tostring(Character.charIdentifier)

    if character_records == nil then
        VORPcore.NotifyRightTip(src, "The license office is loading, please try again in a moment.", "", Config.Textures.tick[1], Config.Textures.tick[2], 5000)
        character_records = {}
        TriggerClientEvent('bcc-documents:client:checkRecordsExist', src, "loading")
        return
    end
    print("[BCC Documents] Checking if "..Character.firstname.." "..Character.lastname.." has all required records registered ")
    if character_records[charidentifier] == nil then
        character_records[charidentifier] = {}
        character_records[charidentifier].full_name = Character.firstname.." "..Character.lastname
        character_records[charidentifier].date_of_birth = ""
        character_records[charidentifier].place_of_birth = ""
        character_records[charidentifier].occupation = ""
    end
    if character_records[charidentifier].date_of_birth == "" then
        print("[BCC Documents] No Record found for "..Character.firstname.." "..Character.lastname)
        TriggerClientEvent('bcc-documents:client:checkRecordsExist', src, "birth date")
        return
    end
    if character_records[charidentifier].place_of_birth == "" then
        print("[BCC Documents] No Place of Birth Record found for "..Character.firstname.." "..Character.lastname)
        TriggerClientEvent('bcc-documents:client:checkRecordsExist', src, "birth place")
        return
    end
    TriggerClientEvent('bcc-documents:client:checkRecordsExist', src, false)
end)

RegisterServerEvent('bcc-documents:server:getUpdatedRecords')
AddEventHandler('bcc-documents:server:getUpdatedRecords', function()
    local src = source
    TriggerClientEvent('bcc-documents:client:getUpdatedRecords', src, character_records)
end)

--
Citizen.CreateThread(function()
    for _, docs in pairs(Config.DocumentTypes) do
        if docs.givenCommand then
            local command = docs.givenCommand
            local document = _
            local job = docs.allowJob
            RegisterCommands(command, document, job)
        end
    end
end)

function RegisterCommands(command, document, job)
    RegisterCommand(command, function(source, args, rawCommand)
    local src = source
    TriggerEvent('bcc-documents:server:createDocumentCommand', src, document, job, args)
    end)
    devPrint("--------------------------------------------------------------")
    devPrint("Command Registered!", command)
    devPrint("--------------------------------------------------------------")
end
