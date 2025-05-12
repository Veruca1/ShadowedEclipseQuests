my $signal_1_received = 0;
my $signal_2_received = 0;
my $signal_3_received = 0;
my $signal_4_received = 0;

sub EVENT_SIGNAL {
    # Handle Signal 1 (for NPC 1375 -> NPC 1382 transformation)
    if ($signal == 1) {
        $signal_1_received = 1;
    }
    if ($signal == 2) {
        $signal_2_received = 1;
    }

    # If both Signal 1 and 2 are received, perform the NPC swap for Emperor Venril Sathir (1375 -> 1382)
    if ($signal_1_received == 1 && $signal_2_received == 1) {
        if (!quest::isnpcspawned(1382)) {  # Prevent duplicate spawn
            quest::depop(1375);
            quest::spawn2(1382, 0, 0, -692.23, 170.78, 19.25, 383.50);
        }
        
        # Reset signals for NPC 1375 -> 1382 transformation
        $signal_1_received = 0;
        $signal_2_received = 0;
    }

    # Handle Signal 3 (for NPC 1374 -> NPC 1381 transformation)
    if ($signal == 3) {
        $signal_3_received = 1;
    }
    if ($signal == 4) {
        $signal_4_received = 1;
    }

    # If both Signal 3 and 4 are received, perform the NPC swap for Queen Drusella Sathir (1374 -> 1381)
    if ($signal_3_received == 1 && $signal_4_received == 1) {
        if (!quest::isnpcspawned(1381)) {  # Prevent duplicate spawn
            quest::depop(1374);
            quest::spawn2(1381, 0, 0, -765.51, 170.79, 19.25, 127.75);
        }
        
        # Reset signals for NPC 1374 -> 1381 transformation
        $signal_3_received = 0;
        $signal_4_received = 0;
    }
}