
local C = minetest.colorize

local player_last_messaged = {}

core.register_chatcommand("msg",
   {
      params = "<name> <message>",
      description = "Send a direct message to a player",
      privs = {shout=true},
      func = function(name, param)
         local sendto, message = param:match("^(%S+)%s(.+)$")
         if not sendto then
            return false, "Invalid usage, see /help msg."
         end
         local sendto_obj = core.get_player_by_name(sendto)
         if not sendto_obj then
            return false, "The player " .. sendto .. " is not online."
         end
         sendto = sendto_obj:get_player_name()
         player_last_messaged[name] = sendto
         local color_from = civchat.get_player_name_color(name) or "#f0f"
         local color_sendto = civchat.get_player_name_color(sendto) or "#f0f"
         core.chat_send_player(
            sendto,
            C("#f0f", "From ") .. C(color_from, name)
               .. C("#f0f", ": " .. message)
         )
         return true, C("#f0f", "To ") .. C(color_sendto, sendto)
            .. C("#f0f", ": " .. message)
      end,
})

core.register_chatcommand("r",
   {
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
            return false, "The player " .. sendto .. " is not online."
         end

         local color_from = civchat.get_player_name_color(name) or "#f0f"
         local color_sendto = civchat.get_player_name_color(sendto) or "#f0f"
         core.chat_send_player(
            sendto,
            C("#f0f", "From ") .. C(color_from, name)
               .. C("#f0f", ": " .. message)
         )

         return true, C("#f0f", "To ") .. C(color_sendto, sendto)
            .. C("#f0f", ": " .. message)
      end,
})
