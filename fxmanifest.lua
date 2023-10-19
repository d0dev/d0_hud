fx_version 'cerulean'
game 'gta5'

name 'do_hud'
author 'd0dev'
description 'HUD, Seatbelt, Speedlimiter & Hygiene System'
version '1.00'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css',
    'html/audio/shower.ogg'
}

client_scripts {'client/client.lua', 'client/hygiene.lua'}

server_scripts {'server/server.lua', 'server/hygieneServer.lua'}

shared_scripts {'config.lua','@es_extended/imports.lua'}

dependencies {
    'es_extended',
    'esx_basicneeds'
}

data_file 'DLC_ITYP_REQUEST' 'ligoshower.ytyp'
