-- ===========================================================
-- spider_controller.lua (NPC ID 206087) — Plane of Innovation
-- Shadowed Eclipse: Manaetic Behemoth Encounter Controller
-- -----------------------------------------------------------
-- - Spawns clockwork spider waves every 40 seconds.
-- - On receiving signal(1), immediately respawns the
--   untargetable Manaetic_Behemoth (206046) at center.
-- ===========================================================

function event_spawn(e)
    eq.set_timer("spiders", 40 * 1000)
end

function event_timer(e)
    eq.spawn2(206000, 28, 0, 803, -285, 4.63, 314)
    eq.spawn2(206001, 29, 0, 804, 285, 4.63, 314)
    eq.spawn2(206002, 30, 0, 1443, 285, 4.63, 314)
    eq.spawn2(206086, 31, 0, 1443, -285, 4.63, 314)
    eq.spawn2(eq.ChooseRandom(206071,206070), 26, 0, 1155, 605, 4.63, 0)
    eq.spawn2(eq.ChooseRandom(206072,206069), 24, 0, 1155, -600, 4.63, 0)
end

function event_signal(e)
    if e.signal == 1 then
        -- Respawn untargetable version immediately at center
        eq.spawn2(206046, 0, 0, 1125, 0, 12.5, 0)
        eq.debug("Spider controller received signal(1): Respawned untargetable Manaetic_Behemoth.")
    end
end