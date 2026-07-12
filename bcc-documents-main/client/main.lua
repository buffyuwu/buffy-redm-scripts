local CreatedBlip = {}
local CreatedNpc = {}
local documentMainMenu

local function debugPrint(...)
    if Config.devMode then
        print(...)
    end
end


local maskeds = {}
local buffy_playerNames = {} --locally stored table of all player names sorted by id
RegisterNetEvent('buffy_namedata')
AddEventHandler('buffy_namedata', function(names, masknames)
	if names then buffy_playerNames = names; end
	if masknames then maskeds = masknames; end
end)


Citizen.CreateThread(function()
    local DocumentMenuPrompt = BccUtils.Prompts:SetupPromptGroup()
    local documentprompt = DocumentMenuPrompt:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold',
        { timedeventhash = 'MEDIUM_TIMED_EVENT' })

    if Config.DocumentBlips then
        for _, v in pairs(Config.DocumentLocations) do
            local DocumentBlip = BccUtils.Blips:SetBlip(_U('BlipName'), 'blip_job_board', 3.2, v.coords.x, v.coords.y,
                v.coords.z)
            CreatedBlip[#CreatedBlip + 1] = DocumentBlip
        end
    end

    if Config.DocumentNPC then
        for _, v in pairs(Config.DocumentLocations) do
            local documentped = BccUtils.Ped:Create('MP_POST_RELAY_MALES_01', v.coords.x, v.coords.y, v.coords.z - 1, 0,
                'world', false)
            CreatedNpc[#CreatedNpc + 1] = documentped
            documentped:Freeze()
            documentped:SetHeading(v.NpcHeading)
            documentped:Invincible()
        end
    end

    while true do
        Wait(1)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, v in pairs(Config.DocumentLocations) do
            local dist = #(playerCoords - v.coords)
            if dist < 2 then
                DocumentMenuPrompt:ShowGroup(_U('Licenses'))
                if documentprompt:HasCompleted() then
                    OpenMenu()
                end
            end
        end
    end
end)

function openMainMenu()
    if documentMainMenu then
        documentMainMenu:RouteTo()
    else
        debugPrint("Error: documentMainMenu is not initialized.")
    end
end
local missingRecords = false
RegisterNetEvent('bcc-documents:client:checkRecordsExist')
AddEventHandler('bcc-documents:client:checkRecordsExist', function(result)
    missingRecords = result
    if missingRecords ~= "loading" then
        if missingRecords ~= false then
            FeatherMenu:Notify({ message = 'You must register a '..missingRecords..' to continue.' }, function(data)
            end)
        end
    end
    if missingRecords == "loading" then
        BCCDocumentsInspectMenu:Close({})
        BCCDocumentsMainMenu:Close({})
        return
    end
end)
local characterRecords = {}
RegisterNetEvent('bcc-documents:client:getUpdatedRecords')
AddEventHandler('bcc-documents:client:getUpdatedRecords', function(result)
    characterRecords = result
end)
function OpenMenu()
    TriggerServerEvent('bcc-documents:server:checkRecordsExist')
    Wait(1000)
    documentMainMenu = BCCDocumentsMainMenu:RegisterPage("Main:Page")
    documentMainMenu:RegisterElement('header', {
        value = _U('Licenses'),
        slot = 'header',
        style = {}
    })
    documentMainMenu:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    print("DOB Exists? "..tostring(missingRecords))

    if missingRecords == false then --no missing records, show the regular menus
        for docType, settings in pairs(Config.DocumentTypes) do
            if settings.sellNpc then
                documentMainMenu:RegisterElement('button', {
                    label = settings.displayName,
                    style = {}
                }, function()
                    OpenDocumentSubMenu(docType)
                end)
            end
        end
        documentMainMenu:RegisterElement('button', {
        label = "Update Records",
        style = {}
        }, function()
            ChangeRecordsSubMenu()
        end)
    elseif missingRecords == "loading" then
        BCCDocumentsInspectMenu:Close({})
        BCCDocumentsMainMenu:Close({})
        return
    else
        documentMainMenu:RegisterElement('button', {
        label = "Create Records",
        style = {}
        }, function()
            ChangeRecordsSubMenu()
        end)
    end

    documentMainMenu:RegisterElement('bottomline', {
        style = {}
    })
    BCCDocumentsMainMenu:Open({
        startupPage = documentMainMenu
    })
end

function ChangeRecordsSubMenu()
    local changeRecordsSubMenu = BCCDocumentsMainMenu:RegisterPage("submenu:changerecords")
    changeRecordsSubMenu:RegisterElement('button', {
        label = "Update Birth Record".. " - $" .. Config.UpdateRecordPrice,
        style = {}
    }, function()
        UpdateBirthDate()
        end)
    changeRecordsSubMenu:RegisterElement('button', {
        label = "Update Place of Birth".. " - $" .. Config.UpdateRecordPrice,
        style = {}
    }, function()
        UpdatePlaceOfBirth()
        end)
    changeRecordsSubMenu:RegisterElement('button', {
        label = "Update Occupation".. " - $" .. Config.UpdateRecordPrice,
        style = {}
    }, function()
        UpdateOccupation()
        end)
    BCCDocumentsMainMenu:Open({
        startupPage = changeRecordsSubMenu
    })
end
function UpdatePlaceOfBirth(docType)
    local ChangePOBPage = BCCDocumentsMainMenu:RegisterPage('change:pob')
    local newPOB
    ChangePOBPage:RegisterElement('header', {
        value = "Update Birth Record",
        slot = 'header',
        style = {}
    })
    ChangePOBPage:RegisterElement('input', {
        label = "Birth Place",
        placeholder = "Lavinia",
        persist = false,
        style = {}
    }, function(data)
        if data.value and data.value ~= "" then
            newPOB = data.value
        else
            debugPrint("Invalid place of birth entered.")
        end
    end)

    ChangePOBPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })
    local TextDisplay = ChangePOBPage:RegisterElement('textdisplay', {
        value = "",
        style = {}
    })
    ChangePOBPage:RegisterElement('button', {
        label = _U('Submit'),
        slot = 'footer',
        style = {}
    }, function()
        if newPOB and string.len(newPOB) <= 15 then
            TriggerServerEvent('bcc-documents:server:changeBirthPlace', newPOB)
            TextDisplay:update({
            value = "Your place of birth has been updated to: "..newPOB..". If you have licenses, you may destroy them and get new ones to see the update.",
            style = {}
            })
            Wait(1000)
            BCCDocumentsInspectMenu:Close({})
            BCCDocumentsMainMenu:Close({})
        else
            debugPrint("Error: Invalid POB!")
            TextDisplay:update({
            value = "Please enter a valid place of birth that is under 15 characters. Example: Lemoyne",
            style = {}
            })
        end
    end)
    BCCDocumentsMainMenu:Open({
        startupPage = ChangePOBPage
    })
