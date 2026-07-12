local function TableToString(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. TableToString(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
local function round(num, decimals)
    if type(num) ~= "number" then
        return num
    end

    local multiplier = 10 ^ (decimals or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end
FeatherMenu =  exports['feather-menu'].initiate()
local querydata = {}
RegisterCommand('additemmenu', function()
    local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
            -- ['height'] = '500px'
            -- ['border'] = '5px solid white',
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#515A5A'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true
    })

    local MyFirstPage = MyMenu:RegisterPage('first:page')

    ------ FIRST PAGE CONTENT  ------
    MyFirstPage:RegisterElement('header', {
        value = 'BuffyDB Item Creator',
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('subheader', {
        value = "Items submitted are available after the next restart",
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('line', {
        slot = "header",
    })
    MyFirstPage:RegisterElement('input', {
        label = "DB-friendly name",
        placeholder = "crop_daisy",
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function(data)
        querydata.name = data.value
    end)
    local dbnamewarning = MyFirstPage:RegisterElement('textdisplay', {
        value = "This MUST be all one word, using underscores instead of spaces.",
        style = {}
    })
    MyFirstPage:RegisterElement('input', {
        label = "Inventory Name",
        placeholder = "Daisy",
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function(data)
        querydata.label = data.value
    end)
    local invnamewarning = MyFirstPage:RegisterElement('textdisplay', {
        value = "What the player sees when hovering over the item in their inventory",
        style = {}
    })
    MyFirstPage:RegisterElement('textarea', {
        label = "Description",
        placeholder = "Optional",
        rows = "4",
        -- cols = "14",
        resize = false,
        -- persist = false,
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function(data)
        print("Input Triggered: ", data.value)
       querydata.description = data.value
    end)
    local weightwarning = MyFirstPage:RegisterElement('textdisplay', {
        value = "Description for the item in the player's inventory. Can be left blank.",
        style = {}
    })
    MyFirstPage:RegisterElement('slider', {
        label = "Carry Limit",
        start = 500,
        min = 1,
        max = 500,
        steps = 1
    }, function(data)
        querydata.carryLimit = data.value
    end)
    local carrylimitwarning = MyFirstPage:RegisterElement('textdisplay', {
        value = "Most items are 500 to enable players to basically carry unlimited",
        style = {}
    })
    MyFirstPage:RegisterElement('slider', {
        label = "Item Weight",
        start = 0.1,
        min = 0.1,
        max = 10,
        steps = 0.1
    }, function(data)
        querydata.weight = data.value
    end)
    local weightwarning = MyFirstPage:RegisterElement('textdisplay', {
        value = "How heavy the item is in the player's inventory",
        style = {}
    })
    MyFirstPage:RegisterElement('line', {
        slot = "content",
        style = {}
    })
    local statustext = MyFirstPage:RegisterElement('textdisplay', {
        value = " ",
        style = {}
    })
    MyFirstPage:RegisterElement('button', {
        label = "Submit",
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function()
        statustext:update({
            value = 'Submitted query. \n If there were no errors, you can expect changes to reflect next restart. \n This menu will close automatically after a few seconds.',
            style = {}
        })
        local function containsSpaces(str)
            return string.find(str, "%s") ~= nil
        end
        local function isInvalid(string)
            return string == nil or string == ''
        end
        if isInvalid(querydata.name) or isInvalid(querydata.name) or isInvalid(querydata.label) then
            statustext:update({
                value = 'You must fill out all fields.',
                style = {}})
            return
        elseif containsSpaces(querydata.name) then
            dbnamewarning:update({
                value = 'DO NOT USE SPACES IN THE FREAKING DB NAME!!!',
                style = {"color:red;"}})
            print('failed query')
            return
        end
        TriggerServerEvent('buffy_db:receiveitem', GetPlayerServerId(PlayerId()), querydata)
        Wait(5000)
        MyMenu:Close({
            sound = {
                 action = "SELECT",
                 soundset = "RDRO_Character_Creator_Sounds"}
        })
    end)
    MyFirstPage:RegisterElement('line', {
        slot = "content",
        style = {}
    })
    MyFirstPage:RegisterElement("html", {
        value = {
            [[
                <img width="100px" height="100px" style="margin: 0 auto;" src="https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg" />
                <div style="color:red;">
                    Please be careful with this menu. <br>You are modifying the production database. <br>Double, triple, quadruple check your inputs. -buffy
                </div>
            ]]
        }
    })


    MyFirstPage:RegisterElement('bottomline')

    MyFirstPage:RegisterElement('line', {
        slot = "footer",
    })

    MyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = MyFirstPage
    })
end)
local isAdmin = false
local dataList = {}
local characterList = {}
RegisterNetEvent("buffy_db:isadmin")
AddEventHandler("buffy_db:isadmin", function(check, data, characters)
	if check then
        isAdmin = true
        dataList = data
        characterList = characters
    end
end)
RegisterCommand('listitems', function()
    TriggerServerEvent('buffy_db:checkadmin', GetPlayerServerId(PlayerId()), 'items')
    Wait(5000)
    if not isAdmin then return end
    local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
            -- ['height'] = '500px'
            -- ['border'] = '5px solid white',
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#515A5A'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true
    })

    local MyFirstPage = MyMenu:RegisterPage('first:page')

    ------ FIRST PAGE CONTENT  ------
    MyFirstPage:RegisterElement('header', {
        value = 'BuffyDB Item List',
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('subheader', {
        value = "This is a list of all registered items in the database",
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('line', {
        slot = "header",
    })
    for k,v in pairs(dataList) do
        MyFirstPage:RegisterElement('button', {
            label = v.item,
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
        end)
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Label: '..v.label,
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Limit: '..v.limit,
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Weight: '..v.weight,
            style = {}
        })
        if v.desc ~= nil then
            MyFirstPage:RegisterElement('textdisplay', {
                value = 'Description: '..v.desc,
                style = {}
            })
        end
    end
    MyFirstPage:RegisterElement('line', {
        slot = "footer",
    })

    MyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = MyFirstPage
    })
end)
local showOnlyInWorld   = false
local showOnlyTPInts    = false
local nameFilter        = false
local showOnlyOwned     = false
local showOnlyForSale   = false
local function resetFilters()
    showOnlyInWorld   = false
    showOnlyTPInts    = false
    nameFilter        = false
    showOnlyOwned     = false
    showOnlyForSale   = false
end
RegisterCommand('housingmenu', function()
    TriggerServerEvent('buffy_db:checkadmin', GetPlayerServerId(PlayerId()), 'housing')
    Wait(5000)
    if not isAdmin then return end

    local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
            -- ['height'] = '500px'
            -- ['border'] = '5px solid white',
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#515A5A'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true
    })

    local MyFirstPage = MyMenu:RegisterPage('first:page')

    ------ FIRST PAGE CONTENT  ------
    MyFirstPage:RegisterElement('header', {
        value = 'BuffyDB Housing List',
        slot = "header",
        style = {}
    })
    local status = MyFirstPage:RegisterElement('subheader', {
        value = "Showing ALL houses in the database",
        slot = "header",
        style = {}
    })
    Wait(2000)
    if showOnlyInWorld then
        status:update({
            value = 'Showing In-World house types',
            style = {}})
    elseif showOnlyTPInts then
        status:update({
            value = 'Showing TP Interior house types',
            style = {}})
    elseif nameFilter then
        status:update({
            value = 'Showing houses matching query: '..nameFilter,
            style = {}})
    elseif showOnlyForSale then
        status:update({
            value = 'Showing houses that are for sale',
            style = {}})
    elseif showOnlyOwned then
        status:update({
            value = 'Showing houses that are owned by a player',
            style = {}})
    end
    MyFirstPage:RegisterElement('line', {
        slot = "header",
    })
    MyFirstPage:RegisterElement('dropdown', {
        label = 'Filter',
        value = 'Filter',
        placeholder = '',
        slot = "header",
        options = {
            { text = "Show Only In-World Properties", value = "inworld" },
            { text = "Show Only Teleport Properties", value = "tp"},
            { text = "Show Only Unowned Properties", value = "unowned"},
            { text = "Show Only Owned Properties", value = "owned"},
        },
        -- sound = {
        --     action = "SELECT",
        --     soundset = "RDRO_Character_Creator_Sounds"
        -- },
    }, function(data)
        -- This gets triggered whenever the dropdown selected value changes
            print(data.value)
            if data.value == 'inworld' then
                status:update({
                    value = 'Loading, please wait...',
                    style = {}})
                resetFilters()
                showOnlyInWorld = true
                Wait(2000)
                ExecuteCommand('housingmenu')
            elseif data.value == 'tp' then
                status:update({
                    value = 'Loading, please wait...',
                    style = {}})
                resetFilters()
                showOnlyTPInts  = true
                Wait(2000)
                ExecuteCommand('housingmenu')
            elseif data.value == 'unowned' then
                status:update({
                    value = 'Loading, please wait...',
                    style = {}})
                resetFilters()
                showOnlyForSale   = true

                Wait(2000)
                ExecuteCommand('housingmenu')
            elseif data.value == 'owned' then
                status:update({
                    value = 'Loading, please wait...',
                    style = {}})
                resetFilters()
                showOnlyOwned     = true
                Wait(2000)
                ExecuteCommand('housingmenu')
            end
    end)
    MyFirstPage:RegisterElement('input', {
        label = "Name Filter: ",
        slot = 'header',
        placeholder = "",
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function(data)
        nameFilter = data.value
        print(nameFilter)
    end)
    MyFirstPage:RegisterElement('button', {
        label = 'Search',
        slot = 'header',
        style = {
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#E8E8E8',
            -- ['color'] = 'black',
            -- ['border-radius'] = '6px'
        }
    }, function()
        if not nameFilter then
            print('no name specified')
            return
        end
        status:update({
            value = 'Searching, please wait...',
            style = {}})
        showOnlyTPInts  = false
        showOnlyInWorld = false
        showOnlyOwned   = false
        showOnlyForSale = false
        Wait(2000)
        ExecuteCommand('housingmenu')
    end)
    if showOnlyTPInts or showOnlyInWorld or nameFilter then
        MyFirstPage:RegisterElement('button', {
            label = 'Reset Filters',
            slot = 'header',
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            status:update({
                value = 'Loading, please wait...',
                style = {}})
            showOnlyTPInts  = false
            showOnlyInWorld = false
            nameFilter      = false
            showOnlyOwned   = false
            showOnlyForSale = false
            Wait(2000)
            ExecuteCommand('housingmenu')
        end)
    end
    --start addpropertydata function
    local function addPropertyData(v)
        local primarydoor = json.decode(v.primarydoor)
        local x,y,z
        MyFirstPage:RegisterElement('button', {
            label = 'ID: '..v.id,
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            SetEntityCoordsNoOffset(PlayerPedId(), x,y,z)
        end)
        local owner = 'For Sale'
        for k,character in pairs(characterList) do
            if v.buyercharidentifier == character.charidentifier and character.firstname ~= nil then
                owner = 'Owned by '..character.firstname..' '..character.lastname
            end
        end
        MyFirstPage:RegisterElement('textdisplay', {
            value = owner,
            style = {}
        })
        for _,coordinate in pairs(primarydoor) do
            if coordinate.x ~= nil then
                x = coordinate.x
            end
            if coordinate.y ~= nil then
                y = coordinate.y
            end
            if coordinate.z ~= nil then
                z = coordinate.z
            end
        end
        local houseType = ''
        if v.type == 0 then
            houseType = 'In-World Door'
        elseif v.type == 3 then
            houseType = 'No Door House'
        else
            houseType = 'Teleport Interior'
            if v.otherdoors ~= '[]' then
                MyFirstPage:RegisterElement('textdisplay', {
                    value = v.otherdoors,
                    style = {}
                })
            end
        end
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Type of House: '..houseType,
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Location: '..round(x,2)..', '..round(y,2)..', '..round(z,2),
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Furniture Range: '..v.range..' meters',
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Normal Ledger Balance: '..v.ledger..' dollars.',
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Tax Ledger Balance: '..v.taxledger..' / '..v.tax..' dollars paid.',
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Tax Rate: '..v.tax,
            style = {}
        })
        
        local repostatus = v.repoed
        local repostyle = {}
        if repostatus == 0 then
            repostatus = 'In good standing'
        else
            repostatus = 'REPOSESSED!'
            repostyle = {"color:red;"}
        end
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Tax Status: '..repostatus,
            style = repostyle
        })
    end
    --end addpropertydata function

    MyFirstPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })
    for k,v in pairs(dataList) do
        if showOnlyInWorld then
            if v.type ~= 4 then
                addPropertyData(v)
                Wait(0)
            end
        elseif showOnlyTPInts then
            if v.type == 4 then
                addPropertyData(v)
                Wait(0)
            end
        elseif nameFilter then
            for _,character in pairs(characterList) do
                if string.find(character.firstname, nameFilter) or string.find(character.lastname, nameFilter) then
                    if v.buyercharidentifier == character.charidentifier then
                        addPropertyData(v)
                        Wait(0)
                        break
                    end
                end
            end
        elseif showOnlyOwned then
            if v.buyercharidentifier ~= 0 then
                addPropertyData(v)
                Wait(0)
            end
        elseif showOnlyForSale then
            if v.buyercharidentifier == 0 then
                addPropertyData(v)
                Wait(0)
            end
        elseif not showOnlyInWorld and not showOnlyTPInts and not nameFilter and not showOnlyOwned and not showOnlyForSale then
            addPropertyData(v)
            Wait(0)
        end
    end

    MyFirstPage:RegisterElement('line', {
        slot = 'footer',
    })

    MyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = MyFirstPage
    })
