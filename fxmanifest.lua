fx_version 'cerulean'

game 'gta5'
lua54 'yes'
author 'ItzSly'
description 'Recreated'

--Client Scripts-- 
client_scripts {
    'Client/*.lua'
}


shared_scripts {
    'Shared.lua'
}

--UI Part-- 
ui_page {
    'html/index.html', 
}

--File Part-- 
files {
    'html/index.html',
    'html/app.js', 
    'html/style.css',
} 

escrow_ignore {
    'Shared.lua',
    'Client/Vehicle.lua',
    'Client/Client.lua',
    'Client/EsxDeclaration.lua'
}
