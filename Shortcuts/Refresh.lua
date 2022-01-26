local tbl = function()
   if RefreshTimer == nil then
      RefreshTimer = 0
   end
   if (TimeSince(RefreshTimer) < 5000) then
      return
   end
   MistShortcuts.Init()
   MistDogTag = nil
   MistUtility = nil
   MistPrompto = nil
   SmiletonBoss1 = nil
   SmiletonBoss3 = nil
   SuzakuScarletMelody = nil

   if KitanoiFuncs ~= nil then
      if KitanoiSettings.SelectedDungeonList == 2 then -- "Your Custom Profiles"
         KitanoiFuncs:ReloadDungeon()
      end

      local f = GetStartupPath() .. [[\..\..\Prompto.txt]]
      if FileExists(f) then
         local tbl1 = FileLoad(f)
         local tbl2 = {}
         if table.valid(tbl1) then
            for _, s in pairs(tbl1) do
               if not string.starts("#", s) then
                  tbl2[#tbl2 + 1] = s:gsub("\r", ""):gsub("\n", "")
               end
            end
         else
            ml_error("invalid table")
         end
         Settings.KitanoiFuncs.YesNoOptions = table.concat(tbl2, "\n")
         KitanoiFuncs.YesNoOptions = Settings.KitanoiFuncs.YesNoOptions
      else
         ml_error(f .. " does not exist")
      end
      d("updated KitanoiFuncs yes no options")
   end

   if TensorCore ~= nil then
      TensorCore.API.TensorReactions.reloadGeneralTriggers()
      TensorCore.API.TensorReactions.reloadTimelineTriggers()
   end
end

return tbl

