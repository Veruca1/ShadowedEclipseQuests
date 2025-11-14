-- ===============================================================
-- #Yurae_Zhaleem — Boss Stat Template (PoJustice Trial: Stoning)
-- ===============================================================
-- - Applies standardized boss-tier stats for Plane of Justice events.
-- - Adds dynamic scaling based on raid size.
-- - Sends a signal to the controller upon death.
-- ===============================================================

local scaled_spawn = false

function event_spawn(e)
    local npc = e.self
    if not npc or npc:IsPet() or scaled_spawn then return end

    -- Static base boss stats
    npc:SetNPCFactionID(623)
    npc:ModifyNPCStat("level", "66")

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

    -- Apply raid scaling (Lua equivalent of plugin::RaidScaling)
    eq.call_plugin("RaidScaling", eq.get_entity_list(), npc)

    -- Finalize HP
    local max_hp = npc:GetMaxHP()
    if max_hp > 0 then
        npc:SetHP(max_hp)
    end

    scaled_spawn = true
end

function event_death_complete(e)
    -- Signal the controller that the boss has died
    eq.signal(201451, 1) -- NPC: #Event_Stoning_Control
end