--scarlet\The_Gem_Guardian.lua NPC ID 175307
--Gem Guardian encounter trigger with cooldown and shout feedback

function event_spawn(e)
	eq.set_timer("delay", 2000);
end

function event_timer(e)
	eq.stop_timer("delay");
	eq.set_proximity(e.self:GetX()-18, e.self:GetX()+18, e.self:GetY()-18, e.self:GetY()+18, -999999, 999999, true);
	eq.enable_proximity_say();
end

function event_proximity_say(e)
	if e.message:findi("sun") then
		local char_id = e.other:CharacterID();
		local key = "scarlet_boss_" .. char_id;
		local timestamp_raw = eq.get_data(key);
		local now = os.time();
		local timestamp = tonumber(timestamp_raw) or 0;

		if timestamp < now then
			-- Cooldown expired — proceed
			eq.zone_emote(MT.Yellow, "A voice booms from the center of the cauldron. The gems were sacred, important to our survival, you shall now burn in the sun.");
			eq.spawn2(175306, 525410, 0, -334.12, -3.41, -37.06, 20); -- NPC: Elite_Sun_Revenant
			eq.set_data(key, tostring(now + 600)); -- Set 10-minute cooldown
			eq.depop_with_timer();
		else
			local remaining = timestamp - now;
			local minutes = math.floor(remaining / 60);
			local seconds = remaining % 60;
			e.self:Shout(string.format("The power has already been disturbed. You must wait %d minute(s) and %02d second(s) before invoking it again!", minutes, seconds));
		end
	end
end