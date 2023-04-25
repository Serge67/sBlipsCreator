fx_version 'cerulean'
game 'gta5'


patch '53RG3'
description 'sBlipsCreator'
version '1.9.4'

shared_script '@es_extended/imports.lua'

shared_scripts {
    'config.lua'
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/UIHeritage.lua",
    
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}