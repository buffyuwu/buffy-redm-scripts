function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xAAB86462966168CE, ped, true) -- UNKNOWN "Fixes outfit"- always paired with _UPDATE_PED_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end

function SetMetaPedTag(ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
    Citizen.InvokeNative(0xBC6DF00D7A4A6819, ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
end


RegisterNetEvent("hair") 
AddEventHandler("hair", function()
    local playerPed = PlayerPedId()
    if IsPedMale(playerPed) then return end
	Citizen.InvokeNative(0xDF631E4BCE1B1FC4, playerPed, 0x9925C067, true, true, true)
    OpenHairMenu1()
end)

RegisterNetEvent("hair2") 
AddEventHandler("hair2", function()
    local playerPed = PlayerPedId()
    if IsPedMale(playerPed) then
	Citizen.InvokeNative(0xDF631E4BCE1B1FC4, playerPed, 0x9925C067, true, true, true)
    OpenHairMenu2()
	else return end
end)




function OpenHairMenu1()
    local playerPed = PlayerPedId()
    local hairIndex = 1
    local color1 = 0
    local color2 = 0
    local color3 = 0
    local currentHairItem = nil

    local menu = jo.menu.create('menu1', {
        title = 'Hair',
        subtitle = 'Choose Hair and Color',
        onEnter = function(currentData)
            print('Enter in menu ' .. currentData.menu)
        end,
        onBack = function(currentData)
            jo.menu.show(false)
            inmenu = false
        end,
    })
        menu:addItem({
        title = "Hair",
        sliders = {
            {
                type = "switch",
                current = 1,
                values = {
                                        { label = "Hair 1", data = `cs_marybeth_fs1_hair_002` }, 
                                        { label = "Hair 2", data = `cs_mp_grace_lancing_fs1_hair_000` }, 
					{ label = "Hair 3", data = `hair_fr1_027_alt01` }, 
					{ label = "Hair 4", data = `hair_fr1_027_dishevelled` }, 
					{ label = "Hair 5", data = `hair_fr1_035` }, 
					{ label = "Hair 6", data = `vcpggdba_0xecc9e71a` }, 
					{ label = "Hair 7", data = `hair_fr1_035_dishevelled` }, 
					{ label = "Hair 8", data = `hair_fr1_036` }, 
					{ label = "Hair 9", data = `yaushyqa_0xae7c9e78` }, 
					{ label = "Hair 10", data = `hair_fr1_041` }, 
					{ label = "Hair 11", data = `qxozbvca_0xaddbcbe2` }, 
					{ label = "Hair 12", data = `vnakssra_0x9e1b530f` }, 
					{ label = "Hair 13", data = `cs_edithdown_fs1_hair_001` }, 
					{ label = "Hair 14", data = `cs_meredith_fs1_hair_000` }, 
					{ label = "Hair 15", data = `hair_fr1_056` }, 
					{ label = "Hair 16", data = `fvvmlybb_0xda9742b5` }, 
					{ label = "Hair 17", data = `hair_fr1_033_alt04` }, 
					{ label = "Hair 18", data = `hair_fr1_033_dishevelled` }, 
					{ label = "Hair 19", data = `cs_mollyoshea_fs1_hair_000` }, 
					{ label = "Hair 20", data = `cs_mp_maggie_fs1_hair_000` }, 
					{ label = "Hair 21", data = `hair_fr1_037` }, 
					{ label = "Hair 22", data = `jlvqhhea_0xc008bedd` }, 
					{ label = "Hair 23", data = `hbfnkscb_0x28d95920` }, 
					{ label = "Hair 24", data = `ejfogkha_0x0ed90b26` }, 
					{ label = "Hair 25", data = `oedtgpjb_0xcad12dad` }, 
					{ label = "Hair 26", data = `cs_mp_maggie_fs1_hair_001` }, 
					{ label = "Hair 27", data = `cs_marybeth_fs1_hair_004` }, 
					{ label = "Hair 28", data = `tzctlpia_0x5312e2c4` }, 
					{ label = "Hair 29", data = `hair_fr1_057` }, 
					{ label = "Hair 30", data = `hair_fr1_057_dishevelled` }, 
					{ label = "Hair 31", data = `eotjbbya_0xdfa3c08f` }, 
					{ label = "Hair 32", data = `hair_fr1_024` }, 
					{ label = "Hair 33", data = `hair_fr1_051_dishevelled` }, 
					{ label = "Hair 34", data = `hair_fr1_048` },
					{ label = "Hair 35", data = `hair_fr1_048_dishevelled` }, 
					{ label = "Hair 36", data = `cs_mp_allison_fs1_hair_000` }, 
					{ label = "Hair 37", data = `cs_mp_bonnie_fs1_hair_000` }, 
					{ label = "Hair 38", data = `dpxbeyqa_0x945d8a8a` }, 
					{ label = "Hair 39", data = `hair_fr1_045` }, 
					{ label = "Hair 40", data = `hair_fr1_045_dishevelled` },
					{ label = "Hair 41", data = `santxkeb_0xf19ebe63` }, 
					{ label = "Hair 42", data = `hair_fr1_050` }, 
					{ label = "Hair 43", data = `wsrhggja_0x8c09c397` }, 
					{ label = "Hair 44", data = `tqceskga_0xa7b9dcfb` }, 
					{ label = "Hair 45", data = `cs_mp_harriet_davenport_fs1_hair_000` }, 
					{ label = "Hair 46", data = `hair_fr1_029` }, 
					{ label = "Hair 47", data = `hair_fr1_054_dishevelled` }, 
					{ label = "Hair 48", data = `cs_marybeth_fs1_hair_003` }, 
					{ label = "Hair 49", data = `bazvbkza_0xb47e565a` }, 
					{ label = "Hair 50", data = `cs_mrsadler_fs1_hair_005` },
					{ label = "Hair 51", data = `hair_fr1_026` }, 
					{ label = "Hair 52", data = `u_f_m_ambiguousped_01_hair` }, 
					{ label = "Hair 53", data = `hair_fr1_055` }, 
					{ label = "Hair 54", data = `hair_fr1_055_dishevelled` }, 
					{ label = "Hair 55", data = `cs_mp_travelling_saleswoman_fs1_hair_000` }, 
					{ label = "Hair 56", data = `klswvbjb_0x024d3d79` }, 
					{ label = "Hair 57", data = `esbazaba_0x0ec21e1b` }, 
					{ label = "Hair 58", data = `evieuiwa_0x51dc7ee5` }, 
					{ label = "Hair 59", data = `hair_fr1_047` }, 
					{ label = "Hair 60", data = `odfmibja_0x5673ee64` }, 
					{ label = "Hair 61", data = `rdnqgjha_0x40601c9e` }, 
					{ label = "Hair 62", data = `xgpgcgda_0x6f5a79d7` }, 
					{ label = "Hair 63", data = `zedgeyga_0x8a7385e5` }, 
					{ label = "Hair 64", data = `wzuphkda_0xc27e53f9` },
					{ label = "Hair 65", data = `hair_fr1_049_dishevelled` }, 
					{ label = "Hair 66", data = `fjtsfzpa_0xb536cf35` }, 
					{ label = "Hair 67", data = `rwkkhvab_0x9d2d45b8` },
					{ label = "Hair 68", data = `yxwkinea_0x47138d7a` }, 
					{ label = "Hair 69", data = `xzwmocla_0xcc63897b` }, 
					{ label = "Hair 70", data = `hair_fr1_032_alt01` }, 
					{ label = "Hair 71", data = `cs_fire_dancer_fs1_hair_000` }, 
					{ label = "Hair 72", data = `hair_fr1_028` }, 
					{ label = "Hair 73", data = `oisnleza_0x14aeec7e` }, 
                }
            }
        },
                onChange = function(currentData)
            currentHairItem = currentData.item.sliders[1].values[currentData.item.sliders[1].current].data
            SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_generic`, color1, color2, color3)
            UpdatePedVariation(playerPed)
        end
    })

    menu:addItem({
        title = "Main Color",
        sliders = {{type = "palette", title = "Color 1", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color1 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })

    menu:addItem({
        title = "Second Color",
        sliders = {{type = "palette", title = "Color 2", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color2 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })

    menu:addItem({
        title = "Three Color",
        sliders = {{type = "palette", title = "Color 3", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color3 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })
    menu:addItem({
        title = "Apply",
        onClick = function(currentData)
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
            jo.menu.show(false)
            inmenu = false
        end,
    })

    menu:send()
    jo.menu.setCurrentMenu('menu1')
    jo.menu.show(true)
    inmenu = true
end

function OpenHairMenu2()
    local playerPed = PlayerPedId()
    local hairIndex = 1
    local color1 = 0
    local color2 = 0
    local color3 = 0
    local currentHairItem = nil -- Добавим переменную для хранения текущего выбранного элемента прически

    local menu = jo.menu.create('menu1', {
        title = 'Hair',
        subtitle = 'Choose Hair and Color',
        onEnter = function(currentData)
            print('Enter in menu ' .. currentData.menu)
        end,
        onBack = function(currentData)
            jo.menu.show(false)
            inmenu = false
        end,
    })

        menu:addItem({
        title = "Hair",
        sliders = {
            {
                type = "switch",
                current = 1,
                values = {
                   { label = "Hair 1", data = `tkdedyha_0x10939c3d` }, 
					{ label = "Hair 2", data = `mp_hair_mr1_019_pomade` }, 
					{ label = "Hair 3", data = `mp_clay_ms1_hair_000` }, 
					{ label = "Hair 4", data = `hqrkiaha_0x54409754` }, 
					{ label = "Hair 5", data = `hair_mr1_045` }, 
					{ label = "Hair 6", data = `hair_mr1_027` }, 
					{ label = "Hair 7", data = `znnadcfb_0x004b9a0a` },
                                        { label = "Hair 8", data = `amdkqtgb_0x7c12f653` },					
					{ label = "Hair 9", data = `ttlwdydb_0xa60b7aab` }, 
					{ label = "Hair 10", data = `tdjdasna_0xcb5caf58` },
					{ label = "Hair 11", data = `cs_nbxexecuted_ms1_hair_001` }, 
					{ label = "Hair 12", data = `cs_mp_lem_ms1_hair_000` }, 					
					{ label = "Hair 13", data = `player_zero_hair_s06_l07_p0` }, 
					{ label = "Hair 14", data = `onqjrrjb_0x9674687e` }, 
					{ label = "Hair 15", data = `omcyglra_0x6834d356` }, 
					{ label = "Hair 16", data = `nuvbfema_0xfe7c82fd` },
					{ label = "Hair 17", data = `jtrenyna_0x81c39c27` }, 					
					{ label = "Hair 18", data = `nbilxmsa_0x74afb90e` },  
					{ label = "Hair 19", data = `hair_mr1_085` }, 
					{ label = "Hair 20", data = `hair_mr1_011` }, 
					{ label = "Hair 21", data = `drmipjma_0x985a4b43` }, 
					{ label = "Hair 22", data = `bmhlsloa_0x40613086` }, 
					{ label = "Hair 23", data = `vargbuga_0x7363c32b` },  
					{ label = "Hair 24", data = `usmstsua_0xb930fcc0` }, 
                                        { label = "Hair 25", data = `slnqwjaa_0xf06fa6ca` }, 
                                        { label = "Hair 26", data = `seestdwa_0x5c6e677a` }, 
                                        { label = "Hair 27", data = `nkxxmhna_0x3c6d8814` }, 
					{ label = "Hair 28", data = `kdsftnca_0x9cf6b00d` },
					{ label = "Hair 29", data = `hair_mr1_071` },
					{ label = "Hair 30", data = `hair_mr1_066` }, 
					{ label = "Hair 31", data = `hair_mr1_060` }, 
					{ label = "Hair 32", data = `hair_mr1_042` }, 
					{ label = "Hair 33", data = `jnvssrma_0x39421200` }, 
					{ label = "Hair 34", data = `hkwwfddb_0x7fa80e55` }, 
					{ label = "Hair 35", data = `hair_mr1_065` }, 
					{ label = "Hair 36", data = `hair_mr1_057` }, 
					{ label = "Hair 37", data = `zjcqtyda_0x0eae8025` },
					{ label = "Hair 38", data = `hair_mr1_016` },
					{ label = "Hair 39", data = `evkbofba_0xe9498d88` },
					{ label = "Hair 40", data = `czhurrla_0x0a878726` }, 					
					{ label = "Hair 41", data = `hair_mr1_059` }, 
					{ label = "Hair 42", data = `rggwunea_0x8483d0e2` }, 
					{ label = "Hair 43", data = `hair_mr1_046` }, 
					{ label = "Hair 44", data = `hair_mr1_010` }, 
					{ label = "Hair 45", data = `detotnba_0x32925339` }, 
					{ label = "Hair 46", data = `xaegjbta_0x0052f95f` }, 
					{ label = "Hair 47", data = `hair_mr1_047` }, 
					{ label = "Hair 48", data = `xmtijspb_0x109349e1` }, 
					{ label = "Hair 49", data = `ifnsdoda_0xcaaba19e` }, 
					{ label = "Hair 50", data = `rvihqubb_0xac29e3d5` }, 
					{ label = "Hair 51", data = `rnsgkgca_0x07fbd150` },
					{ label = "Hair 52", data = `hair_mr1_043` },					
					{ label = "Hair 53", data = `hair_mr1_069` }, 
 					{ label = "Hair 54", data = `hair_mr1_036` },
					{ label = "Hair 55", data = `hair_mr1_037` }, 
					{ label = "Hair 56", data = `dllgdnna_0x7daf1c6e` }, 
					{ label = "Hair 57", data = `bnblfyea_0x583fa080` }, 
					{ label = "Hair 58", data = `ndhlqfea_0xe3e7d4d2` }, 
					{ label = "Hair 59", data = `hair_mr1_044` }, 
					{ label = "Hair 60", data = `lkpbvhfa_0xa6e89829` }, 
					{ label = "Hair 61", data = `zopltnpa_0xceef52f7` }, 
					{ label = "Hair 62", data = `hair_mr1_030` },
					{ label = "Hair 63", data = `hair_mr1_030_dishevel` }, 					
					{ label = "Hair 64", data = `hair_mr1_020` }, 
					{ label = "Hair 65", data = `qsrhreia_0x4588e4a5` }, 
					{ label = "Hair 66", data = `hair_mr1_018` }, 
					{ label = "Hair 67", data = `eizwogka_0x914af12a` }, 
					{ label = "Hair 68", data = `afbljuca_0x7e6f6250` }, 
					{ label = "Hair 69", data = `pummkksa_0xbadd485c` },
					{ label = "Hair 70", data = `cs_mp_the_boy_ms1_hair_000` },					
					{ label = "Hair 71", data = `hair_mr1_074` }, 
					{ label = "Hair 72", data = `hair_mr1_031` }, 
					{ label = "Hair 73", data = `hair_mr1_012` }, 
					{ label = "Hair 74", data = `cs_vampire_ms1_hair_000_012` }, 
					{ label = "Hair 75", data = `cs_mp_camp_cook_ms1_hair_000` }, 
					{ label = "Hair 76", data = `imimfaaa_0x84b72c49` }, 
					{ label = "Hair 77", data = `hair_mr1_061` }, 
					{ label = "Hair 78", data = `hair_mr1_056` }, 
					{ label = "Hair 79", data = `pgjsavbb_0x2e199d9b` },
					{ label = "Hair 80", data = `elhkbfsa_0x885d8a61` },					
					{ label = "Hair 81", data = `hair_mr1_032` }, 
					{ label = "Hair 82", data = `mp_hair_mr1_007_tuck` }, 
					{ label = "Hair 83", data = `mp_hair_mr1_007_pomade_stiff` }, 
					{ label = "Hair 84", data = `hair_mr1_024` }, 
					{ label = "Hair 85", data = `cyvfesaa_0x4b09e9d5` },
					{ label = "Hair 86", data = `hair_mr1_073` }, 
					{ label = "Hair 87", data = `hair_mr1_023` }, 
					{ label = "Hair 88", data = `cs_kieran_ms1_hair_000` }, 
					{ label = "Hair 89", data = `ignegvda_0x9b64e6e9` }, 
					{ label = "Hair 90", data = `hair_mr1_017` },
					{ label = "Hair 91", data = `cs_johnmarston_ms1_hair_000` }, 					
					{ label = "Hair 92", data = `cs_mp_cliff_ms1_hair_000` }, 
					{ label = "Hair 93", data = `cs_johnweathers_ms1_hair_000` }, 
					{ label = "Hair 94", data = `hair_mr1_041` }, 
					{ label = "Hair 95", data = `hair_mr1_039` }, 
				        { label = "Hair 96", data = `zuqviwrb_0xccfaef7b` }, 
					{ label = "Hair 97", data = `hair_mr1_086` }, 
					{ label = "Hair 98", data = `hair_mr1_034` }, 
					{ label = "Hair 99", data = `player_zero_hair_s02_l08_p0` }, 
					{ label = "Hair 100", data = `hair_mr1_029` }, 
					{ label = "Hair 101", data = `cs_vampire_ms1_hair_000` }, 
					{ label = "Hair 102", data = `cs_mp_jorge_montez_ms1_hair_000` }, 
					{ label = "Hair 103", data = `player_zero_hair_s04_l08_p0` }, 
					{ label = "Hair 104", data = `mp_hair_mr1_018` }, 
					{ label = "Hair 105", data = `mp_hair_mr1_010_tuck` }, 
					{ label = "Hair 106", data = `xinnjqkb_0xd9b9c5f7` }, 
					{ label = "Hair 107", data = `sljoiika_0x7dd0c407` }, 
					{ label = "Hair 108", data = `tlmvxuia_0x630433f0` }, 
					{ label = "Hair 109", data = `hair_mr1_033` }, 
					{ label = "Hair 110", data = `jtpsxtfa_0x87c944c4` }, 
					{ label = "Hair 111", data = `hair_mr1_079` }, 
					{ label = "Hair 112", data = `hair_mr1_077` }, 
					{ label = "Hair 113", data = `hair_mr1_093` },
					{ label = "Hair 114", data = `mp_hair_mr1_lbt_009` }, 					
					{ label = "Hair 115", data = `hair_mr1_091` }, 
					{ label = "Hair 116", data = `cs_mp_lee_ms1_hair_000` }, 
					{ label = "Hair 117", data = `cs_charlessmith_ms1_hair_004` }, 
					{ label = "Hair 118", data = `cs_charlessmith_ms1_hair_002` }, 
					{ label = "Hair 119", data = `hair_mr1_078` }, 
					{ label = "Hair 120", data = `hair_mr1_040` }, 
					{ label = "Hair 121", data = `cs_charlessmith_ms1_hair_000` }, 
					{ label = "Hair 122", data = `hair_mr1_081` }, 
					{ label = "Hair 123", data = `azdqjoja_0x07755aaf` }, 
					{ label = "Hair 124", data = `uyxiiwfa_0x14a703c0` }, 
					{ label = "Hair 125", data = `tzsotvja_0xb8f27f1f` }, 
					{ label = "Hair 126", data = `hair_mr1_080` }, 
					{ label = "Hair 127", data = `ftolfyaa_0x5039b968` }, 
					{ label = "Hair 129", data = `ywnhbhna_0x3cc1ec21` }, 
					{ label = "Hair 129", data = `yiutdqaa_0x856e3d33` }, 
					{ label = "Hair 130", data = `wdgrfqja_0x9731ba7c` }, 
					{ label = "Hair 131", data = `uipfpxha_0x9cebd033` }, 
					{ label = "Hair 132", data = `qfqumbsa_0x0f6bc0bc` }, 
					{ label = "Hair 133", data = `pgcxqoma_0x90b78310` }, 
					{ label = "Hair 134", data = `hair_mr1_064` }, 
					{ label = "Hair 135", data = `hair_mr1_063` }, 
					{ label = "Hair 136", data = `gtfywofa_0x85749702` }, 
					{ label = "Hair 137", data = `dnappqja_0x64e06857` }, 
					{ label = "Hair 138", data = `cs_mrpearson_ms1_hair_000` }, 
                }
            }
        },
                onChange = function(currentData)
            currentHairItem = currentData.item.sliders[1].values[currentData.item.sliders[1].current].data
            SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_generic`, color1, color2, color3)
            UpdatePedVariation(playerPed)
        end
    })

    menu:addItem({
        title = "Main Color",
        sliders = {{type = "palette", title = "Color 1", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color1 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })

    menu:addItem({
        title = "Second Color",
        sliders = {{type = "palette", title = "Color 2", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color2 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })

    menu:addItem({
        title = "Three Color",
        sliders = {{type = "palette", title = "Color 3", tint = "tint_hair", max = 255, current = 14}},
        onChange = function(currentData)
            color3 = currentData.item.sliders[1].value
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
        end,
    })
    menu:addItem({
        title = "Apply",
        onClick = function(currentData)
            if currentHairItem then
                SetMetaPedTag(playerPed, currentHairItem, `hair_gen_999_c0_999_ab`, `hair_gen_999_c0_999_nm`, `hair_gen_999_c0_999_m`, `metaped_tint_hair`, color1, color2, color3)
                UpdatePedVariation(playerPed)
            end
            jo.menu.show(false)
            inmenu = false
        end,
    })

    menu:send()
    jo.menu.setCurrentMenu('menu1')
    jo.menu.show(true)
    inmenu = true
end

CreateThread(function()
    while true do
        Wait(0)
        if inmenu then
            DisableControlAction(0, 0x4A903C11, true)
			DisableControlAction(0, 0x8CC9CD42, true)
			DisableControlAction(0, 0x24978A28, true)
			DisableControlAction(0, 0xDE794E3E, true)
			DisableControlAction(0, 0xD82E0BD2, true)
			DisableControlAction(0, 0x7F8D09B8, true)
			DisableControlAction(0, 0xD9D0E1C0, true)
			DisableControlAction(0, 0x8FFC75D6, true)
			DisableControlAction(0, 0x760A9C6F, true)
			DisableControlAction(0, 0x80F28E95, true)
			DisableControlAction(0, 0x4CC0E2FE, true)
			DisableControlAction(0, 0xD8F73058, true)
			DisableControlAction(0, 0x9720FCEE, true)
			DisableControlAction(0, 0xE31C6A41, true)
			DisableControlAction(0, 0x07CE1E61, true)
			DisableControlAction(0, 0xB2F377E8, true) -- Attack
                        DisableControlAction(0, 0xC1989F95, true) -- Attack 2
                        DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
			DisableControlAction(0, 0xDE794E3E, true) -- Cover
                        DisableControlAction(0, 0x06052D11, true) -- Cover
                        DisableControlAction(0, 0x5966D52A, true) -- Cover
                        DisableControlAction(0, 0xCEFD9220, true) -- Cover
                        DisableControlAction(0, 0xC75C27B0, true) -- Cover
                        DisableControlAction(0, 0x41AC83D1, true) -- Cover
                        DisableControlAction(0, 0xADEAF48C, true) -- Cover
                        DisableControlAction(0, 0x9D2AEA88, true) -- Cover
                        DisableControlAction(0, 0xE474F150, true) -- Cover
			DisableControlAction(0, 0xDB096B85, true) -- CTRL
			DisableControlAction(0, 0xAC4BD4F1, true) -- [OpenWheelMenu]
			DisableControlAction(0, 0x6319DB71, true) -- [OpenWheelMenu]
			DisableControlAction(0, 0x05CA7C52, true) -- [OpenWheelMenu]
                        DisableControlAction(0, 0x018C47CF, true)
                        DisableControlAction(0, 0x110AD1D2, true)
                        DisableControlAction(0, 0x14DB6C5E, true)
                        DisableControlAction(0, 0x17BEC168, true)
                        DisableControlAction(0, 0x17D3BFF5, true)
                        DisableControlAction(0, 0x2277FAE9, true)
                        DisableControlAction(0, 0x2EAB0795, true)
                        DisableControlAction(0, 0x399C6619, true)
                        DisableControlAction(0, 0x41AC83D1, true)
                        DisableControlAction(0, 0x43F2959C, true)
                        DisableControlAction(0, 0x5E723D8C, true)
                        DisableControlAction(0, 0x91C9A817, true)
                        DisableControlAction(0, 0x97C71B28, true)
                        DisableControlAction(0, 0x9BEE9213, true)
                        DisableControlAction(0, 0x9FA5AD07, true)
                        DisableControlAction(0, 0xA4F1006B, true)
                        DisableControlAction(0, 0xA95E1468, true)
                        DisableControlAction(0, 0xC75C27B0, true)
                        DisableControlAction(0, 0xCEFD9220, true)
                        DisableControlAction(0, 0xD51B784F, true)
                        DisableControlAction(0, 0xDB8D69B8, true)
                        DisableControlAction(0, 0xDFF812F9, true)
                        DisableControlAction(0, 0xE2473BF0, true)
                        DisableControlAction(0, 0xF5C4701B, true)
                        DisableControlAction(0, 0xB99A9CAD, true)
                        DisableControlAction(0, 0xD2047988, true)
        end
    end
end)

