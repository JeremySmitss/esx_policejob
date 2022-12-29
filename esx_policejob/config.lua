Config                            = {}

Config.DrawDistance               = 10.0 -- Hoe dichtbij moet je zijn om de markers te tekenen (in GTA-eenheden).
Config.MarkerType                 = {Cloakrooms = 20, Armories = 21, BossActions = 22, Vehicles = 36, Helicopters = 34, VehicleDeleters = 20}
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement     = true -- Schakel in als u esx_identity gebruikt.
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- Schakel in als u esx_identity gebruikt.
Config.EnableLicenses             = true -- Schakel in als u esx_license gebruikt.

Config.EnableHandcuffTimer        = true -- Handboeien-timer inschakelen? zal de speler opheffen nadat de tijd is verstreken.
Config.HandcuffTimer              = 10 * 60000 -- 10 minuten

Config.EnableJobBlip              = true -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.
Config.assistentiecollega         = false

Config.EnableESXService           = false -- Enable esx service?
Config.MaxInService               = -1 -- How much people can be in service at once?

Config.KeyToOpenCarGarage = 38			
Config.KeyToOpenHeliGarage = 38		
Config.KeyToOpenBoatGarage = 38		
Config.PoliceDatabaseName = 'police'

Config.CarGarageSprite = 50
Config.CarGarageDisplay = 4
Config.CarGarageScale = 0.90
Config.CarGarageColour = 22
Config.CarGarageName = "Politie Opslag"
Config.EnableCarGarageBlip = true

Config.PoliceCarMarker = 1 											
Config.PoliceCarMarkerColor = { r = 255, g = 0, b = 0, a = 100 } 	
Config.PoliceCarMarkerScale = { x = 2.5, y = 2.5, z = 0.5 }  				
Config.CarDraw3DText = "Press ~g~[E]~s~ to open ~y~garage~s~"	

Config.LabelStoreVeh = "Sla je voertuig op"
Config.TitlePoliceGarage = "GARAGE"
Config.VehicleParked = "Het voertuig is ~g~succesvol~s~ in de garage gezet!"
Config.NoVehicleNearby = "~r~Er is geen voertuig in de buurt~s~"
Config.Distance = 20

Config.DrawDistance      = 100.0
Config.TriggerDistance 	 = 3.0

Config.Marker 			 = {Type = 27, r = 0, g = 127, b = 22}

Config.Locale                     = 'nl'

Config.Jobs = {
	police = true,
}

Config.DsiJobs = {
	offpolice = true,
	police = true,
}

Config.DsiRanks = {
	militar = true,
	militar2 = true,
	militar3 = true,
	militar4 = true,
	boss = true,
	boss = true,
}

Config.RechercheJobs = {
	police = true,
}

Config.RechercheOffJobs = {
	offpolice = true,
}

Config.RechercheRanks = {
	militar = true,
	militar2 = true,
	militar3 = true,
	militar4 = true,
	boss = true,
	boss = true,
}

Config.HasLightbarsJob = {
	police = true
}

Config.HasLightbarRanks = {
	militar = true,
	militar2 = true,
	militar3 = true,
	militar4 = true,
	boss = true,
	boss = true,
	aspirant = false,
}

Config.CarZones = {
	PoliceCarGarage = {
		Pos = {
			{x = 452.41,  y = -1020.67, z = 28.35},
			{x = -467.16,  y = 6015.56, z = 31.32},
			{x = 1868.65,  y = 3696.42, z = 33.7},
			{x = -1047.62,  y = -852.69, z = 4.87} 
		}
	}
}

Config.Items = {
	{ value = 'ammopistolpolitie', price = 0, label = '9x19mm Munitie (Pistol)' },
	{ value = 'ammosmgpolice', price = 0, label = '9x19mm Munitie (SMG)' },
	{ value = 'ammoriflepolice', price = 0, label = '5.56x45mm Munitie' },
	{ value = 'ammosniperpolice', price = 0, label = '7.62x51mm Munitie' },
	{ value = 'ammoshotgunpolice', price = 0, label = '12 Gauge Hagel Munitie' },
	{ value = 'gps', price = 500, label = 'GPS' },
	{ value = 'radio', price = 500, label = 'Porto' },
	{ value = 'bread', price = 4, label = 'Brood' },
	{ value = 'water', price = 3, label = 'Water' },
	{ value = 'blowpipe_police', price = 0, label = 'Snijbrander' },
}

