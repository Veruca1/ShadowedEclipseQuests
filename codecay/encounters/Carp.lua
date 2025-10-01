local carp_add = 0
local carp_fake = false

function Carp_Combat(e)
	if e.joined and not carp_fake then
		eq.debug("Carprin aggro: Spawning adds")
		eq.unique_spawn(200037, 0, 0, 385.41, -127.15, -60.25, 384.3)
		eq.unique_spawn(200036, 0, 0, 393.25, -107.67, -60.25, 391.3)
		eq.unique_spawn(200038, 0, 0, 385.17, -98.43, -60.25, 384.8)
		eq.set_next_hp_event(90)
		carp_fake = true
	end
end

function Carp_HP(e)
	if e.hp_event == 90 then
		eq.debug("Carprin reached 90% - setting invulnerability")
		e.self:SetSpecialAbility(SpecialAbility.immune_magic, 1)
		e.self:SetSpecialAbility(SpecialAbility.immune_melee, 1)
	end
end

function Add_Death(e)
	local el = eq.get_entity_list()
	local npc_id = e.self:GetNPCTypeID()
	local npc_name = e.self:GetCleanName()
	carp_add = carp_add + 1
	eq.debug("[Add_Death] NPC " .. npc_id .. " (" .. npc_name .. ") died. Total adds killed: " .. carp_add)

	if carp_add == 3 and carp_fake and el:IsMobSpawnedByNpcTypeID(200007) then
		eq.debug("==> 3 Carprin adds dead. Respawning real Carprin")
		eq.depop_all(200007)
		eq.spawn2(200007, 0, 0, 384.00, -113.00, -53.78, 386.0):AddToHateList(e.self:GetHateRandom(), 1)
	end

	if carp_add == 5 then
		eq.debug("==> 5 adds total dead (Carprin adds + Vindor + Raex). Spawning REAL High Priest.")
		eq.depop_all(200067)
		eq.spawn2(200032, 0, 0, 306.97, 314.78, -70.25, 259.0)
		carp_add = 0
	end
end

function Carp_Death(e)
	eq.debug("Carprin died - spawning Avhi + reavers")
	eq.spawn2(200035, 0, 0, 402.43, 141.60, -60.25, 259.8)
	eq.spawn2(200066, 0, 0, 401.79, 125.19, -60.25, 259.8):AddToHateList(e.self:GetHateRandom(), 1)
	eq.spawn2(200066, 0, 0, 413.41, 142.57, -60.25, 259.0):AddToHateList(e.self:GetHateRandom(), 1)
	eq.spawn2(200066, 0, 0, 403.46, 157.51, -60.25, 260.5):AddToHateList(e.self:GetHateRandom(), 1)
	eq.spawn2(200066, 0, 0, 392.19, 142.16, -60.25, 260.5):AddToHateList(e.self:GetHateRandom(), 1)
end

function Avhi_Slay(e)
	eq.debug("Avhi slayed a player - spawning 4 more reavers")
	for i = 1, 4 do
		eq.spawn2(200066, 0, 0, 400 + i, 140 + i, -60.25, 259 + i):AddToHateList(e.self:GetHateRandom(), 1)
	end
end

function Add_Slay(e)
	eq.debug("A reaver slayed a player - spawning 4 more reavers")
	for i = 1, 4 do
		eq.spawn2(200066, 0, 0, 390 + i, 130 + i, -60.25, 259 + i):AddToHateList(e.self:GetHateRandom(), 1)
	end
end

function Avhi_Spawn(e)
	eq.debug("Avhi spawned - setting 1 hour despawn timer")
	eq.set_timer("Avhi", 3600000)
end

function Bishop_Spawn(e)
	eq.debug("Bishop spawned - setting 1 hour despawn timer")
	eq.set_timer("Bishop", 3600000)
end

function Bishop_Timer(e)
	if e.timer == "Bishop" then
		eq.debug("Bishop timer expired - depopping")
		eq.stop_timer("Bishop")
		eq.depop_all(200039)
	end
end

function Vindor_Spawn(e)
	eq.debug("Vindor spawned - 1 hour despawn timer started")
	eq.set_timer("Vindor", 3600000)
