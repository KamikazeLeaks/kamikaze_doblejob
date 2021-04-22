fx_version 'adamant'

game 'gta5'

description 'Free KamikazeLeaks 2 Jobs Script'

client_script {
    'client/main.lua',
    'config.lua'
    }

version '1.0.1'

server_scripts {
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua'
}
