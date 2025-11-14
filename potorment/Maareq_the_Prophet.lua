-- ===========================================================
-- Maareq_the_Prophet.lua — Plane of Torment
-- ===========================================================
-- Re-written to .lua and corrected by ##Drogerin##
-- Adds spawn stat scaling and full boss logic for Maareq.
-- ===========================================================

local counter = 0
local heal = 0

function event_spawn(e)
    -- === FLAG GATING ADDED HERE ===
    e.self:SetInvul(true)
    eq.set_timer("flag_check", 5000)
    -- ===============================

    -- Apply baseline boss stats and scaling manually (mirroring plugin behavior)
    e.self:ModifyNPCStat("ac", "35000")
    e.self:ModifyNPCStat("level", "66")
    e.self:ModifyNPCStat("max_hp", "202000000")  -- 200m + 1% zone bonus
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
    e.self:SetHP(e.self:GetMaxHP())
end

function event_timer(e)

    -- === FLAG CHECK TIMER ADDED HERE ===
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
    end
    -- ==================================

    if e.timer == "call_more" then
        if e.self:IsEngaged() then
            eq.spawn2(207069, 0, 0, -34.73, -10.96, 451.13, 255.5) -- a_minion_of_Maareq
        else
            eq.stop_timer("call_more")
        end

    elseif e.timer == "leash" then
        if e.self:GetZ() < 330 or e.self:GetZ() > 520 then
            e.self:Emote("dissolves into a swirling mist and moves back across the room.")
            e.self:GotoBind()
            eq.set_timer("heal", 6000)
            e.self:HealDamage(8000)
            eq.set_timer("leash", 1000)
        end

    elseif e.timer == "heal" then
        e.self:HealDamage(8000)
        heal = heal + 1
        eq.debug("heal " .. heal)
        if heal == 3 then
            heal = 0
            eq.stop_timer("heal")
        end

    elseif e.timer == "check_adds" then
        local mob_list = eq.get_entity_list():GetMobList()
        if mob_list ~= nil then
            for mob in mob_list.entries do
                if mob:GetNPCTypeID() == 207069 and mob:CalculateDistance(e.self:GetX(), e.self:GetY(), e.self:GetZ()) <= 5 then
                    mob:Emote("adheres to Maareq's flesh and is quickly absorbed!")
                    counter = counter + 1
                    eq.debug("counter " .. counter)
                    eq.signal(207004, 1) -- NPC: Maareq_the_Prophet
                    mob:Depop()
                end
            end
        end
    end
end

function event_signal(e)
    if e.signal == 1 and counter == 10 then
        e.self:Emote("raises his arms towards the sky and screams! His exposed skin bulges and writhes...")
        e.self:Shout("My prophecy was fulfilled for Saryrn! Your fate shall come to fruition as well!")
        e.self:ChangeSize(10)
        e.self:SetSpecialAbility(SpecialAbility.flurry, 40)

    elseif e.signal == 1 and counter == 21 then
        e.self:SetRace(281)
        e.self:SetSpecialAbility(8, 1)
        e.self:SetSpecialAbility(7, 0)
        e.self:SetSpecialAbility(SpecialAbility.flurry, 0)
        e.self:SetSpecialAbility(SpecialAbility.area_rampage, 5)
        e.self:Say("Your assault only prolongs the inevitable!...")
        eq.get_entity_list():MessageClose(e.self, false, 200, MT.NPCQuestSay, "A horrific roar reverberates throughout the zone!")

    elseif e.signal == 1 and counter == 42 then
        e.self:ChangeSize(20)
        e.self:SetSpecialAbility(SpecialAbility.area_rampage, 10)
        e.self:Emote("radiates with rage! The ferocity of its attacks increases dramatically...")
    end
end

function event_death_complete(e)
    eq.get_entity_list():MessageClose(e.self, false, 200, MT.NPCQuestSay,
        "A strange female voice drifts from the bloated corpse...")

    eq.spawn2(207014, 0, 0, -0.18, -6.62, 466.63, 252.3) -- Tylis_Newleaf
    eq.depop_all(207081)
    eq.depop_all(207069)
end