my $signal_count_1_8 = 0;
my $signal_count_10_15 = 0;
my $signal_count_20_23 = 0;

sub EVENT_SPAWN {
    # Set NPC 1352 to never depop
    quest::setnexthpevent(0);  # Makes it persistent (never depop)
}

sub EVENT_SIGNAL {
    # Check if signal 30 is received
    if ($signal == 30) {
        quest::shout("A menacing laughter echoes throughout the zone. All of this messing around with time will be Zarrin's undoing! Hahahaha!");
    }

    # Increment the signal count for signals 1-8
    if ($signal >= 1 && $signal <= 8) {
        $signal_count_1_8++;
    }

    # Check if all 8 signals (1-8) have been received
    if ($signal_count_1_8 == 8) {
        # Spawn NPC ID 1402 if it is not already up
        my $npc_id = 1402;
        if (!quest::isnpcspawned($npc_id)) {
            quest::spawn2(1402, 0, 0, 259.49, -506.31, -28.75, 491.50);
        }

        # Reset the signal count for future uses
        $signal_count_1_8 = 0;
    }

    # Increment the signal count for signals 10-15
    if ($signal >= 10 && $signal <= 15) {
        $signal_count_10_15++;
    }

    # Check if all signals (10-15) have been received
    if ($signal_count_10_15 == 6) {  # There are 6 signals total: 10, 11, 12, 13, 14, 15
        # Spawn NPC ID 1404 if it is not already up
        my $npc_id = 1404;
        if (!quest::isnpcspawned($npc_id)) {
            quest::spawn2(1404, 0, 0, 363.54, -123.73, -12.25, 122.50);
        }
        
        # Reset the signal count for future uses
        $signal_count_10_15 = 0;
    }

    # Increment the signal count for signals 20-23
    if ($signal >= 20 && $signal <= 23) {
        $signal_count_20_23++;
    }

    # Check if all 4 signals (20-23) have been received
    if ($signal_count_20_23 == 4) {
        # Spawn NPC ID 109108 at the specified location and heading
        quest::spawn2(109108, 0, 0, -261.28, -483.97, 24.91, 2.50);

        # Reset the signal count for future uses
        $signal_count_20_23 = 0;
    }
}