end

function UpdateOccupation(docType)
local ChangeOccupationPage = BCCDocumentsMainMenu:RegisterPage('change:occupation')
local newOccupation
ChangeOccupationPage:RegisterElement('header', {
    value = "Update Occupation",
    slot = 'header',
    style = {}
})
ChangeOccupationPage:RegisterElement('input', {
    label = "Occupation",
    placeholder = "Unemployed",
    persist = false,
    style = {}
}, function(data)
    if data.value and data.value ~= "" then
        newOccupation = data.value
    else
        debugPrint("Invalid occupation entered.")
    end
end)

ChangeOccupationPage:RegisterElement('line', {
    slot = 'footer',
    style = {}
})
local TextDisplay = ChangeOccupationPage:RegisterElement('textdisplay', {
    value = "",
    style = {}
})
ChangeOccupationPage:RegisterElement('button', {
    label = _U('Submit'),
    slot = 'footer',
    style = {}
}, function()
    if newOccupation and string.len(newOccupation) <= 20 then
        TriggerServerEvent('bcc-documents:server:changeOccupation', newOccupation)
        TextDisplay:update({
        value = "Your occupation has been updated to: "..newOccupation..". If you have licenses, you may destroy them and get new ones to see the update.",
        style = {}
        })
        Wait(1000)
        BCCDocumentsInspectMenu:Close({})
        BCCDocumentsMainMenu:Close({})
    else
        debugPrint("Error: Invalid Occupation!")
        TextDisplay:update({
        value = "Please enter a valid occupation that is under 20 characters. Example: WESO Deputy",
        style = {}
        })
    end
end)


    ChangeOccupationPage:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = ChangeOccupationPage
    })