end

function Vindor_Timer(e)
	if e.timer == "Vindor" then
		eq.debug("Vindor timer expired - depopping")
		eq.stop_timer("Vindor")
		eq.depop_all(200034)
	end
end

function Raex_Spawn(e)
	eq.debug("Raex spawned - 1 hour despawn timer started")
	eq.set_timer("Raex", 3600000)
end

function Raex_Timer(e)
	if e.timer == "Raex" then
		eq.debug("Raex timer expired - depopping")
		eq.stop_timer("Raex")
		eq.depop_all(200033)
	end
end

function HP_Spawn(e)
	eq.debug("REAL High Priest (200032) spawned - 1 hour despawn timer started")
	eq.set_timer("HP", 3600000)
end

function HP_Timer(e)
	if e.timer == "HP" then
		eq.debug("REAL High Priest timer expired - depopping")
		eq.stop_timer("HP")
		eq.depop_all(200032)
	end
end

function Avhi_Timer(e)
	if e.timer == "Avhi" then
		eq.debug("Avhi timer expired - depopping self and reavers")
		eq.stop_timer("Avhi")
		eq.depop_all(200035)
		eq.depop_all(200066)
	end
end

function Avhi_Death(e)
	eq.debug("Avhi died - spawning Bishop, depopping adds")
	eq.spawn2(200039, 0, 0, 261.54, 82.12, -70.25, 4.5)
	eq.depop_all(200066)
end

function Bishop_Death(e)
	eq.debug("Bishop died - spawning fake HP and both adds")
	eq.spawn2(200067, 0, 0, 306.97, 314.78, -70.25, 259.0)
	eq.spawn2(200034, 33, 0, 325, 325, -71.5, 277.2)
	eq.spawn2(200033, 34, 0, 290, 325, -71.5, 277.2)
end

function HP_Death(e)
	eq.debug("REAL High Priest died - spawning Tarkil")
	eq.spawn2(200040, 0, 0, 309.17, 332.99, -70.25, 265.5)
end

function event_encounter_load(e)
	eq.register_npc_event('Carp', Event.combat, 			200007, Carp_Combat)
	eq.register_npc_event('Carp', Event.hp,					200007, Carp_HP)
	eq.register_npc_event('Carp', Event.death_complete,		200007, Carp_Death)

	eq.register_npc_event('Carp', Event.death_complete, 	200032, HP_Death)
	eq.register_npc_event('Carp', Event.spawn,				200032, HP_Spawn)
	eq.register_npc_event('Carp', Event.timer,				200032, HP_Timer)

	eq.register_npc_event('Carp', Event.spawn,				200035, Avhi_Spawn)
	eq.register_npc_event('Carp', Event.timer,				200035, Avhi_Timer)
	eq.register_npc_event('Carp', Event.death_complete, 	200035, Avhi_Death)

	eq.register_npc_event('Carp', Event.spawn,				200039, Bishop_Spawn)
	eq.register_npc_event('Carp', Event.timer,				200039, Bishop_Timer)
	eq.register_npc_event('Carp', Event.death_complete,     200039, Bishop_Death)

	eq.register_npc_event('Carp', Event.spawn,				200034, Vindor_Spawn)
	eq.register_npc_event('Carp', Event.timer,				200034, Vindor_Timer)

	eq.register_npc_event('Carp', Event.spawn,				200033, Raex_Spawn)
	eq.register_npc_event('Carp', Event.timer,				200033, Raex_Timer)

	eq.register_npc_event('Carp', Event.slay,				200035, Avhi_Slay)
	eq.register_npc_event('Carp', Event.slay,				200066, Add_Slay)

	-- Register all 5 for Add_Death tracking
	eq.register_npc_event('Carp', Event.death_complete, 200037, Add_Death)
	eq.register_npc_event('Carp', Event.death_complete, 200036, Add_Death)
	eq.register_npc_event('Carp', Event.death_complete, 200038, Add_Death)
	eq.register_npc_event('Carp', Event.death_complete, 200034, Add_Death)
	eq.register_npc_event('Carp', Event.death_complete, 200033, Add_Death)
end