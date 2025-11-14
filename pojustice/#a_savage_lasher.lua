-- ===============================================================
-- Plane of Justice — Trash Mob Template
-- ===============================================================
-- - Applies standard trash stats for Plane of Justice mobs.
-- - Retains original behavior (aggroing nearby prisoner).
-- ===============================================================

function event_spawn(e)
    local npc = e.self

    -- Apply Plane of Justice trash stats
    if not npc:IsPet() then
        npc:SetNPCFactionID(623)
        npc:ModifyNPCStat("level", "63")
        npc:ModifyNPCStat("ac", "22000")
        npc:ModifyNPCStat("max_hp", "20000000")
        npc:ModifyNPCStat("hp_regen", "1000")
        npc:ModifyNPCStat("mana_regen", "10000")
        npc:ModifyNPCStat("min_hit", "45000")
        npc:ModifyNPCStat("max_hit", "58000")
        npc:ModifyNPCStat("atk", "2400")
        npc:ModifyNPCStat("accuracy", "1900")
        npc:ModifyNPCStat("avoidance", "50")
        npc:ModifyNPCStat("heroic_strikethrough", "30")
        npc:ModifyNPCStat("attack_delay", "7")
        npc:ModifyNPCStat("slow_mitigation", "80")
        npc:ModifyNPCStat("aggro", "100")
        npc:ModifyNPCStat("assist", "1")
        npc:ModifyNPCStat("str", "1050")
        npc:ModifyNPCStat("sta", "1050")
        npc:ModifyNPCStat("agi", "1050")
        npc:ModifyNPCStat("dex", "1050")
        npc:ModifyNPCStat("wis", "1050")
        npc:ModifyNPCStat("int", "1050")
        npc:ModifyNPCStat("cha", "850")
        npc:ModifyNPCStat("mr", "320")
        npc:ModifyNPCStat("fr", "320")
        npc:ModifyNPCStat("cr", "320")
        npc:ModifyNPCStat("pr", "320")
        npc:ModifyNPCStat("dr", "320")
        npc:ModifyNPCStat("corruption_resist", "350")
        npc:ModifyNPCStat("physical_resist", "850")
        npc:ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1")

        local max_hp = npc:GetMaxHP()
        if max_hp > 0 then
            npc:SetHP(max_hp)
        end
    end

    -- Aggro the closest prisoner (201463) a tormented prisoner
    local target = eq.get_entity_list():GetMobByNpcTypeID(201463)
    if target.valid then
        if target:CalculateDistance(npc:GetX(), npc:GetY(), npc:GetZ()) < 200 then
            npc:AddToHateList(target, 1)
        end
    end
end