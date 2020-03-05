local modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/"

civchat = {}

dofile(modpath .. "api.lua")
dofile(modpath .. "pm.lua")
dofile(modpath .. "handlers.lua")
dofile(modpath .. "localchat.lua")

minetest.log("[CivChat] Loaded CivChat.")

return civchat
