local tbl = function()
   local tables = {"KitanoiFuncs", "KitanoiSettings"}
   for _, t in pairs(tables) do
      local f = GetStartupPath() .. [[\\..\\..\\Settings_]] .. t .. [[.lua]]
      local settings = {}
      for k, v in pairs(_G[t]) do
         if _G["Settings"][t][k] ~= nil then
            settings[k] = v
         end
      end
      persistence.store(f, settings)
   end

   d("Saved Kitanoi settings")
end

return tbl

