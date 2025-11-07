-- ===========================================================
-- #The_Painwrack_Hobgoblin (Boss)
-- Plane of Nightmare - Boss-tier stat template
-- ===========================================================

function event_spawn(e)
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

    e.self:ModifyNPCStat("str", "1200")
    e.self:ModifyNPCStat("sta", "1200")
    e.self:ModifyNPCStat("agi", "1200")
    e.self:ModifyNPCStat("dex", "1200")
    e.self:ModifyNPCStat("wis", "1200")
    e.self:ModifyNPCStat("int", "1200")
    e.self:ModifyNPCStat("cha", "1000")

    e.self:ModifyNPCStat("mr", "400")
    e.self:ModifyNPCStat("fr", "400")
    e.self:ModifyNPCStat("cr", "400")
    e.self:ModifyNPCStat("pr", "400")
    e.self:ModifyNPCStat("dr", "400")
    e.self:ModifyNPCStat("corruption", "500")
    e.self:ModifyNPCStat("physical_resist", "1000")

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

    e.self:SetHP(e.self:GetMaxHP())

    eq.zone_emote(MT.Yellow, "The Painwrack Hobgoblin howls in anguish, its chains rattling as pain becomes fury!")
end


function event_death_complete(e)
    eq.unique_spawn(204090, 0, 0, 1679, 4076, 35, 330)
end