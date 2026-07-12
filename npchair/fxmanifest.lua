fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Deyatel'
description 'npchair'

client_scripts {
    'client/client.lua',
	'@jo_libs/init.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'jo_libs',
}

ui_page "nui://jo_libs/nui/menu/index.html"

jo_libs {
	'menu'
}


lua54 'yes'
