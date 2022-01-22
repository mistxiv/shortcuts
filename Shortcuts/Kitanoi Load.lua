local tbl = function()
   local tables = {"KitanoiFuncs", "KitanoiSettings"}
   for _, t in pairs(tables) do
      local f = GetStartupPath() .. [[\\..\\..\\Settings_]] .. t .. [[.lua]]
      local settings = persistence.load(f)
      table.merge(_G["Settings"][t], settings)
      table.merge(_G[t], settings)
   end

   d("Loaded Kitanoi settings")
end

return tbl

