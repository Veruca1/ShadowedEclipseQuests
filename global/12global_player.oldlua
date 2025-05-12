-- Function to handle item discovery event (unchanged)
function event_discover_item(e)
    local player_name = e.self:GetCleanName()
    local item_id = e.item:ID()
    local item_name = eq.get_item_name(item_id)
    local disco_msg = player_name .. " has discovered " .. item_name
    eq.discord_send("ooc", disco_msg)
end

-- Function to handle player login event
function event_client_connect(e)
    local player_name = e.self:GetCleanName()
    local login_msg = player_name .. " has logged in"
    eq.discord_send("connections", login_msg)
end

-- Function to handle player logout event
function event_client_disconnect(e)
    local player_name = e.self:GetCleanName()
    local logout_msg = player_name .. " has logged out"
    eq.discord_send("connections", logout_msg)
end

function auto_skill(e)
    local skills = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    for _, curskill in ipairs(skills) do
        local maxskill = e.self:MaxSkill(curskill)
        if e.self:CanHaveSkill(curskill) == false then
            -- Do nothing
        elseif maxskill <= e.self:GetRawSkill(curskill) then
            -- Do nothing
        else
            -- Do Training
            e.self:SetSkill(curskill, maxskill)
        end
    end
end

function event_level_up(e)
    auto_skill(e)
    eq.scribe_spells(e.self:GetLevel())
    eq.train_discs(e.self:GetLevel())
end

-- Kill Tracker Configuration and functions removed
