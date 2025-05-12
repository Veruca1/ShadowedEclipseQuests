-- a_black_reaver that spawns High_Scale_Kirn (1394)
function event_death_complete(e)
    local roll = math.random(100)

    if (roll <= 15) then
        eq.unique_spawn(1394, 0, 0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading())
    else
        eq.spawn2(90004, 0, 0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading())
    end
end