end
function OpenDocumentSubMenu(docType)
    local documentSubMenu = BCCDocumentsMainMenu:RegisterPage("submenu:" .. docType)

    documentSubMenu:RegisterElement('header', {
        value = Config.DocumentTypes[docType].displayName,
        slot = 'header',
        style = {}
    })
    documentSubMenu:RegisterElement('button', {
        label = _U('RegisterDoc') .. " - $" .. Config.DocumentTypes[docType].price,
        style = {}
    }, function()
        TriggerEvent('bcc-documents:client:createDocument', docType)
    end)

    if docType == 'idcard' then
        documentSubMenu:RegisterElement('button', {
            label = _U('ChangePicture') .. " - $" .. Config.DocumentTypes[docType].changePhotoPrice,
            style = {}
        }, function()
            ChangeDocumentPhoto(docType)
        end)
    end

    documentSubMenu:RegisterElement('button', {
        label = _U('DocumentLost') .. " - $" .. Config.DocumentTypes[docType].reissuePrice,
        style = {}
    }, function()
        TriggerEvent('bcc-documents:client:reissueDocument', docType)
    end)

    if docType ~= 'idcard' or docType ~= 'weaponlicense' then
        local docConfig = Config.DocumentTypes[docType]
        documentSubMenu:RegisterElement('button', {
            label = _U('ExtendExpiry') .. " - $" .. docConfig.extendPrice,
            style = {}
        }, function()
            AddExpiryDate(docType)
        end)
    end

    documentSubMenu:RegisterElement('line', {
        value = _U('Licenses'),
        slot = 'footer',
        style = {}
    })

    documentSubMenu:RegisterElement('button', {
        label = _U('BackButton'),
        slot = 'footer',
        style = {}
    }, function()
        openMainMenu()
    end)

    documentSubMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = documentSubMenu
    })
end
function UpdateBirthDate(docType)
    local ChangeDOBPage = BCCDocumentsMainMenu:RegisterPage('change:dob')
    local newDOB
    ChangeDOBPage:RegisterElement('header', {
        value = "Update Birth Record",
        slot = 'header',
        style = {}
    })
    ChangeDOBPage:RegisterElement('input', {
        label = "Date of Birth (DOB)",
        placeholder = "01-29-1855",
        persist = false,
        style = {}
    }, function(data)
        if data.value and data.value ~= "" then
            newDOB = data.value
        else
            debugPrint("Invalid DOB entered.")
        end
    end)

    ChangeDOBPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })
    local TextDisplay = ChangeDOBPage:RegisterElement('textdisplay', {
        value = "",
        style = {}
    })
    ChangeDOBPage:RegisterElement('button', {
        label = _U('Submit'),
        slot = 'footer',
        style = {}
    }, function()
        if newDOB and string.len(newDOB) <= 10 then
            TriggerServerEvent('bcc-documents:server:changeBirthDate', newDOB)
            TextDisplay:update({
            value = "Your date of birth has been updated to: "..newDOB..". If you have licenses, you may destroy them and get new ones to see the updated date.",
            style = {}
            })
            Wait(1000)
            BCCDocumentsInspectMenu:Close({})
            BCCDocumentsMainMenu:Close({})
        else
            debugPrint("Error: Invalid DOB!")
            TextDisplay:update({
            value = "Please enter a valid date of birth. Example: 01-29-1865",
            style = {}
            })
        end
    end)

    ChangeDOBPage:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = ChangeDOBPage
    })
end

