-- ===========================================================
-- Lord Vyemm (2001735)
-- Temple of Veeshan — Shadowed Eclipse Raid Boss
-- - Applies custom ToV boss baseline stats
-- - Integrates RaidScaling for adaptive raid power
-- - Includes Aaryonar assist behavior
-- ===========================================================

function event_spawn(e)
    local npc = e.self
    if not npc.valid then return end

    -- === Baseline ToV Boss Stats ===
    npc:SetNPCFactionID(623)
    npc:ModifyNPCStat("level", "61")
    npc:ModifyNPCStat("ac", "20000")
    npc:ModifyNPCStat("max_hp", "3000000")
    npc:ModifyNPCStat("hp_regen", "2500")
    npc:ModifyNPCStat("mana_regen", "10000")
    npc:ModifyNPCStat("min_hit", "8750")
    npc:ModifyNPCStat("max_hit", "11000")
    npc:ModifyNPCStat("atk", "1200")
    npc:ModifyNPCStat("accuracy", "1100")
    npc:ModifyNPCStat("avoidance", "50")
    npc:ModifyNPCStat("heroic_strikethrough", "8")
    npc:ModifyNPCStat("attack_delay", "6")
    npc:ModifyNPCStat("slow_mitigation", "75")
    npc:ModifyNPCStat("aggro", "55")
    npc:ModifyNPCStat("assist", "1")

    -- === Attributes & Resists ===
    npc:ModifyNPCStat("str", "950")
    npc:ModifyNPCStat("sta", "950")
    npc:ModifyNPCStat("agi", "950")
    npc:ModifyNPCStat("dex", "950")
    npc:ModifyNPCStat("wis", "950")
    npc:ModifyNPCStat("int", "950")
    npc:ModifyNPCStat("cha", "750")

    npc:ModifyNPCStat("mr", "220")
    npc:ModifyNPCStat("fr", "220")
    npc:ModifyNPCStat("cr", "220")
    npc:ModifyNPCStat("pr", "220")
    npc:ModifyNPCStat("dr", "220")
    npc:ModifyNPCStat("corruption_resist", "220")
    npc:ModifyNPCStat("physical_resist", "550")

    -- === Immunities and Behavior ===
    npc:ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1")
    npc:ModifyNPCStat("runspeed", "2")
    npc:ModifyNPCStat("trackable", "1")
    npc:ModifyNPCStat("see_invis", "1")
    npc:ModifyNPCStat("see_invis_undead", "1")
    npc:ModifyNPCStat("see_hide", "1")
    npc:ModifyNPCStat("see_improved_hide", "1")

    -- === Raid Scaling Integration ===
    plugin.RaidScaling(eq.get_entity_list(), npc)

    -- === Set HP to Max ===
    local max_hp = npc:GetMaxHP()
    if max_hp > 0 then
        npc:SetHP(max_hp)
    end
end

function event_combat(e)
    if e.joined then
        eq.set_timer("help", 5000)
        HelpMe(e)
    else
        eq.stop_timer("help")
    end
end

function event_timer(e)
    if e.timer == "help" then
        HelpMe(e)
    end
end

function HelpMe(e)
    local aaryonar = eq.get_entity_list():GetMobByNpcTypeID(124010)
    if aaryonar.valid then
        aaryonar:CastToNPC():MoveTo(e.self:GetX(), e.self:GetY(), e.self:GetZ(), 0, false)
    end
end