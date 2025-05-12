function event_combat(e)
if e.joined then
e.self:Emote("on the floor shimmers as a beast made of crystalline ice emerges.");
eq.spawn2(eq.ChooseRandom(112045,112045,112045,112045), 0, 0, e.self:GetX(), e.self:GetY(),  e.self:GetZ(),  e.self:GetHeading()); -- a_large_crystal_shard (112045) a_crystalline_shard (112045) a_crystal_shard (112045)
eq.depop_with_timer();
end
end
