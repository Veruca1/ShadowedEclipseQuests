function event_combat(e)
if e.joined then
eq.spawn2(112045, 0, 0, e.self:GetX(),e.self:GetY(),e.self:GetZ(),0); -- NPC: a_crystalline_shard
eq.depop_with_timer();
end
end
