fx_version 'cerulean'
game 'gta5'

author '_Lub0s_'
description 'Drogy Script ESX + ox_inventory + ox_lib'
version '1.0.0'

-- Závislosti
dependency 'ox_lib'

-- Zdieľané súbory (config)
shared_script 'config.lua'

-- Klientské skripty
client_scripts {
    '@es_extended/imports.lua', -- Ak používaš ESX Legacy
    'client.lua',
    'quest_client.lua'
}

-- Serverové skripty
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Ak potrebuješ databázu (voliteľné)
    'server.lua',
    'quest_server.lua'
}
