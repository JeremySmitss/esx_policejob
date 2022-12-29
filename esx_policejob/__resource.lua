
fx_version 'adamant'

game 'gta5'

description 'Policejob'

version '1.3.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/nl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'@baseevents/lib/vehicle.lua',
	'locales/nl.lua',
	'config.lua',
	'client/main.lua',
	'client/vehicle.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}
