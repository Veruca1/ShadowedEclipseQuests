-- ===========================================================
-- Wel`Wnas (124092)
-- Temple of Veeshan — Shadowed Eclipse Trash Mob
-- - Applies ToV trash baseline stats
-- - Scaling handled globally by default.pl
-- - Aggros Lady Mirenilla (124077) and Gra`Vloren (124091) when engaged
-- ===========================================================

function event_spawn(e)
    local npc = e.self
    if not npc.valid then return end

    -- === Baseline ToV Trash Stats ===
    npc:SetNPCFactionID(623)
    npc:ModifyNPCStat("level", "56")
    npc:ModifyNPCStat("ac", "9500")
    npc:ModifyNPCStat("max_hp", "500000")
    npc:ModifyNPCStat("hp_regen", "700")
    npc:ModifyNPCStat("mana_regen", "10000")
    npc:ModifyNPCStat("min_hit", "6500")
    npc:ModifyNPCStat("max_hit", "8000")
    npc:ModifyNPCStat("atk", "850")
    npc:ModifyNPCStat("accuracy", "850")
    npc:ModifyNPCStat("avoidance", "50")
    npc:ModifyNPCStat("heroic_strikethrough", "4")
    npc:ModifyNPCStat("attack_delay", "7")
    npc:ModifyNPCStat("slow_mitigation", "60")
    npc:ModifyNPCStat("aggro", "45")
    npc:ModifyNPCStat("assist", "1")

    npc:ModifyNPCStat("str", "750")
    npc:ModifyNPCStat("sta", "750")
    npc:ModifyNPCStat("agi", "750")
    npc:ModifyNPCStat("dex", "750")
    npc:ModifyNPCStat("wis", "750")
    npc:ModifyNPCStat("int", "750")
    npc:ModifyNPCStat("cha", "550")

    npc:ModifyNPCStat("mr", "160")
    npc:ModifyNPCStat("fr", "160")
    npc:ModifyNPCStat("cr", "160")
    npc:ModifyNPCStat("pr", "160")
    npc:ModifyNPCStat("dr", "160")
    npc:ModifyNPCStat("corruption_resist", "130")
    npc:ModifyNPCStat("physical_resist", "320")

    npc:ModifyNPCStat("special_abilities", "3,1^5,1^7,1")
    npc:ModifyNPCStat("runspeed", "2")
    npc:ModifyNPCStat("trackable", "1")
    npc:ModifyNPCStat("see_invis", "1")
    npc:ModifyNPCStat("see_invis_undead", "1")
    npc:ModifyNPCStat("see_hide", "1")
    npc:ModifyNPCStat("see_improved_hide", "1")

    -- === Set HP to Max ===
    local max_hp = npc:GetMaxHP()
    if max_hp > 0 then
        npc:SetHP(max_hp)
    end
end

function event_combat(e)
    if e.joined then
        local entity_list = eq.get_entity_list()
        -- Aggro Lady Mirenilla (124077) and Gra`Vloren (124091) if up
        local npc_table = {124077, 124091}
        for _, id in pairs(npc_table) do
            local mob = entity_list:GetMobByNpcTypeID(id)
            if mob.valid then
                mob:AddToHateList(e.other, 1)
            end
        end
    end
end