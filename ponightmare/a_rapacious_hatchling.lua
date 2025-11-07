-- ===========================================================
-- a_rapacious_hatchling
-- Standard elite add template (non-boss version)
-- ===========================================================

function event_spawn(e)
    -- === Faction ===
    e.self:SetNPCFactionID(623)

    -- === Core Stats ===
    e.self:ModifyNPCStat("level", "62")
    e.self:ModifyNPCStat("ac", "20000")
    e.self:ModifyNPCStat("max_hp", "15000000")
    e.self:ModifyNPCStat("hp_regen", "800")
    e.self:ModifyNPCStat("min_hit", "44000")
    e.self:ModifyNPCStat("max_hit", "55000")
    e.self:ModifyNPCStat("attack_speed", "30")
    e.self:ModifyNPCStat("atk", "2500")
    e.self:ModifyNPCStat("accuracy", "1800")
    e.self:ModifyNPCStat("slow_mitigation", "80")
    e.self:ModifyNPCStat("aggro", "55")
    e.self:ModifyNPCStat("assist", "1")

    -- === Attributes ===
    e.self:ModifyNPCStat("str", "1000")
    e.self:ModifyNPCStat("sta", "1000")
    e.self:ModifyNPCStat("agi", "1000")
    e.self:ModifyNPCStat("dex", "1000")
    e.self:ModifyNPCStat("wis", "1000")
    e.self:ModifyNPCStat("int", "1000")
    e.self:ModifyNPCStat("cha", "800")

    -- === Resistances ===
    e.self:ModifyNPCStat("mr", "300")
    e.self:ModifyNPCStat("fr", "300")
    e.self:ModifyNPCStat("cr", "300")
    e.self:ModifyNPCStat("pr", "300")
    e.self:ModifyNPCStat("dr", "300")
    e.self:ModifyNPCStat("corruption", "300")
    e.self:ModifyNPCStat("physical_resist", "800")

    -- === Special Abilities ===
    -- 3 - immune to mez
    -- 5 - immune to charm
    -- 7 - immune to fear
    -- 8 - immune to stun
    -- 9 - immune to snare
    -- 10 - immune to root
    -- 14 - uncharmable
    e.self:SetSpecialAbility(3, 1)
    e.self:SetSpecialAbility(5, 1)
    e.self:SetSpecialAbility(7, 1)
    e.self:SetSpecialAbility(8, 1)
    e.self:SetSpecialAbility(9, 1)
    e.self:SetSpecialAbility(10, 1)
    e.self:SetSpecialAbility(14, 1)

    -- === Apply Stats ===
    e.self:SetHP(e.self:GetMaxHP())  -- Match health to new Max HP

    -- === Timers ===
    eq.set_timer("depop", 300 * 1000)  -- 5-minute auto-despawn
end


function event_combat(e)
    if e.joined then
        if not eq.is_paused_timer("depop") then
            eq.pause_timer("depop")
        end
    else
        eq.resume_timer("depop")
    end
end


function event_timer(e)
    if e.timer == "depop" then
        eq.depop()
    end
end