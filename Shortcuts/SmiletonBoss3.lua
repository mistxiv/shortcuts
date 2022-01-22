local tbl = function()
   if SmiletonBoss3 == nil then
      SmiletonBoss3 = {
         revision = 5,
         entity_big_cheese = 10336,
         ne_sw_safe_pattern = "064128",
         nw_se_safe_pattern = "164128",
         channel_right_disassembler = 26447, -- south
         channel_left_disassembler = 26448, -- north
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
      function SmiletonBoss3.log(str)
         d("[SmiletonBoss3_r" .. SmiletonBoss3.revision .. "] " .. tostring(str))
      end
   end

   local sb3, sme = SmiletonBoss3, KitanoiSettings.SavedMapEffects
   local t, p = TensorCore.mGetTarget(), TensorCore.mGetPlayer()

   if ((TimeSince(sb3.last_run or 0) < gPulseTime) or (t and t.contentid ~= sb3.entity_big_cheese) or (not p.incombat)) then
      return
   end

   sb3.ne.safe, sb3.nw.safe, sb3.se.safe, sb3.sw.safe = true, true, true, true

   local excavation_bombs = TensorCore.entityList("contentid=11216,action=34")
   if table.valid(excavation_bombs) then
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
         sb3.log("ebomb | " .. i .. " | XYZ " .. bomb.pos.x .. " " .. bomb.pos.y .. " " .. bomb.pos.z ..
                    " | " .. bomb_compass)
         if (KitanoiFuncs.puddledata[i] == nil) then
            KitanoiFuncs.puddledata[i] = {
               entity = bomb,
               pos = bomb.pos,
               radius = 6,
               duration = Now() + 30000,
            }
         end
      end
   end

   if (sme[sb3.ne_sw_safe_pattern] and TimeSince(sme[sb3.ne_sw_safe_pattern].timeadded) <= sb3.mechanics_resolution_ms) then
      sb3.log("detected ne/sw safe pattern")
      -- if (KitanoiFuncs.ArgusIsCasting(sb3.channel_right_disassembler)) then
      --    sb3.log("right disassembler channeling")
      --    sb3.sw.safe = false
      -- end
      if (sb3.sw.safe == true) then
         sb3.log("moving to sw safe spot")
         Player:MoveTo(sb3.sw.pos.x, sb3.sw.pos.y, sb3.sw.pos.z)
      else
         sb3.log("moving to ne safe spot")
         Player:MoveTo(sb3.ne.pos.x, sb3.ne.pos.y, sb3.ne.pos.z)
      end
      KitanoiSettings.avoidingtime = Now() + gPulseTime
   end

   if (sme[sb3.nw_se_safe_pattern] and TimeSince(sme[sb3.nw_se_safe_pattern].timeadded) <= sb3.mechanics_resolution_ms) then
      sb3.log("detected nw/se safe pattern")
      -- if (KitanoiFuncs.ArgusIsCasting(sb3.channel_left_disassembler)) then
      --    sb3.log("left disassembler channeling")
      --    sb3.nw.safe = false
      -- end
      if (sb3.nw.safe == true) then
         sb3.log("moving to nw safe spot")
         Player:MoveTo(sb3.nw.pos.x, sb3.nw.pos.y, sb3.nw.pos.z)
      else
         sb3.log("moving to se safe spot")
         Player:MoveTo(sb3.se.pos.x, sb3.se.pos.y, sb3.se.pos.z)
      end
      KitanoiSettings.avoidingtime = Now() + gPulseTime
   end

   sb3.last_run = Now()
end

return tbl