function ChangeDocumentPhoto(docType)
    local ChangePhotoPage = BCCDocumentsMainMenu:RegisterPage('change:photo')
    local photoLink = nil

    ChangePhotoPage:RegisterElement('header', {
        value = Config.DocumentTypes[docType].displayName,
        slot = 'header',
        style = {}
    })
    ChangePhotoPage:RegisterElement('input', {
        label = _U('InputPhotolink'),
        placeholder = _U('PastePhotoLink'),
        persist = false,
        style = {}
    }, function(data)
        if data.value and data.value ~= "" then
            photoLink = data.value
        else
            debugPrint("Invalid photo URL.")
        end
    end)

    ChangePhotoPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    ChangePhotoPage:RegisterElement('button', {
        label = _U('Submit'),
        slot = 'footer',
        style = {}
    }, function()
        if docType and photoLink then
            TriggerServerEvent('bcc-documents:server:changeDocumentPhoto', docType, photoLink)
            OpenDocumentSubMenu(docType)
        else
            debugPrint("Error: Missing document type or photo URL.")
        end
    end)

    ChangePhotoPage:RegisterElement('button', {
        label = _U('BackButton'),
        slot = 'footer',
        style = {}
    }, function()
        OpenDocumentSubMenu(docType)
    end)

    ChangePhotoPage:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = ChangePhotoPage
    })
end

function AddExpiryDate(docType)
    local inputPage = BCCDocumentsMainMenu:RegisterPage("input:expiry")
    local daysToAdd = nil

    inputPage:RegisterElement('header', {
        value = Config.DocumentTypes[docType].displayName,
        slot = 'header',
        style = {}
    })

    inputPage:RegisterElement('input', {
        label = _U('EnterExpiryDays'),
        placeholder = _U('NumberOfDays'),
        inputType = 'number',
        slot = 'content',
        style = {}
    }, function(data)
        if tonumber(data.value) and tonumber(data.value) > 0 then
            daysToAdd = tonumber(data.value)
        else
            daysToAdd = nil
            debugPrint("Invalid input for days.")
        end
    end)

    inputPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    inputPage:RegisterElement('button', {
        label = _U('Confirm'),
        slot = 'footer',
        style = {}
    }, function()
        if daysToAdd then
            TriggerServerEvent('bcc-documents:server:updateExpiryDate', docType, daysToAdd)
            OpenDocumentSubMenu(docType)
        else
            debugPrint("Error: Number of days not set or invalid.")
        end
    end)

    inputPage:RegisterElement('button', {
        label = _U('BackButton'),
        slot = 'footer',
        style = {}
    }, function()
        OpenDocumentSubMenu(docType)
    end)

    inputPage:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = inputPage
    })
end

local function checkPictureExists(picture)
    local defaultPhoto = "https://files.catbox.moe/2nm7sq.jpg"
    if picture == nil or picture == "" then
        picture = defaultPhoto
        print("Using default photo: "..tostring(picture))
        return picture
    else
        print("Using custom photo: "..tostring(picture))
        return picture
    end
end

local function checkAgeExists(age, date_of_birth)
    if date_of_birth == nil or date_of_birth == "" then
        local defaultAgeFormat = tonumber(Config.PlayYear) - tonumber(age) --if this is just a year, we need to subtract their current age by the current year to get their year of birth
        print("Using default age format: "..tostring(age).." - "..Config.PlayYear.." = "..defaultAgeFormat)
        return defaultAgeFormat
    else
        return date_of_birth --their age is a proper date of birth and doesnt need modifying
    end
end
local function checkOccupationExists(job, occupation)
    if occupation == nil or occupation == "" then
        print("No custom occupation set, using default job: "..job)
        return job
    else
        return occupation --their age is a proper date of birth and doesnt need modifying
    end
