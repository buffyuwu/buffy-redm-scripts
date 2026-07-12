Config = {
    -- Default Settings
    devMode = false,
    PlayYear = "1885",
    -- Language settings
    defaultlang = "en_lang",    -- Set Your Language (Current Languages: "en_lang" English, "ro_lang" Romanian)
    -- Command Settings
    AdminJob = "admin",         -- allow Admin-Jobs to give unbuyable licenses
    NeedItem = true,            -- Set true or false, if you want to need an item zu execute the commands
    NeedItemName = "paper",    -- define the item-name set in db
    -- NPC and Blip settings
    DocumentBlips = true,
    DocumentNPC = true,
    DocumentLocations = {
        {
            coords = vector3(-175.29, 631.92, 114.09),
            NpcHeading = 326.82,
        },
        {
            coords = vector3(-798.53, -1194.58, 43.95),
            NpcHeading = 190.82,
        },
        {
            coords = vector3(1230.19, -1298.7, 76.9),
            NpcHeading = 230.74,
        },
        {
            coords = vector3(2747.9, -1396.45, 46.18),
            NpcHeading = 31.65,
        },
        {
            coords = vector3(2933.1, 1282.69, 44.65),
            NpcHeading = 74.53,
        },
    },
    UpdateRecordPrice = 1,
    -- Document types with associated details
    DocumentTypes = {
        idcard = {
            displayName = "State ID",
            price = 5,
            reissuePrice = 5,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 10,
            expiryDays = 365,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        barlicense = {
            displayName = "Bar License",
            price = 120,
            reissuePrice = 120,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 10,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        bountlicense = {
            displayName = "Bounty License",
            price = 200,
            reissuePrice = 200,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        brewlicense = {
            displayName = "Brewing License",
            price = 200,
            reissuePrice = 200,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 60,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        carrylicense = {
            displayName = "Carry Permit",
            price = 200,
            reissuePrice = 200,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 60,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        gamlicense = {
            displayName = "Gambling Permit",
            price = 200,
            reissuePrice = 200,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 60,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        liqlicense = {
            displayName = "Liquor License",
            price = 300,
            reissuePrice = 300,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        lumlicense = {
            displayName = "Lumber Permit",
            price = 60,
            reissuePrice = 60,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 4,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        medlicense = {
            displayName = "Medical License",
            price = 120,
            reissuePrice = 120,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        milicense = {
            displayName = "Prospecting License",
            price = 120,
            reissuePrice = 120,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 10,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        prlicense = {
            displayName = "Prostitution License",
            price = 60,
            reissuePrice = 60,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 10,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        rwlicense = {
            displayName = "Railway License",
            price = 300,
            reissuePrice = 300,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 30,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },

        rblicense = {
            displayName = "Riverboat Permit",
            price = 60,
            reissuePrice = 60,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 10,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },

        sclicense = {
            displayName = "Stagecoach License",
            price = 120,
            reissuePrice = 120,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 20,
            expiryDays = 10,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },
        trlicense = {
            displayName = "Travel Permit",
            price = 20,
            reissuePrice = 20,
            changePhotoPrice = 0, -- leave this to zero because sometimes image URLs dont work or look bad ingame -buffy
            extendPrice = 10,
            expiryDays = 10,  -- Set expiry duration by default
            defaultPicture = '',
            sellNpc = true,
            givenCommand = false,
            allowJob = "",
        },

    },
    
    Textures = {
        ['cross'] = { "scoretimer_textures", "scoretimer_generic_cross" },
        ['locked'] = { "menu_textures", "stamp_locked_rank" },
        ['tick'] = { "scoretimer_textures", "scoretimer_generic_tick" },
        ['money'] = { "inventory_items", "money_moneystack" },
        ['alert'] = { "menu_textures", "menu_icon_alert" },
    }
}
