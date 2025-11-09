function event_spawn(e)
	-- === Boss Stat Application ===
	e.self:ModifyNPCStat("level", "60");
	e.self:ModifyNPCStat("ac", "18000");
	e.self:ModifyNPCStat("max_hp", "1000000");
	e.self:ModifyNPCStat("hp_regen", "2000");
	e.self:ModifyNPCStat("mana_regen", "10000");
	e.self:ModifyNPCStat("min_hit", "4000");
	e.self:ModifyNPCStat("max_hit", "5500");
	e.self:ModifyNPCStat("atk", "1000");
	e.self:ModifyNPCStat("accuracy", "1000");
	e.self:ModifyNPCStat("avoidance", "50");
	e.self:ModifyNPCStat("heroic_strikethrough", "7");
	e.self:ModifyNPCStat("attack_speed", "100");
	e.self:ModifyNPCStat("slow_mitigation", "70");
	e.self:ModifyNPCStat("aggro", "50");
	e.self:ModifyNPCStat("assist", "1");

	e.self:ModifyNPCStat("str", "900");
	e.self:ModifyNPCStat("sta", "900");
	e.self:ModifyNPCStat("agi", "900");
	e.self:ModifyNPCStat("dex", "900");
	e.self:ModifyNPCStat("wis", "900");
	e.self:ModifyNPCStat("int", "900");
	e.self:ModifyNPCStat("cha", "700");

	e.self:ModifyNPCStat("mr", "200");
	e.self:ModifyNPCStat("fr", "200");
	e.self:ModifyNPCStat("cr", "200");
	e.self:ModifyNPCStat("pr", "200");
	e.self:ModifyNPCStat("dr", "200");
	e.self:ModifyNPCStat("corruption_resist", "200");
	e.self:ModifyNPCStat("physical_resist", "500");

	e.self:ModifyNPCStat("runspeed", "2");
	e.self:ModifyNPCStat("trackable", "1");
	e.self:ModifyNPCStat("see_invis", "1");
	e.self:ModifyNPCStat("see_invis_undead", "1");
	e.self:ModifyNPCStat("see_hide", "1");
	e.self:ModifyNPCStat("see_improved_hide", "1");
	e.self:ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

	local max_hp = e.self:GetMaxHP();
	if max_hp > 0 then
		e.self:SetHP(max_hp);
	end

	-- === Timers ===
	eq.set_timer("depop", 30 * 60 * 1000);
end

function event_combat(e)
	if e.joined then
		eq.set_timer("adds", 45 * 1000);
		eq.set_timer("blind", 12 * 1000);
		eq.set_next_hp_event(50);
	else	
		eq.stop_timer("adds");
	end
end

function event_timer(e)
	if e.timer == "depop" then
		eq.depop_all(110132);
		eq.depop();
	elseif e.timer == "blind" then
		e.self:CastSpell(5597, e.self:GetHateRandom():GetID()); -- Spell: Squid's Ink (DISABLED)
	elseif e.timer == "adds" then
		eq.spawn2(110132, 0, 0, e.self:GetX()-30, e.self:GetY(), e.self:GetZ(), e.self:GetHeading()):AddToHateList(e.self:GetHateRandom(), 1);
		eq.spawn2(110132, 0, 0, e.self:GetX()+30, e.self:GetY(), e.self:GetZ(), e.self:GetHeading()):AddToHateList(e.self:GetHateRandom(), 1);
		eq.spawn2(110132, 0, 0, e.self:GetX()-30, e.self:GetY()-30, e.self:GetZ(), e.self:GetHeading()):AddToHateList(e.self:GetHateRandom(), 1);
		eq.spawn2(110132, 0, 0, e.self:GetX()-30, e.self:GetY()+30, e.self:GetZ(), e.self:GetHeading()):AddToHateList(e.self:GetHateRandom(), 1);
	end
end