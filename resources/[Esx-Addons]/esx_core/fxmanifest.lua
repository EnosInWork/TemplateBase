fx_version 'adamant'
game 'gta5'

author 'ESX-Framework'
description 'A compact of esx addons by enos.'
lua54 'yes'

server_scripts {
	'@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
	'esx_addonaccount/server/classes/addonaccount.lua',
	'esx_addonaccount/server/main.lua',
	'esx_addoninventory/server/classes/addoninventory.lua',
	'esx_addoninventory/server/main.lua',
	'esx_datastore/server/classes/datastore.lua',
	'esx_datastore/server/main.lua'
}

server_exports {
    'GetSharedAccount',
    'AddSharedAccount',
	'GetSharedInventory',
    'AddSharedInventory',
}

dependency 'es_extended'