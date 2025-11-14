-- ===============================================================
-- Plane of Justice — General Mini-Boss Template
-- ===============================================================
-- - Applies standardized mini-boss stats across PoJustice.
-- - No event signals, qglobals, or controller dependencies.
-- - Uses fixed “boss-tier” stats (from Shadowed Eclipse baseline).
-- - Automatically sets PoJustice faction and ensures consistency.
-- - For minor named or sub‑boss encounters (not raid controllers).
-- ===============================================================
-- Do NOT use this script for:
-- - Trial controllers (e.g. Event_Execution_Control)
-- - Tribunal NPCs or progression gatekeepers
-- - Zone bosses or global scripted events
-- ===============================================================

function event_spawn(e)
    local npc = e.self
    if not npc or npc:IsPet() then return end

    npc:SetNPCFactionID(623)
    npc:ModifyNPCStat("level", "66")

    -- Boss-tier stats
    npc:ModifyNPCStat("ac", "35000")
    npc:ModifyNPCStat("max_hp", "200000000")
    npc:ModifyNPCStat("hp_regen", "4000")
    npc:ModifyNPCStat("mana_regen", "10000")
    npc:ModifyNPCStat("min_hit", "60000")
    npc:ModifyNPCStat("max_hit", "110000")
    npc:ModifyNPCStat("atk", "2700")
    npc:ModifyNPCStat("accuracy", "2200")
    npc:ModifyNPCStat("avoidance", "75")
    npc:ModifyNPCStat("heroic_strikethrough", "40")
    npc:ModifyNPCStat("attack_delay", "6")
    npc:ModifyNPCStat("slow_mitigation", "95")
    npc:ModifyNPCStat("aggro", "100")
    npc:ModifyNPCStat("assist", "1")

    -- Attributes
    npc:ModifyNPCStat("str", "1300")
    npc:ModifyNPCStat("sta", "1300")
    npc:ModifyNPCStat("agi", "1300")
    npc:ModifyNPCStat("dex", "1300")
    npc:ModifyNPCStat("wis", "1300")
    npc:ModifyNPCStat("int", "1300")
    npc:ModifyNPCStat("cha", "1000")

    -- Resists
    npc:ModifyNPCStat("mr", "450")
    npc:ModifyNPCStat("fr", "450")
    npc:ModifyNPCStat("cr", "450")
    npc:ModifyNPCStat("pr", "450")
    npc:ModifyNPCStat("dr", "450")
    npc:ModifyNPCStat("corruption_resist", "600")
    npc:ModifyNPCStat("physical_resist", "1100")

    -- Special abilities
    npc:ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1")

    -- Force HP to max
    local max_hp = npc:GetMaxHP()
    if max_hp > 0 then
        npc:SetHP(max_hp)
    end
end

function event_death_complete(e)
    eq.signal(201449, 1) -- NPC: #Event_Lashing_Control
end