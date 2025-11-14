-- ===============================================================
-- #Invisible_Trigger_Wraith — Proximity Trap Spawner
-- ===============================================================
-- - Invisible NPC that triggers when a player enters proximity.
-- - Spawns a Wraith of Retribution at specific coordinates.
-- - Emotes on activation and depops after firing once.
-- ===============================================================

function event_spawn(e)
    local npc = e.self
    local x = npc:GetX()
    local y = npc:GetY()
    local z = npc:GetZ()

    -- Use EQEmu's Lua API proximity setter
    eq.set_proximity(x - 20, x + 20, y - 20, y + 20, z - 20, z + 20)
end

function event_enter(e)
    e.self:Emote("croon of banshees fills the room...")

    -- Spawn Wraith of Retribution
    eq.spawn2(201287, 0, 0, 223, -494, -26, 176)

    -- Depop the trap trigger
    eq.depop()
end