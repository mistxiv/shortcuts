local tbl = function()
   if SmiletonBoss3 == nil then
      SmiletonBoss3 = {
         ne_sw_safe_pattern = "064128",
         nw_se_safe_pattern = "164128",
         ne = {
            pos = {
               x = -11,
               y = -465,
               z = -49,
            },
            safe = true,
         },
         nw = {
            pos = {
               x = -33,
               y = -465,
               z = -49,
            },
            safe = true,
         },
         se = {
            pos = {
               x = -11,
               y = -465,
               z = -39,
            },
            safe = true,
         },
         sw = {
            pos = {
               x = -33,
               y = -465,
               z = -39,
            },
            safe = true,
         },
         mechanics_resolution_ms = 8000,
      }
   end
   local sb3, sme = SmiletonBoss3, KitanoiSettings.SavedMapEffects

   if (TimeSince(sb3.last_run or 0) < gPulseTime) then
      return
   end

   local t, p = TensorCore.mGetTarget(), TensorCore.mGetPlayer()
   if (t and t.contentid ~= 10336 or not p.incombat) then
      return
   end

   local excavation_bombs = TensorCore.entityList("contentid=11216,action=34")
   if table.valid(excavation_bombs) then
      sb3.ne.safe, sb3.nw.safe, sb3.se.safe, sb3.sw.safe = true, true, true, true
      local bomb_compass = "unknown"
      for i, bomb in pairs(excavation_bombs) do
         if (bomb.pos.x == sb3.ne.pos.x and bomb.pos.z == sb3.ne.pos.z) then
            bomb_compass = "ne"
            sb3.ne.safe = false
         elseif (bomb.pos.x == sb3.nw.pos.x and bomb.pos.z == sb3.nw.pos.z) then
            bomb_compass = "nw"
            sb3.nw.safe = false
         elseif (bomb.pos.x == sb3.se.pos.x and bomb.pos.z == sb3.se.pos.z) then
            bomb_compass = "se"
            sb3.se.safe = false
         elseif (bomb.pos.x == sb3.sw.pos.x and bomb.pos.z == sb3.sw.pos.z) then
            bomb_compass = "sw"
            sb3.sw.safe = false
         end
         d(
            "[SmiletonBoss3] ebomb | " .. i .. " | XYZ " .. bomb.pos.x .. " " .. bomb.pos.y .. " " .. bomb.pos.z ..
               " | " .. bomb_compass)
         if (KitanoiFuncs.puddledata[i] == nil) then
            KitanoiFuncs.puddledata[i] = {
               entity = bomb,
               pos = bomb.pos,
               radius = 8,
               duration = Now() + 30000,
            }
         end
      end
   end

   if (sme[sb3.ne_sw_safe_pattern] and TimeSince(sme[sb3.ne_sw_safe_pattern].timeadded) <= sb3.mechanics_resolution_ms) then
      d("[SmiletonBoss3] detected ne/sw safe pattern")
      if (sb3.sw.safe == true) then
         d("[SmiletonBoss3] moving to sw safe spot")
         Player:MoveTo(sb3.sw.pos.x, sb3.sw.pos.y, sb3.sw.pos.z)
      else
         d("[SmiletonBoss3] moving to ne safe spot")
         Player:MoveTo(sb3.ne.pos.x, sb3.ne.pos.y, sb3.ne.pos.z)
      end
      KitanoiSettings.avoidingtime = Now()
   end

   if (sme[sb3.nw_se_safe_pattern] and TimeSince(sme[sb3.nw_se_safe_pattern].timeadded) <= sb3.mechanics_resolution_ms) then
      d("[SmiletonBoss3] detected nw/se safe pattern")
      if (sb3.nw.safe == true) then
         d("[SmiletonBoss3] moving to nw safe spot")
         Player:MoveTo(sb3.nw.pos.x, sb3.nw.pos.y, sb3.nw.pos.z)
      else
         d("[SmiletonBoss3] moving to se safe spot")
         Player:MoveTo(sb3.se.pos.x, sb3.se.pos.y, sb3.se.pos.z)
      end
      KitanoiSettings.avoidingtime = Now()
   end

   sb3.last_run = Now()
end

return tbl
