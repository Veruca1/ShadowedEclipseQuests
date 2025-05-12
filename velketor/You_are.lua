function event_combat(e)
  if e.joined then
    e.self:Emote("assaulted by a blast of freezing wind and the sound of hissing.");
    eq.spawn2(eq.ChooseRandom(112045,112045,112045,112045), 0, 0, e.self:GetX(), e.self:GetY(),  e.self:GetZ(),  e.self:GetHeading()); -- a_large_crystal_shard (112045) a_crystalline_shard (112045) a_crystal_shard 112045)
    eq.depop_with_timer();
  end
end
