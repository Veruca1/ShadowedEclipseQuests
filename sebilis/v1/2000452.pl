sub EVENT_SPAWN {
    # Spawn NPC ID 1427 (Disembodied Voice) when this NPC spawns
    quest::spawn2(1427, 0, 0, $x, $y, $z, $h);  # Spawns Disembodied Voice at the same location as the NPC

    # You can modify the location or heading ($x, $y, $z, $h) if needed
}