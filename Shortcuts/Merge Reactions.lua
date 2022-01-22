local tbl = function()
   local folders = {[[TensorReactions\GeneralTriggers\]], [[TensorReactions\GeneralTriggers\anyone\]]}
   local luamods = GetLuaModsPath()
   local f2 = luamods .. [[TensorReactions\GeneralTriggers\Mist.lua]]
   local c2 = persistence.load(f2)

   for _, folder in pairs(folders) do
      for _, file in pairs(FolderList(luamods .. folder, [[(.*).lua$]])) do
         local f1 = luamods .. folder .. file
         local c1 = persistence.load(f1)
         for _, a2 in pairs(c2) do
            local addaction = true
            for _, a1 in pairs(c1) do
               if a2["name"] == a1["name"] then
                  addaction = false
                  break
               end
            end -- a2
            if addaction == true then
               c1[#c1 + 1] = a2
            end
         end -- a1
         persistence.store(f1, c1)
      end -- file
   end -- folder

   TensorCore.API.TensorReactions.reloadGeneralTriggers()

end

return tbl

