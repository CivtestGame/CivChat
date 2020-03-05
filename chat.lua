
local C = minetest.colorize

-- Formatters

local function standard_formatter(from, from_color, msg)
   return C(from_color, from .. ": ") .. msg
end

local function me_formatter(from, from_color, msg)
   return " * " .. C(from_color, from) .. " " .. msg .. " *"
end

local function announce_formatter(from, from_color, msg)
   return C("#0f0", "\n [SERVER ANNOUNCEMENT] ") .. "\n" .. msg .. "\n\n"
end

-- Chat entrypoints

minetest.register_on_chat_message(function(from, msg)
   if msg:sub(1, 1) == "/" then
      return false
   end

   return civchat.on_chat_message(from, msg, false, standard_formatter)
end)

minetest.register_chatcommand("me",
   {
      params = "<message>",
      privs = { shout = true },
      description = "Sends a message in an 'actional' way.",
      func = function(name, param)
         if param ~= "" then
            return civchat.on_chat_message(name, param, false, me_formatter)
         end
         return false, "Please supply a message."
      end
   }
)

minetest.register_chatcommand("announce",
   {
      params = "<message>",
      privs = { server = true },
      description = "Anonymously announces a message to all players.",
      func = function(name, param)
         if param ~= "" then
            return civchat.on_chat_message(name, param, true, announce_formatter)
         end
         return false, "Please supply a message."
      end
   }
)
