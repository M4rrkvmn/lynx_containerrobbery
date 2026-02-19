fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'lynxd3v'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/src/style.css',
    'html/src/app.js',
    'html/src/img/*.png'
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
    '@ox_lib/init.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'ox_target',
    'oxmysql'
}