Config.policeStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(-1088.52, -830.85, 33.18),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.5,
			Colour  = 0
		},

		Blip2 = {
			Coords  = vector3(1853.09, 3686.21, 34.28),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.5,
			Colour  = 0
		},

		Blip3 = {
			Coords  = vector3(-446.34, 6011.35, 31.72),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.5,
			Colour  = 0
		},

		Cloakrooms = {
			vector3(1858.93, 3694.62, 34.23),
			vector3(-436.36, 5989.71, 31.72)
		},

		Armories = {
			vector3(-1098.3537597656, -826.79675292969, 14.283270835876),
			vector3(1861.55, 3689.34, 34.26),
			vector3(-440.04, 5991.6, 31.72)
		},

		Vehicles = {
			{
				Spawner = vector3(-1080.860, -861.72, 5.04),
				InsideShop = vector3(228.5, -993.5, -99.5),
                SpawnPoint = { x = -1070.0245, y = -855.0836, z = 4.8679 },
                Heading = 217.3
			},
			{
				Spawner = vector3(-457.14, 6010.3, 31.49),
				InsideShop = vector3(-462.07, 6009.51, 31.34),
				SpawnPoint = vector3(-462.07, 6009.51, 31.34),
				Heading = 85.1
			},
			{
				Spawner = vector3(1862.92, 3686.27, 34.27),
				InsideShop = vector3(1865.26, 3682.61, 33.71),
				SpawnPoint = vector3(1865.26, 3682.61, 33.71),
				Heading = 85.1
			}
		},

		Helicopters = {
			{
				Spawner = vector3(-1092.3, -840.25, 37.7),
				InsideShop = vector3(-1096.27, -832.37, 37.7),
                SpawnPoint = { x = -1096.27, y = -832.37, z = 37.7 },
                Heading = 307.8
			},
			{
				Spawner = vector3(-455.68, 5984.32, 31.3),
				InsideShop = vector3(-475.87, 5987.97, 31.34),
				SpawnPoint = vector3(-475.87, 5987.97, 31.34),
				Heading = 312.55
			},
			{
				Spawner = vector3(1825.46, 3681.01, 40.36),
				InsideShop = vector3(1832.88, 3678.8, 40.36),
				SpawnPoint = vector3(1832.88, 3678.8, 40.36),
				Heading = 210.77
			}
		},

		VehicleDeleters = {
			vector3(1865.1, 3682.26, 33.69)
		},


		BossActions = {
			vector3(-1113.2587, -833.2662, 34.361),
			vector3(-432.14, 6005.29, 31.72)
		}

	}

}


Config.AuthorizedWeapons = {
	aspirant = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
	},

	surveillant = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
	},

	agent = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 }, -- Mag een agent een SMG HEBBEN?!
	},

	hoofdagent = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	brigadier = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	inspecteur = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	hoofdinspecteur = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	commissaris = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	hoofdcommissaris = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	boss = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		--{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	dsi1 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	dsi2 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	dsi3 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	dsi4 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	dsi5 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	recherche1 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	recherche2 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	recherche3 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},

	recherche4 = {
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', price = 0 },
		{ weapon = 'WEAPON_SMG', components = { 0, 0, 0 }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE_MK2', components = { 0, 0, 0, 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = { 0, 0, 0 }, price = 0 },
		--{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0 }, price = 0 },
	},
}

Config.AuthorizedVehicles = {
	Shared = {

	},

	aspirant = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
	},

	surveillant = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		}
	},

	agent = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		}
	},

	hoofdagent = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	brigadier = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	inspecteur = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	hoofdinspecteur = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	commissaris = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	hoofdcommissaris = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	boss = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	dsi1 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	dsi2 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	dsi3 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	dsi4 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	recherche1 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	recherche2 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	recherche3 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	},

	recherche4 = {
		{
			model = 'police',
			label = 'Volkswagen Touran'
		},
		{
			model = 'mercedesb',
			label = 'Mercedes B-Klasse'
		},
		{
			model = 'police2',
			label = 'Mercedes Vito'
		},
		{
			model = 'flatbedp',
			label = 'Schepwagen'
		},
		{
			model = 'pamarok',
			label = 'Volkswagen Amarok'
		},
		{
			model = 'policeb',
			label = 'Zware Motor'
		},
		{
			model = 'bf400',
			label = 'Lichte Motor'
		},
		{
			model = 'police3',
			label = 'Audi A6'
		},
		{
			model = 'bmwunmarked',
			label = 'BMW Unmarked'
		},
		{
			model = 'policemaserati',
			label = 'Maserati Unmarked'
		},
		{
			model = 'politiev90',
			label = 'Volvo V90 Unmarked'
		}
	}
}

Config.AuthorizedHelicopters = {
	Shared = {

	},

	aspirant = {

	},

	surveillant = {	

	},

	agent = {

	},

	hoofdagent = {

	},

	brigadier = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
	},

	inspecteur = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	hoofdinspecteur = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	commissaris = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	hoofdcommissaris = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	boss = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	dsi1 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	dsi2 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	dsi3 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	dsi4 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	recherche1 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	recherche2 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	recherche3 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},

	recherche4 = {
		{
			model = 'polmav',
			label = 'Zulu'
		},
		{
			model = 'mh60t',
			label = 'Kustwacht Helikopter'
		},
		{
			model = 'buzzard',
			label = 'Gevechtshelikopter'
		},
	},
}