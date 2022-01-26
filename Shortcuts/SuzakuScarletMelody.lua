local tbl = function()
   if SuzakuScarletMelody == nil then
      SuzakuScarletMelody = {
         revision = 1,
         facings = {0, 1.57, 3.14, -1.57},
         facings_idx = 1,
         pads = {
            [1] = {
               x = 93.98,
               y = 0.20,
               z = 105.67,
            },
            [2] = {
               x = 100.09,
               y = 0.20,
               z = 107.54,
            },
            [3] = {
               x = 105.99,
               y = 0.20,
               z = 105.73,
            },
            [4] = {
               x = 108.10,
               y = 0.20,
               z = 99.89,
            },
            [5] = {
               x = 105.74,
               y = 0.20,
               z = 94.45,
            },
            [6] = {
               x = 100.09,
               y = 0.20,
               z = 92.23,
            },
            [7] = {
               x = 94.16,
               y = 0.20,
               z = 94.45,
            },
            [8] = {
               x = 91.78,
               y = 0.20,
               z = 99.99,
            },
         },
      }
      function SuzakuScarletMelody.log(str)
         d("[SuzakuScarletMelody_r" .. SuzakuScarletMelody.revision .. "] " .. tostring(str))
      end
   end

   local ssm = SuzakuScarletMelody
   local t, p = TensorCore.mGetTarget(), TensorCore.mGetPlayer()

   if ((TimeSince(ssm.last_run or 0) < gPulseTime) or (not p.incombat)) then
      return
   end

   local el = TensorCore.entityList("contentid=7705,maxdistance=50")
   local cg = GetControl("_ContentGauge")
   local cg_progress
   if (cg) then
      local cg_strings = cg:GetStrings()
      if (cg_strings[10] ~= nil) then
         cg_progress = tonumber(cg_strings[10])
      end
   end

   if (table.valid(el) or cg_progress == 0) then
      ssm.log("orbs")
      local idx
      for k, e in pairs(EntityList.myparty) do
         if p.id == e.id then
            idx = k + 1
            break
         end
      end
      Player:MoveTo(ssm.pads[idx].x, ssm.pads[idx].y, ssm.pads[idx].z)
      if (not p:IsMoving() and p.alive == true) then
         Player:SetFacing(ssm.facings[ssm.facings_idx])
         ssm.facings_idx = (ssm.facings_idx % #ssm.facings) + 1
      end
      KitanoiSettings.avoidingtime = Now()
   end
   ssm.last_run = Now()
end

return tbl
