local tbl = function()
   if SmiletonBoss1 == nil then
      SmiletonBoss1 = {
         buff_smiley_face = 2763,
         buff_frowny_face = 2764,
         channel_frowny_face = 26422,
         channel_smiley_face = 26423,
         channel_mixed_feelings = 26424,
         channel_off_my_lawn = 27742,
         entity_face = "contentid=10331,nearest",
         entity_small_face = "contentid=10332,nearest",
      }
   end

   local t, p = TensorCore.mGetTarget(), TensorCore.mGetPlayer()

   if (t and t.contentid ~= 10331 or not p.incombat) then
      return
   end

   local sb1 = SmiletonBoss1

   local mixed_feelings_channeling, _ = TensorCore.isAnyEntityCasting(sb1.channel_mixed_feelings, sb1.entity_face)
   local lawn_channeling, lawn_caster = TensorCore.isAnyEntityCasting(sb1.channel_off_my_lawn, sb1.entity_face)
   local smiley_channeling, smiley_caster =
      TensorCore.isAnyEntityCasting(sb1.channel_smiley_face, sb1.entity_small_face)
   local frowny_channeling, frowny_caster =
      TensorCore.isAnyEntityCasting(sb1.channel_frowny_face, sb1.entity_small_face)
   local knockback_z_adjust = 0

   if (mixed_feelings_channeling) then
      d("[SmiletonBoss1] mixed feelings")
      if (lawn_channeling) then
         if (lawn_caster.pos.z == -5) then
            d("[SmiletonBoss1] knock toward Face (north)")
            knockback_z_adjust = 8
         elseif (lawn_caster.pos.z == -33.5) then
            d("[SmiletonBoss1] knock away from Face (south)")
            knockback_z_adjust = -8
         else
            d("[SmiletonBoss1] unknown knockback pos")
         end
      end -- off my lawn

      if (TensorCore.hasBuff(p.id, sb1.buff_smiley_face)) then
         d("[SmiletonBoss1] has buff smiley face")
         if (table.valid(frowny_caster)) then
            d("[SmiletonBoss1] moving to frowny face")
            Player:MoveTo(p.pos.x, p.pos.y, frowny_caster.pos.z + knockback_z_adjust)
            KitanoiSettings.avoidingtime = Now() + (knockback_z_adjust == 0 and 0 or 2000)
         else
            d("[SmiletonBoss1] invalid table frowny casters")
         end
      end -- smiley face

      if (TensorCore.hasBuff(p.id, sb1.buff_frowny_face)) then
         d("[SmiletonBoss1] has buff frowny face")
         if (table.valid(smiley_caster)) then
            d("[SmiletonBoss1] moving to smiley face")
            Player:MoveTo(p.pos.x, p.pos.y, smiley_caster.pos.z + knockback_z_adjust)
            KitanoiSettings.avoidingtime = Now() + (knockback_z_adjust == 0 and 0 or 2000)
         else
            d("[SmiletonBoss1] invalid table smiley casters")
         end
      end -- frowny face

   end -- mixed feelings

end

return tbl
