fx_version 'cerulean'
game 'gta5'
version '1.0.0'
author 'ShinyX'

client_scripts {
        'config.lua',
	'client.lua',
}
ui_page {
	'html/index.html'
}
files {
	'html/index.html',
	'html/css/style.css',
	'html/js/fivem.js',
	'html/js/tx.mp3',
	'html/img/*.png',
	'html/css/DigitalNumbers-Regular.woff'
}

dependency 'es_extended'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

