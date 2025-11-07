--[[ Bertox Event helper ## By Drogerin ]]--

function event_spawn(e)
  -- Ensure condition starts OFF in this instance (public or DZ)
  local shortname = eq.get_zone_short_name() or "codecay"
  local instance  = eq.get_zone_instance_id() or 0
  eq.spawn_condition(shortname, instance, 1, 0)
end