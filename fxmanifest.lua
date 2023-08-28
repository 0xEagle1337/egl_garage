fx_version 'cerulean'
games { 'gta5' }

author 'Eagle'
description 'FiveM garage / impound script using RageUI for ESX Legacy 1.8.5'
version '1.1.0'


dependency({
	"es_extended",
	"esx_vehicleshop",
	"VehicleDeformation",
	"ox_inventory",
	"ox_fuel",
})

locales({
	"locales/fr.lua",
	"locales/en.lua",
})

client_scripts({
	"src/RMenu.lua",
	"src/menu/RageUI.lua",
	"src/menu/Menu.lua",
	"src/menu/MenuController.lua",
	"src/components/*.lua",
	"src/menu/elements/*.lua",
	"src/menu/items/*.lua",
	"src/menu/panels/*.lua",
	"src/menu/panels/*.lua",
	"src/menu/windows/*.lua",

	"config.lua",
	
	"locales/fr.lua",
	"locales/en.lua",

	"client/main.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"locales/fr.lua",
	"locales/en.lua",

	"config.lua",
	
	"server/main.lua",
})

-- Created by Eagle,
-- Discord: 0xeagle1337

-- Feel free to modify the code.
