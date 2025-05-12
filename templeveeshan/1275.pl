sub EVENT_SPAWN {
    # Spawn NPC ID 124080 at (-809.16, 508.97, 124.00), heading 129.00
    quest::spawn2(124080, 0, 0, -809.16, 508.97, 124.00, 129.00);
    
    # Spawn NPC ID 124021 at (-672.46, 509.36, 124.00), heading 383.25
    quest::spawn2(124021, 0, 0, -672.46, 509.36, 124.00, 383.25);
}

sub EVENT_DEATH_COMPLETE {
    # Send signal 10 to NPC ID 10 when this NPC dies
    quest::signalwith(10, 10);
}
