sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Respawn NPC 44137 (Puppetmaster) at its original location
        quest::spawn2(44137, 0, 0, 223.04, -14.00, 2.50, 383.50);
        # Send signal to NPC 44137 to handle respawn behavior
        quest::signalwith(44137,1,2);
    }
}
