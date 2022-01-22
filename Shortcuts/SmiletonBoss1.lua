local tbl = function()
   if SmiletonBoss1 == nil then
      SmiletonBoss1 = {
         revision = 6,
         buff_smiley_face = 2763,
         buff_frowny_face = 2764,
         channel_frowny_face = 26422,
         channel_smiley_face = 26423,
         channel_mixed_feelings = 26424,
         channel_off_my_lawn = 27742,
         entity_face = "contentid=10331",
         entity_small_face = "contentid=10332",
      }
      function SmiletonBoss1.log(str)
         d("[SmiletonBoss1_r" .. SmiletonBoss1.revision .. "] " .. tostring(str))
      end
   end

   local sb1 = SmiletonBoss1
   local t, p = TensorCore.mGetTarget(), TensorCore.mGetPlayer()

   if ((TimeSince(sb1.last_run or 0) < gPulseTime) or (t and t.contentid ~= 10331) or (not p.incombat)) then
      return
   end

   local mixed_feelings_channeling, _ = TensorCore.isAnyEntityCasting(sb1.channel_mixed_feelings, sb1.entity_face)
   local lawn_channeling, lawn_caster = TensorCore.isAnyEntityCasting(sb1.channel_off_my_lawn, sb1.entity_face)
   local smiley_channeling, smiley_caster =
      TensorCore.isAnyEntityCasting(sb1.channel_smiley_face, sb1.entity_small_face)
   local frowny_channeling, frowny_caster =
      TensorCore.isAnyEntityCasting(sb1.channel_frowny_face, sb1.entity_small_face)
   local knockback_z_adjust = 0
   local is_smiley = TensorCore.hasBuff(p.id, sb1.buff_smiley_face)
   local is_frowny = TensorCore.hasBuff(p.id, sb1.buff_frowny_face)

   if (mixed_feelings_channeling) then
      if ((is_smiley or is_frowny) and Now() > KitanoiSettings.avoidingtime) then
         sb1.log("not avoiding mixed feelings because it's smiley/frowny time")
         KitanoiSettings.DFIndexedExcludeAvoid[sb1.channel_mixed_feelings] = true
      else
         sb1.log("avoiding mixed feelings")
         KitanoiSettings.DFIndexedExcludeAvoid[sb1.channel_mixed_feelings] = nil
      end

      if (lawn_channeling) then
         if (lawn_caster.pos.z == -5) then
            sb1.log("knock toward Face (north)")
            knockback_z_adjust = 8
         elseif (lawn_caster.pos.z == -33.5) then
            sb1.log("knock away from Face (south)")
            knockback_z_adjust = -8
         else
            sb1.log("unknown knockback pos")
         end
      end -- off my lawn

      if (is_smiley) then
         sb1.log("has buff smiley face")
         if (table.valid(frowny_caster)) then
            sb1.log("moving to frowny face")
            Player:MoveTo(p.pos.x, p.pos.y, frowny_caster.pos.z + knockback_z_adjust)
            KitanoiSettings.avoidingtime = Now() + gPulseTime + (knockback_z_adjust == 0 and 0 or 2000)
         else
            sb1.log("invalid table frowny casters")
         end
      end -- smiley face

      if (is_frowny) then
         sb1.log("has buff frowny face")
         if (table.valid(smiley_caster)) then
            sb1.log("moving to smiley face")
            Player:MoveTo(p.pos.x, p.pos.y, smiley_caster.pos.z + knockback_z_adjust)
            KitanoiSettings.avoidingtime = Now() + gPulseTime + (knockback_z_adjust == 0 and 0 or 2000)
         else
            sb1.log("invalid table smiley casters")
         end
      end -- frowny face

   end -- mixed feelings

   sb1.last_run = Now()
end

return tbl