end)

RegisterCommand('clanmenu', function()
    TriggerServerEvent('buffy_db:checkadmin', GetPlayerServerId(PlayerId()), 'clan')
    Wait(5000)
    if not isAdmin then return end

    local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
            -- ['height'] = '500px'
            -- ['border'] = '5px solid white',
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#515A5A'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true
    })

    local MyFirstPage = MyMenu:RegisterPage('first:page')

    ------ FIRST PAGE CONTENT  ------
    MyFirstPage:RegisterElement('header', {
        value = 'BuffyDB Clan List',
        slot = "header",
        style = {}
    })
    local status = MyFirstPage:RegisterElement('subheader', {
        value = "Showing ALL clans in the database",
        slot = "header",
        style = {}
    })
--[[
{"lifecycle":0,"coords":{"x":-1606.80322265625,"y":-399.1721496582031,"z":179.5616912841797},"furni":[{"coords":{"x":-1606.80322265625,"y":-399.1721496582031,"z":179.5616912841797},"active":true,"functional":"none","grounded":true,"label":"flag","heading":0.0,"item":"flag","id":1,"cata":"prop","prop":-229587575}],"supply":0,"maxstock":0,"name":"Snowdrop","members":[{"name":"Eleanor (twilight)","charid":180}],"discord":"","material":0,"leader":180,"bcolor":1,"raid":0,"stock":0,"stewlevel":0,"hwagon":0}


]]

    --start addClanData function
    local function addClanData(v)
        local clan = json.decode(v.info)
        local x,y,z = 0,0,0
        local leaderID = clan.leader
        local clanName = clan['name'] or ''
        --print(clan['coords']['x'])
        if clan['coords'].x ~= nil then
            x = round(clan['coords'].x, 3)
        end
        if clan['coords'].y ~= nil then
            y = round(clan['coords'].y, 3)
        end
        if clan['coords'].z ~= nil then
            z = round(clan['coords'].z, 3)
        end
        for _,info in pairs(clan) do
            
            --[[
            for _,coord in pairs(info) do

            end
            
            if info.leader ~= nil then
                leaderID = info.leader
            end
            if info.name ~= nil then
                clanName = info.name
            end

            --]]
        end
        MyFirstPage:RegisterElement('button', {
            label = clanName,
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            SetEntityCoordsNoOffset(PlayerPedId(), x,y,z)
        end)

        MyFirstPage:RegisterElement('textdisplay', {
            value = 'ID: '..v.id,
            style = {}
        })

        MyFirstPage:RegisterElement('textdisplay', {
            value = x..', '..y..', '..z,
            style = {}
        })

        local owner = 'No Leader'
        for k,character in pairs(characterList) do
            if leaderID == character.charidentifier and character.firstname ~= nil then
                owner = 'Led by '..character.firstname..' '..character.lastname
            end
        end
        MyFirstPage:RegisterElement('textdisplay', {
            value = owner,
            style = {}
        })

        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Stock: '..(clan.stock or 0),
            style = {}
        })

        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Supply: '..(clan.supply or 0),
            style = {}
        })

        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Materials: '..(clan.material or 0),
            style = {}
        })
        if clan.members then
            MyFirstPage:RegisterElement('line', {
                slot = "content",
            })
            MyFirstPage:RegisterElement('textdisplay', {
                value = 'Member List',
                style = {}
            })
            for _,member in pairs(clan.members) do
                MyFirstPage:RegisterElement('textdisplay', {
                    value = member.name,
                    style = {}
                })
            end
            MyFirstPage:RegisterElement('line', {
                slot = "content",
            })
        end
        local repostatus = v.repo
        local repostyle = {}
        if repostatus == 0 then
            repostatus = 'In good standing'
        else
            repostatus = 'REPOSESSED!'
            repostyle = {"color:red;"}
        end
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'Tax Status: '..repostatus,
            style = repostyle
        })
        if repostatus == 'REPOSESSED!' then
            MyFirstPage:RegisterElement("html", {
                value = {
                    [[
                        <div >
                            Use the clanunrepo command found in the syn_clan config<br>with the ID listed above to restore this camp.<br>
                        </div>
                    ]]
                },
            })
        end

        MyFirstPage:RegisterElement("html", {
            value = {
                [[
                    <div >
                        <br> <br>
                    </div>
                ]]
            },
        })
    end
    --end addClanData function
    if nameFilter then
        status:update({
            value = 'Showing clans matching query: '..nameFilter,
            style = {}})
    end
    MyFirstPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })
    for k,v in pairs(dataList) do
        addClanData(v)
        Wait(0)
    end

    MyFirstPage:RegisterElement('line', {
        slot = 'footer',
    })

    MyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = MyFirstPage
    })
