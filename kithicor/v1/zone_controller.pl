# Zone Controller Script

sub EVENT_SPAWN {
   
    quest::spawn2(1423, 0, 0, $x, $y, $z, $h);  # Spawn NPC ID 1423 at the controller's location
}

# Optional: You can add a signal or timer for respawning or other events if needed.
