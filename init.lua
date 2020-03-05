local modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/"

civchat = {}

dofile(modpath .. "api.lua")
dofile(modpath .. "pm.lua")
dofile(modpath .. "handlers.lua")
dofile(modpath .. "chat.lua")
dofile(modpath .. "ignore.lua")

minetest.log("[CivChat] Loaded CivChat.")

return civchat
