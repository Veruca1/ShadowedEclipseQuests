-- ===========================================================
-- Deyid the Twisted (204051)
-- Plane of Nightmare – Shadowed Eclipse Event
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

    -- === Resists ===
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

    -- === Sync HP to new max ===
    e.self:SetHP(e.self:GetMaxHP())
end


-- ===========================================================
-- Combat Logic
-- ===========================================================
function event_combat(e)
    if e.joined then
        eq.set_next_hp_event(90)
        eq.set_timer("OOBcheck", 6 * 1000)
    else
        eq.stop_timer("OOBcheck")
    end
end


-- ===========================================================
-- HP Event Phases
-- ===========================================================
function event_hp(e)
    if (e.hp_event == 90) then
        eq.spawn2(204068,0,0,1125,1162,280,344)
        eq.spawn2(204068,0,0,1191,1033,280,392)
        eq.spawn2(204068,0,0,1071,920,280,474)
        eq.spawn2(204068,0,0,901,939,280,50)
        eq.spawn2(204068,0,0,843,999,283,92)
        eq.spawn2(204068,0,0,786,1160,282,152)
        eq.spawn2(204068,0,0,965,1256,282,262)
        eq.spawn2(204085,0,0,990,908,280,512)
        eq.spawn2(204085,0,0,808,1074,278,116)
        eq.spawn2(204086,0,0,1171,966,280,428)
        eq.spawn2(204086,0,0,1057,1211,281,280)
        eq.get_entity_list():MessageClose(e.self, false, 300, MT.White,
            "A low groaning sound wells up out of the surrounding woods as the rustling of leaves indicate something sinister is manifesting.")
        eq.set_next_hp_event(50)

    elseif (e.hp_event == 50) then
        e.self:Emote("waves his branches about in agitation and the surrounding trees close in.")
        eq.set_next_hp_event(45)

    elseif (e.hp_event == 45) then
        eq.get_entity_list():MessageClose(e.self, false, 300, MT.White,
            "Several of the foreboding trees tear their roots from the ground and move in to aid Deyid.")
        eq.depop_all(204085)
        eq.depop_all(204086)
        eq.spawn2(204087, 0, 0, e.self:GetX()-5, e.self:GetY()+5, e.self:GetZ(), e.self:GetHeading())
        eq.spawn2(204087, 0, 0, e.self:GetX()+5, e.self:GetY()-5, e.self:GetZ(), e.self:GetHeading())
        eq.spawn2(204069, 0, 0, e.self:GetX()+5, e.self:GetY()+5, e.self:GetZ(), e.self:GetHeading())
        eq.spawn2(204069, 0, 0, e.self:GetX()-5, e.self:GetY()-5, e.self:GetZ(), e.self:GetHeading())
    end
end


-- ===========================================================
-- Death
-- ===========================================================
function event_death_complete(e)
    eq.get_entity_list():MessageClose(e.self, false, 300, MT.White,
        "An eerie silence settles onto the forest as Deyid the Twisted slumps over, defeated.")
    eq.depop_all(204068)
    eq.signal(204047, 1)
end


-- ===========================================================
-- Out of Bounds Check
-- ===========================================================
function event_timer(e)
    if (e.timer == "OOBcheck") then
        eq.stop_timer("OOBcheck")
        if (e.self:GetZ() < 250) then
            e.self:GotoBind()
            e.self:WipeHateList()
        else
            eq.set_timer("OOBcheck", 6 * 1000)
        end
    end
end