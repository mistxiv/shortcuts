local tbl = function(state)
   KitanoiFuncs.DungeonFrameWorkRun = state
   Settings.KitanoiFuncs.DungeonFrameWorkRun = state
   if state == false then
      Player:Stop()
      ActionList:StopCasting()
   end
end

return tbl