end)


RegisterCommand('buffydb', function()
    TriggerServerEvent('buffy_db:checkadmin', GetPlayerServerId(PlayerId()), 'housing')
    Wait(5000)
    if not isAdmin then return end
    local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
            -- ['height'] = '500px'
            -- ['border'] = '5px solid white',
            -- ['background-image'] = 'none',
            -- ['background-color'] = '#515A5A'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true
    })

    local MyFirstPage = MyMenu:RegisterPage('first:page')

    ------ FIRST PAGE CONTENT  ------
    MyFirstPage:RegisterElement('header', {
        value = 'BuffyDB',
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('subheader', {
        value = "Select a menu",
        slot = "header",
        style = {}
    })
    local status = MyFirstPage:RegisterElement('textdisplay', {
        value = '',
        style = {}
    })
    MyFirstPage:RegisterElement('line', {
        slot = "header",
    })
    if Config.additemmenu then
        MyFirstPage:RegisterElement('button', {
            label = 'Add Item Menu',
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            status:update({
                value = 'Loading, please wait...',
                style = {}})
            ExecuteCommand('additemmenu')
        end)
    end
    if Config.listitems then
        MyFirstPage:RegisterElement('button', {
            label = 'List of all DB Items',
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            status:update({
                value = 'Loading, please wait...',
                style = {}})
            ExecuteCommand('listitems')
        end)
    end
    if Config.housingmenu then
        MyFirstPage:RegisterElement('button', {
            label = 'Housing Menu',
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            status:update({
                value = 'Loading, please wait...',
                style = {}})
            ExecuteCommand('housingmenu')
        end)
    end
    if Config.clanmenu then
        MyFirstPage:RegisterElement('button', {
            label = 'Clan Menu',
            style = {
                -- ['background-image'] = 'none',
                -- ['background-color'] = '#E8E8E8',
                -- ['color'] = 'black',
                -- ['border-radius'] = '6px'
            }
        }, function()
            status:update({
                value = 'Loading, please wait...',
                style = {}})
            ExecuteCommand('clanmenu')
        end)
    end
    local disabled = ''
    if not Config.housingmenu then
        disabled = disabled..' [housing menu] '
    end
    if not Config.listitems then
        disabled = disabled..' [list items] '
    end
    if not Config.additemmenu then
        disabled = disabled..' [add item menu] '
    end
    if not Config.clanmenu then
        disabled = disabled..' [clan menu] '
    end
    if not Config.housingmenu or not Config.listitems or not Config.additemmenu or not Config.clanmenu then
        MyFirstPage:RegisterElement('textdisplay', {
            value = 'The following menus are disabled in config.lua:',
            style = {}
        })
        MyFirstPage:RegisterElement('textdisplay', {
            value = disabled,
            style = {}
        })
    end
    MyFirstPage:RegisterElement('line', {
        slot = "footer",
    })

    MyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = MyFirstPage
    })
end)
