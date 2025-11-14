-- ===========================================================
-- Salczek_the_Fleshgrinder.lua — Plane of Torment
-- ===========================================================

function event_spawn(e)
    -- Flag gating check
    e.self:SetInvul(true)
    eq.set_timer("flag_check", 5000)

    -- Apply baseline boss stats and scaling manually (mirroring plugin behavior)
    e.self:ModifyNPCStat("level", "66")
    e.self:ModifyNPCStat("ac", "35000")
    e.self:ModifyNPCStat("max_hp", "202000000")  -- 200m + 1% PoTorment bonus
    e.self:ModifyNPCStat("hp_regen", "4000")
    e.self:ModifyNPCStat("mana_regen", "10000")
    e.self:ModifyNPCStat("min_hit", "60600")     -- 60k + 1%
    e.self:ModifyNPCStat("max_hit", "111100")    -- 110k + 1%
    e.self:ModifyNPCStat("atk", "2700")
    e.self:ModifyNPCStat("accuracy", "2200")
    e.self:ModifyNPCStat("avoidance", "50")
    e.self:ModifyNPCStat("heroic_strikethrough", "40")
    e.self:ModifyNPCStat("attack_delay", "6")
    e.self:ModifyNPCStat("slow_mitigation", "95")
    e.self:ModifyNPCStat("aggro", "100")
    e.self:ModifyNPCStat("assist", "1")

    -- Primary stats
    local stats = { "str", "sta", "agi", "dex", "wis", "int", "cha" }
    local stat_val = { str=1300, sta=1300, agi=1300, dex=1300, wis=1300, int=1300, cha=1000 }
    for _, stat in ipairs(stats) do
        e.self:ModifyNPCStat(stat, tostring(stat_val[stat]))
    end

    -- Resists
    local resists = { "mr", "fr", "cr", "pr", "dr" }
    for _, res in ipairs(resists) do
        e.self:ModifyNPCStat(res, "450")
    end
    e.self:ModifyNPCStat("corruption_resist", "600")
    e.self:ModifyNPCStat("physical_resist", "1100")

    -- Special Abilities
    e.self:ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1")

    -- Ensure full health at spawn
    e.self:SetHP(e.self:GetMaxHP())

    -- Start rampage phase tracking
    eq.set_next_hp_event(40)
end

function event_timer(e)
    if e.timer == "flag_check" then
        eq.stop_timer("flag_check")
        local clients = eq.get_entity_list():GetClientList()
        if clients then
            for c in clients.entries do
                local client = c:CastToClient()
                local cid = client:CharacterID()
                local flag = eq.get_data("potor_saryrn_key_complete_" .. cid)
                if flag and tonumber(flag) == 1 then
                    e.self:SetInvul(false)
                    break
                end
            end
        end
    elseif e.timer == 'reset' then
        eq.set_next_hp_event(40)
        e.self:SetSpecialAbility(SpecialAbility.area_rampage, 0)
    end
end

function event_hp(e)
    if e.hp_event == 40 then
        e.self:SetSpecialAbility(SpecialAbility.area_rampage, 1)
        e.self:SetSpecialAbilityParam(SpecialAbility.area_rampage, 0, 10)
        eq.set_next_hp_event(20)
    elseif e.hp_event == 20 then
        e.self:SetSpecialAbilityParam(SpecialAbility.area_rampage, 0, 35)
    end
end

function event_combat(e)
    if e.joined then
        eq.stop_timer('reset')
    else
        eq.set_timer('reset', 300 * 1000)  -- 5 minutes
    end
end