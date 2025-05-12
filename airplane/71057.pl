sub EVENT_DEATH_COMPLETE {
    # This event triggers when the NPC dies
    quest::spawn2(71032, 0, 0, $x, $y, $z, $h);  # Spawns the NPC at the current coordinates
}
