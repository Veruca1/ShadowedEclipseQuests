sub EVENT_DEATH_COMPLETE {
    # Spawn NPC with ID 1505 at the location of the dying NPC
    quest::spawn2(1505, 0, 0, $x, $y, $z, $h);
}
