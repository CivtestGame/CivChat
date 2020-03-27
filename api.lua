
local admin_color = tonumber(minetest.settings:get("civchat_admin_color"))
local chat_radius =
   tonumber(minetest.settings:get("civchat_localchat_radius")) or 1000


-- Heavily influenced by chatplus: https://github.com/rubenwardy/chatplus

civchat.handlers = {}

function civchat.register_handler(func)
   table.insert(civchat.handlers, func)
end

-- Can be overidden
function civchat.get_player_name_color(name)
   local player = minetest.get_player_by_name(name)
   if player
      and minetest.check_player_privs(name, {server = true})
   then
      return admin_color or "#dd0"
   end
   return nil
end

local C = minetest.colorize

function civchat.on_chat_message(from, msg, global_message, formatter)
   if not minetest.check_player_privs(from, {shout = true}) then
      return false
   end

   local from_color = civchat.get_player_name_color(from) or "#fff"
   local from_player = minetest.get_player_by_name(from)

   local objects = {}

   if global_message then
      objects = minetest.get_connected_players()
   else
      objects = minetest.get_objects_inside_radius(
         from_player:get_pos(), chat_radius
      )
   end

   local found_player_in_radius = false

   -- Loop through possible receivers
   for _,object in ipairs(objects) do
      if not minetest.is_player(object) then
         goto continue
      end

      local player = object
      local to = player:get_player_name()

      if to ~= from then
         found_player_in_radius = true
         -- Run handlers
         local res = true
         for i, handler in ipairs(civchat.handlers) do
            res = handler(from, to, msg)
            if not res then
               break
            end
         end

         -- Send message
         if res then
            minetest.chat_send_player(to, formatter(from, from_color, msg))
         end
      elseif minetest.features.no_chat_message_prediction then
         minetest.chat_send_player(from, formatter(from, from_color, msg))
      end
      ::continue::
   end

   if not found_player_in_radius then
      local meta = from_player:get_meta()
      local time = os.time(os.date("!*t"))

      -- probably need an API for this, instead of reusing the OTP timer
      if meta:get("onetimetp")
         and meta:get_int("onetimetp") + 3600 > time
      then
         minetest.chat_send_player(
            from, "Nobody is nearby to see your message. Instead, try "
               .. "directly messaging someone: '/msg <player> <message>'"
         )
      end
   end

   return true
end
