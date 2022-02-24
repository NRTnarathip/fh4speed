fx_version 'cerulean'
game 'gta5'

description "Forza Horizon 4 Speedometer"
author "Akkariin" -- NRTnarathip Fork from this author
url "https://www.zerodream.net/"

shared_scripts  {
	'@es_extended/imports.lua',
	'config.lua',
}

ui_page "html/hud.html"

files {
	"html/*.html",
	"html/js/*.js",
	"html/css/*.css",
	"html/fonts/*.eot",
	"html/fonts/*.svg",
	"html/fonts/*.ttf",
	"html/fonts/*.woff",
	"html/fonts/*.woff2",
	"html/images/*.png",
}

client_scripts {
	"client.lua"
} 
server_scripts {
	"server.lua"
}
dependencies {
	'es_extended',
}