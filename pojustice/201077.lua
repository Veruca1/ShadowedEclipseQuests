-- 7th Hammer Tribunal
-- Tribunal NPC ID: 201077

function event_spawn(e)
    local npc = e.self
    if not npc or npc:IsPet() then return end

    -- Boss-tier stats (no faction, no special abilities)
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

    npc:ModifyNPCStat("str", "1300")
    npc:ModifyNPCStat("sta", "1300")
    npc:ModifyNPCStat("agi", "1300")
    npc:ModifyNPCStat("dex", "1300")
    npc:ModifyNPCStat("wis", "1300")
    npc:ModifyNPCStat("int", "1300")
    npc:ModifyNPCStat("cha", "1000")

    npc:ModifyNPCStat("mr", "450")
    npc:ModifyNPCStat("fr", "450")
    npc:ModifyNPCStat("cr", "450")
    npc:ModifyNPCStat("pr", "450")
    npc:ModifyNPCStat("dr", "450")
    npc:ModifyNPCStat("corruption_resist", "600")
    npc:ModifyNPCStat("physical_resist", "1100")

    local max_hp = npc:GetMaxHP()
    if max_hp > 0 then
        npc:SetHP(max_hp)
    end
end

function event_signal(e)
    if e.signal == 1 then
        e.self:DoAnim(3)
    end
end