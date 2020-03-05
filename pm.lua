
local c = minetest.colorize

local player_last_messaged = {}

core.register_chatcommand("msg", {
	params = "<name> <message>",
	description = "Send a direct message to a player",
	privs = {shout=true},
	func = function(name, param)
		local sendto, message = param:match("^(%S+)%s(.+)$")
		if not sendto then
			return false, "Invalid usage, see /help msg."
		end
		if not core.get_player_by_name(sendto) then
			return false, "The player " .. sendto
					.. " is not online."
		end
		player_last_messaged[name] = sendto
		core.chat_send_player(
			sendto, c("#f0f", "From " .. name .. ": " .. message)
		)
		return true, c("#f0f", "To " .. sendto ..": " .. message)
	end,
})

core.register_chatcommand("r", {
	params = "<message>",
	description = "Send a direct message to the last player messaged",
	privs = {shout=true},
	func = function(name, param)
		local message = param
		local sendto = player_last_messaged[name]
		if not sendto then
			return false, "You have not messaged someone."
		end

		if not core.get_player_by_name(sendto) then
			return false, "The player " .. sendto
					.. " is not online."
		end

		core.chat_send_player(
                      sendto, c("#f0f", "From " .. name .. ": " .. message)
                )
		return true, c("#f0f", "To " .. sendto ..": " .. message)
	end,
})