end
function ShowDocument(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    local DocumentPageShow = BCCDocumentsInspectMenu:RegisterPage("show:document")
    picture = checkPictureExists(picture)
    job = checkOccupationExists(job, occupation)
    DocumentPageShow:RegisterElement('header', {
    value = ' ',
    style = {['opacity'] = '50%',['position'] = 'absolute', ['height'] = '10%',['width'] = '92%'}
    })
    if docType == "idcard" or docType == "weaponlicense" then
        DocumentPageShow:RegisterElement("html", {
            value = [[
                <div style="font-size: 20px; color: black; margin-top: 1.25%">]]..(Config.DocumentTypes[docType].displayName)..[[</div>
                <div style="font-size: 10px; color: black;">]].."Issued "..(date)..[[</div>
                <div style="position: absolute; width: 35%; margin-top: 5%; margin-left: 5%;border: 6px solid transparent; border: 6px solid #000; border-radius: 6px">
                <img width="256px" height="256px" style="margin: 0 auto;" src="]] .. (picture) .. [[" />
                </div>
                <div style="position: absolute;text-align: left; width: 50%;white-space: nowrap; overflow: hidden; padding: 1%; font-size: 25px; color: black;margin-top: 6%; margin-left: 41%;">
                    <p><b>]] .. "Name:" .. [[</b> ]] .. (firstname or 'Unknown') .." ".. (lastname or 'Unknown') ..[[</p>
                    <p><b>]] .. "Date of Birth:" .. [[</b> ]] .. (age or 'Unknown') .. [[</p>
                    <p><b>]] .. "Birth Place:" .. [[</b> ]] .. (place_of_birth or 'Unknown') .. [[</p>
                    <p><b>]] .. _U('Gender') .. [[</b> ]] .. (gender or 'Unknown') .. [[</p>
                    <p><b>]] .. "Occupation:" .. [[</b> ]] .. (job or 'Unknown') .. [[</p>
                    <p><div style="font-size: 10px; color: black;">]].."Expires "..(string.sub(expire_date,1,10))..[[</div></p>
                </div>
            ]]
        })
    else
        DocumentPageShow:RegisterElement("html", {
            value = [[
                <div style="font-size: 20px; color: black; margin-top: 1.25%">]]..(Config.DocumentTypes[docType].displayName)..[[</div>
                <div style="font-size: 10px; color: black;">]].."Issued "..((string.sub(date,1,10)))..[[</div>
                <div style="position: absolute; width: 35%; margin-top: 4%; margin-left: 5%;border: 6px solid transparent; border: 6px solid #000; border-radius: 6px">
                <img width="256px" height="256px" style="margin: 0 auto;" src="]] .. (picture) .. [[" />
                </div>
                <div style="position: absolute;text-align: left; width: 50%;white-space: nowrap; overflow: hidden; padding: 1%; font-size: 25px; color: black;margin-top: 5%; margin-left: 41%;">
                    <p><b>]] .. "Name:" .. [[</b> ]] .. (firstname or 'Unknown') .." ".. (lastname or 'Unknown') ..[[</p>
                    <p><b>]] .. "Date of Birth:" .. [[</b> ]] .. (age or 'Unknown') .. [[</p>
                    <p><b>]] .. "Birth Place:" .. [[</b> ]] .. (place_of_birth or 'Unknown') .. [[</p>
                    <p><b>]] .. _U('Gender') .. [[</b> ]] .. (gender or 'Unknown') .. [[</p>
                    <p><b>]] .. "Occupation:" .. [[</b> ]] .. (job or 'Unknown') .. [[</p>
                    <p><div style="font-size: 10px; color: black;">]].."Expires "..(string.sub(expire_date,1,10))..[[</div></p>
                </div>
            ]]
            
        })
    end
    BCCDocumentsInspectMenu:Open({
        startupPage = DocumentPageShow
    })
end

function OpenDocument(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    local DocumentPageOpen = BCCDocumentsInspectMenu:RegisterPage("open:document")
    picture = checkPictureExists(picture)
    job = checkOccupationExists(job, occupation)
    age = checkAgeExists(age, date_of_birth)
    DocumentPageOpen:RegisterElement('header', {
        value = ' ',
        style = {['opacity'] = '50%',['position'] = 'absolute', ['height'] = '12%',['width'] = '92%'}
    })

    DocumentPageOpen:RegisterElement('line', {
    })

    if docType == "idcard" or docType == "weaponlicense" then
        DocumentPageOpen:RegisterElement("html", {
            value = [[
                <div style="font-size: 20px; color: black;">]]..(Config.DocumentTypes[docType].displayName)..[[</div>
                <div style="font-size: 10px; color: black;">]].."Issued "..((string.sub(date,1,10)))..[[</div>
                <div style="position: absolute; width: 35%; margin-top: 4%; margin-left: 5%;border: 6px solid transparent; border: 6px solid #000; border-radius: 6px">
                <img width="256px" height="256px" style="margin: 0 auto;" src="]] .. (picture) .. [[" />
                </div>
                <div style="position: absolute;text-align: left; width: 50%;white-space: nowrap; overflow: hidden; padding: 1%; font-size: 25px; color: black;margin-top: 5%; margin-left: 41%;">
                    <p><b>]] .. "Name:" .. [[</b> ]] .. (firstname or 'Unknown') .." ".. (lastname or 'Unknown') ..[[</p>
                    <p><b>]] .. "Date of Birth:" .. [[</b> ]] .. (age or 'Unknown') .. [[</p>
                    <p><b>]] .. "Birth Place:" .. [[</b> ]] .. (place_of_birth or 'Unknown') .. [[</p>
                    <p><b>]] .. _U('Gender') .. [[</b> ]] .. (gender or 'Unknown') .. [[</p>
                    <p><b>]] .. "Occupation:" .. [[</b> ]] .. (job or 'Unknown') .. [[</p>
                    <p><div style="font-size: 10px; color: black;">]].."Expires "..(string.sub(expire_date,1,10))..[[</div></p>
                </div>
            ]]
        })
    else
        DocumentPageOpen:RegisterElement("html", {
            value = [[
                <div style="font-size: 20px; color: black;">]]..(Config.DocumentTypes[docType].displayName)..[[</div>
                <div style="font-size: 10px; color: black;">]].."Issued "..((string.sub(date,1,10)))..[[</div>
                <div style="position: absolute; width: 35%; margin-top: 4%; margin-left: 5%;border: 6px solid transparent; border: 6px solid #000; border-radius: 6px">
                <img width="256px" height="256px" style="margin: 0 auto;" src="]] .. (picture) .. [[" />
                </div>
                <div style="position: absolute;text-align: left; width: 50%;white-space: nowrap; overflow: hidden; padding: 1%; font-size: 25px; color: black;margin-top: 5%; margin-left: 41%;">
                    <p><b>]] .. "Name:" .. [[</b> ]] .. (firstname or 'Unknown') .." ".. (lastname or 'Unknown') ..[[</p>
                    <p><b>]] .. "Date of Birth:" .. [[</b> ]] .. (age or 'Unknown') .. [[</p>
                    <p><b>]] .. "Birth Place:" .. [[</b> ]] .. (place_of_birth or 'Unknown') .. [[</p>
                    <p><b>]] .. _U('Gender') .. [[</b> ]] .. (gender or 'Unknown') .. [[</p>
                    <p><b>]] .. "Occupation:" .. [[</b> ]] .. (job or 'Unknown') .. [[</p>
                    <p><div style="font-size: 10px; color: black;">]].."Expires "..(string.sub(expire_date,1,10))..[[</div></p>
                </div>
            ]]
        })
    end
    DocumentPageOpen:RegisterElement('line', {
    })
    DocumentPageOpen:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    DocumentPageOpen:RegisterElement('button', {
        label = _U('ShowDocument'),
        slot = 'footer',
        style = {}
    }, function()
        OpenShowToPlayerMenu(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    end)

    DocumentPageOpen:RegisterElement('button', {
        label = "Destroy Document",
        slot = 'footer',
        style = {}
    }, function()
        if docType and docType ~= '' then
            TriggerServerEvent('bcc-documents:server:revokeMyDocument', docType)
            --Wait(500) -- Small delay to ensure synchronization
            BCCDocumentsInspectMenu:Close({})
        else
            debugPrint("Error: docType is nil or empty")
        end
    end)

    DocumentPageOpen:RegisterElement('button', {
        label = _U('PutBack'),
        slot = 'footer',
        style = {}
    }, function()
        BCCDocumentsInspectMenu:Close({})
    end)

    DocumentPageOpen:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsInspectMenu:Open({
        startupPage = DocumentPageOpen
    })
end

function OpenShowToPlayerMenu(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    local players = GetNearbyPlayers()
    local playerMenu = BCCDocumentsMainMenu:RegisterPage("playerMenu")

    playerMenu:RegisterElement('header', {
        value = _U('ChoosePlayer'),
        slot = 'header'
    })

    if #players > 0 then
        for _, player in ipairs(players) do
            local roleplayName = buffy_playerNames[tostring(player.id)]
            if not roleplayName then roleplayName = "Unknown" end
            debugPrint("Nearby Player:", player.id, roleplayName)
            playerMenu:RegisterElement('button', {
                label = roleplayName,
                style = {}
            }, function()
                TriggerServerEvent('bcc-documents:server:showDocumentToPlayer', player.id, docType, firstname,
                    lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
                Wait(500) -- Small delay to ensure synchronization
                VORPcore.NotifyObjective("You show "..roleplayName.." your "..Config.DocumentTypes[docType].displayName, 4000)
            end)
        end
    else
        TextDisplay = playerMenu:RegisterElement('textdisplay', {
            value = _U('NoNearbyPlayer'),
            style = {
                color = 'red',
                ['text-align'] = 'center',
                ['margin-top'] = '10px'
            }
        })
    end

    playerMenu:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    playerMenu:RegisterElement('button', {
        label = _U('BackButton'),
        slot = 'footer',
        style = {}
    }, function()
        OpenDocument(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    end)

    playerMenu:RegisterElement('bottomline', {
        slot = 'footer',
        style = {}
    })

    BCCDocumentsMainMenu:Open({
        startupPage = playerMenu
    })
end

function GetNearbyPlayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyPlayers = {}

    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        --if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            if distance < 3.0 then
                table.insert(nearbyPlayers, { id = GetPlayerServerId(player), distance = distance })
                debugPrint("Found nearby player:", GetPlayerServerId(player))
            end
        --end
    end

    return nearbyPlayers
end

RegisterNetEvent('bcc-documents:opensubmenu')
AddEventHandler('bcc-documents:opensubmenu', function(docType)
    OpenDocumentSubMenu(docType)
end)

RegisterNetEvent('bcc-documents:client:opendocument')
AddEventHandler('bcc-documents:client:opendocument',
    function(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
        debugPrint("OpenDocument triggered with docType: " .. docType)
        OpenDocument(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    end)

RegisterNetEvent('bcc-documents:client:addexpiry')
AddEventHandler('bcc-documents:client:addexpiry', function(docType)
    AddExpiryDate(docType)
end)

RegisterNetEvent('bcc-documents:client:showdocument')
AddEventHandler('bcc-documents:client:showdocument',
    function(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
        ShowDocument(docType, firstname, lastname, nickname, job, age, gender, date, picture, expire_date, date_of_birth, place_of_birth, occupation)
    end)

RegisterNetEvent('bcc-documents:client:noDocument')
AddEventHandler('bcc-documents:client:noDocument', function()
    debugPrint("No document found for this type.")
end)

RegisterNetEvent('bcc-documents:client:createDocument')
AddEventHandler('bcc-documents:client:createDocument', function(docType)
    if docType then
        TriggerServerEvent('bcc-documents:server:createDocument', docType)
    else
        debugPrint("Error: docType is missing.")
    end
end)

RegisterNetEvent('bcc-documents:client:reissueDocument')
AddEventHandler('bcc-documents:client:reissueDocument', function(docType)
    if docType then
        TriggerServerEvent('bcc-documents:server:reissueDocument', docType)
    else
        debugPrint("Error: docType is missing.")
    end
end)

RegisterNetEvent('bcc-documents:client:revokeDocument')
AddEventHandler('bcc-documents:client:revokeDocument', function(docType)
    if docType then
        TriggerServerEvent('bcc-documents:server:revokeDocument', docType)
    else
        debugPrint("Error: docType is missing.")
    end
end)

RegisterNetEvent('bcc-documents:client:changephoto')
AddEventHandler('bcc-documents:client:changephoto', function(docType)
    ChangeDocumentPhoto(docType)
end)

RegisterNetEvent('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, npcs in ipairs(CreatedNpc) do
            npcs:Remove()
        end
        for _, blips in ipairs(CreatedBlip) do
            blips:Remove()
        end
    end
end)
