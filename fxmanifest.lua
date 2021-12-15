fx_version 'bodacious'
game 'gta5'

author 'BR'
description 'A Full Featured FiveM Event System'
repository 'https://github.com/BehnamRt/FiveM_EventSystem'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'essentialmode',
	'mysql-async'
}