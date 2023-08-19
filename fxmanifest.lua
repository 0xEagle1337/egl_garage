fx_version 'cerulean'
games { 'gta5' }

author 'Eagle'
description 'FiveM garage script using RageUI for ESX Legacy 1.8.5'
version '1.0.0'


dependency({
	"es_extended",
	"esx_vehicleshop",
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

-- Created by Eagle#7366
-- Feel free to modify the code.
