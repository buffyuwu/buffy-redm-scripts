-- dont let peds get created here. travelling peds are unaffected
local pedZones = {
    { -- emerald ranch main house
        coords = vector3(1451.836, 320.3157, 89.400),
        radius = 30.0, -- Radius
    },
    { -- emerald ranch stable area
        coords = vector3(1391.623, 286.6714, 88.654),
        radius = 20.0, -- Radius
    },
    { -- emerald ranch pen area 1
    coords = vector3(1407.962, 304.0496, 88.654),
    radius = 20.0, -- Radius
    },
    { -- emerald ranch pen area 2
    coords = vector3(1389.182, 291.9951, 88.323),
    radius = 20.0, -- Radius
    },
	{ -- emerald ranch employee housing
        coords = vector3(1438.665, 353.6872, 88.647),
        radius = 10.0, -- Radius
    },
    { --hennigans x = 1211.133, y = -184.675, z = 101.36
        coords = vector3(-2327.86, -2387.53, 63.181),
        radius = 50.0,
    },
    { --Dewberry Stables
        coords = vector3(1211.133, -184.675, 101.36),
        radius = 30.0,
    },
    { --armadillo cholera corpses
        coords = vector3(-3587.62, -2607.31, -14.01),
        radius = 20,
    },
    { --armadillo cholera corpses 2
        coords = vector3(-3626.28, -2569.02, -13.05),
        radius = 20,
    },
    { --mcfarlanes ranch
        coords = vector3(-2422.66, -2397.00, 65.574),
        radius = 20,
    },
    { --bw saloon roof
        coords = vector3(-816.449, -1318.93, 52.034),
        radius = 30,
    },
    { --bw theatre roof
        coords = vector3(-780.224, -1357.71, 52.124),
        radius = 30,
    },
    { --bw city hall roof
        coords = vector3(-798.563, -1196.24, 61.148),
        radius = 50,
    },
    { --moonshine bar
        coords = vector3(-2782.49, -3057.46, -12.34),
        radius = 40,
    },
    { --moonshine bar goth
        coords = vector3(-1087.88, 698.6918, 80.594),
        radius = 40,
    },
    { --sd street re: https://discord.com/channels/1302937782691434528/1302942530500825118/1317912858087919638
        coords = vector3(2800.018, -1318.53, 46.409),
        radius = 20,
    },
    { --sd doyle's bar
	coords = vector3(2795.51, -1169.35, 47.93),
	radius = 20,
    },
    { --wapiti
	coords = vector3(465.3126, 2236.755, 247.63),
	radius = 50,
    },
    { --annesburg restaurant
	coords = vector3(2960.482, 1350.270, 44.852),
	radius = 150,
    },
    { --Braithwaite
	coords = vector3(1010.612, -1751.19, 46.659),
	radius = 150,
    },

}
AddEventHandler('populationPedCreating', function(x, y, z, model, setters)
	for k,v in ipairs(pedZones) do
		if #(v.coords - vector3(x, y, z)) < v.radius then
			CancelEvent()
		end
	end
end)
