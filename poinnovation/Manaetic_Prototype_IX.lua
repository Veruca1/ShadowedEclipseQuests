-- Manaetic_Prototype_IX.lua
-- Zone: Plane of Innovation (zone ID 206)
-- Script: Banish top hate player to fixed coordinates within their instance
-- Note: Works within DZ instance using MovePCInstance

function event_combat(e)
    if e.joined then
        eq.set_timer("banish", math.random(15,30) * 1000);
    else
        eq.stop_timer("banish");
    end
end

function event_timer(e)
    if e.timer == "banish" then
        local cur_target = e.self:GetHateTopClient();

        eq.stop_timer(e.timer);
        eq.set_timer("banish", math.random(15,30) * 1000);

        if cur_target.valid then
            local instance_id = cur_target:GetInstanceID();
            cur_target:MovePCInstance(206, instance_id, -248, -241, 3.13, 384);
        end
    end
end