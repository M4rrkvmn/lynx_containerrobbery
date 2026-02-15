fx_version 'cerulean'
game 'gta5'

author 'Mrk'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/src/style.css',
    'html/src/app.js',
}

server_script {
    'server/*.lua'
}

client_script {
    'client/*.lua'
}

shared_script {
    '@es_extended/imports.lua',
    '@oxmysql/lib/MySQL.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'ox_target',
    'oxmysql'
}