
-- Ignore list persistence

local storage = minetest.get_mod_storage()

civchat.player_ignores = {}

function civchat.save_ignores()
    storage:set_string("ignores", minetest.serialize(civchat.player_ignores))
    minetest.debug("[CivChat] Saved ignore lists.")
end

function civchat.load_ignores()
    civchat.player_ignores = minetest.deserialize(storage:get_string("ignores"))
    civchat.player_ignores = civchat.player_ignores or {}
    minetest.debug("[CivChat] Saved ignore lists.")
end

civchat.load_ignores()

minetest.register_on_shutdown(civchat.save_ignores)

local timer = 0
minetest.register_globalstep(function(dtime)
      timer = timer + dtime
      if timer < 60 * 10 then
         return
      end
      timer = 0
      civchat.save_ignores()
end)

-- Commands

minetest.register_chatcommand(
   "ignore",
   {
      params = "<player>",
      description = "Adds a name to the sender's chat ignore list.",
      func = function(name, param)
         if param == "" then
            return false, "Please specify a player to ignore."
         end

         civchat.player_ignores[name] = civchat.player_ignores[name] or {}
         civchat.player_ignores[name][param] = true

         return true, "Player '" .. param .. "' was added to your ignore list."
      end
   }
)

minetest.register_chatcommand(
   "unignore",
   {
      params = "<player>",
      description = "Removes player from the sender's chat ignore list.",
      func = function(name, param)
         if param == "" then
            return false, "Please specify a player to unignore."
         end
         civchat.player_ignores[name][param] = nil
         return true, "Player '" .. param .. "' was removed from your ignore list."
      end
   }
)

local C = minetest.colorize

local function table_keyvals(tab)
   local keyset = {}
   local valset = {}
   local n = 0
   for k, v in pairs(tab) do
      n = n + 1
      keyset[n] = k
      valset[n] = v
   end
   return keyset, valset
end

minetest.register_chatcommand(
   "ignore_list",
   {
      params = "",
      description = "Returns the sender's full chat ignore list.",
      func = function(name)
         local ignores = civchat.player_ignores[name]
         if ignores then
            local list = table.concat(table_keyvals(ignores), "  ")
            return true, C("#0f0", "Ignored Players: ") .. list
         else
            return true, "You are not currently ignoring anyone."
         end
      end
   }
)

-- Disallow messages to go through if target has /ignore-d the source
civchat.register_handler(function(from, to, msg)
      local ignore_entries = civchat.player_ignores[to]
      if ignore_entries then
         return not ignore_entries[from]
      end
      return true
end)
