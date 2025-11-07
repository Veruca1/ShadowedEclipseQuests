-- ===========================================================
-- #The_Terror_Matriarch
-- Boss-tier encounter - spawns random hatchlings every 10s
-- ===========================================================

function event_spawn(e)
    -- === Core Stats ===
    e.self:SetNPCFactionID(623)
    e.self:ModifyNPCStat("level", "65")
    e.self:ModifyNPCStat("ac", "30000")
    e.self:ModifyNPCStat("max_hp", "175000000")
    e.self:ModifyNPCStat("hp_regen", "3000")
    e.self:ModifyNPCStat("min_hit", "50000")
    e.self:ModifyNPCStat("max_hit", "100000")
    e.self:ModifyNPCStat("attack_speed", "38")
    e.self:ModifyNPCStat("atk", "2500")
    e.self:ModifyNPCStat("accuracy", "2000")
    e.self:ModifyNPCStat("slow_mitigation", "90")

    -- === Attributes ===
    e.self:ModifyNPCStat("str", "1200")
    e.self:ModifyNPCStat("sta", "1200")
    e.self:ModifyNPCStat("agi", "1200")
    e.self:ModifyNPCStat("dex", "1200")
    e.self:ModifyNPCStat("wis", "1200")
    e.self:ModifyNPCStat("int", "1200")
    e.self:ModifyNPCStat("cha", "1000")

    -- === Resistances ===
    e.self:ModifyNPCStat("mr", "400")
    e.self:ModifyNPCStat("fr", "400")
    e.self:ModifyNPCStat("cr", "400")
    e.self:ModifyNPCStat("pr", "400")
    e.self:ModifyNPCStat("dr", "400")
    e.self:ModifyNPCStat("corruption", "500")
    e.self:ModifyNPCStat("physical_resist", "1000")

    -- === Special Abilities ===
    -- 2 - Immune to flee
    -- 3 - Immune to mez
    -- 5 - Immune to charm
    -- 7 - Immune to fear
    -- 8 - Immune to stun
    -- 13 - Unsnareable
    -- 14 - Uncharmable
    -- 15 - Immune to pacify
    -- 17 - Immune to disarm
    -- 21 - Immune to spell damage reflection
    e.self:SetSpecialAbility(2, 1)
    e.self:SetSpecialAbility(3, 1)
    e.self:SetSpecialAbility(5, 1)
    e.self:SetSpecialAbility(7, 1)
    e.self:SetSpecialAbility(8, 1)
    e.self:SetSpecialAbility(13, 1)
    e.self:SetSpecialAbility(14, 1)
    e.self:SetSpecialAbility(15, 1)
    e.self:SetSpecialAbility(17, 1)
    e.self:SetSpecialAbility(21, 1)

    -- === Apply Stats ===
    e.self:SetHP(e.self:GetMaxHP())  -- sync current HP to max
end


-- ===========================================================
-- Combat Logic
-- ===========================================================
function event_combat(e)
    if e.joined then
        eq.set_timer("hatchling", 10 * 1000)  -- spawn add every 10 seconds
    else
        eq.stop_timer("hatchling")
    end
end


-- ===========================================================
-- Timers
-- ===========================================================
function event_timer(e)
    if e.timer == "hatchling" then
        -- Randomly spawns one of the hatchlings
        -- 204084 = an_abhorrent_hatchling
        -- 204083 = a_rapacious_hatchling
        -- 204082 = a_voracious_hatchling
        eq.spawn2(eq.ChooseRandom(204084, 204083, 204082), 0, 0,
            e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading())
    end
end