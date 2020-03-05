
local admin_color = tonumber(minetest.settings:get("civchat_admin_color"))

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

function civchat.on_chat_message(from, msg)
   if not minetest.check_player_privs(from, {shout = true}) then
      return false
   end

   if #civchat.handlers == 0 then
      return false
   end

   local color = civchat.get_player_name_color(from) or "#fff"

   -- Loop through possible receivers
   for _,player in ipairs(minetest.get_connected_players()) do
      local to = player:get_player_name()

      if to ~= from then
         -- Run handlers
         local res = nil
         for i, handler in ipairs(civchat.handlers) do
            res = handler(from, to, msg)
            if not res then
               break
            end
         end

         -- Send message
         if res then
            minetest.chat_send_player(to, C(color, from .. ": ") .. msg)
         end
      elseif minetest.features.no_chat_message_prediction then
         minetest.chat_send_player(from, C(color, from .. ": ") .. msg)
      end
   end
   return true
end


minetest.register_on_chat_message(function(from, msg)
   if msg:sub(1, 1) == "/" then
      return false
   end

   return civchat.on_chat_message(from, msg)
end)
