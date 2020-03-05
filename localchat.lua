
-- Distance-based localchat handler

local chat_radius =
   tonumber(minetest.settings:get("civchat_localchat_radius")) or 1000

civchat.register_handler(function(from, to, msg)
      local from_o = minetest.get_player_by_name(from)
      local to_o = minetest.get_player_by_name(to)
      if not from_o or not to_o then
         return false
      end

      return vector.distance(from_o:get_pos(), to_o:get_pos()) <= chat_radius
end)
