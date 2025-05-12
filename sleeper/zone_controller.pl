my @npc_ids = (1842, 1843, 1844, 1845, 1846);
my $spawn_loc_x = 515.02;
my $spawn_loc_y = -8.94;
my $spawn_loc_z = 1.25;
my $spawn_heading = 383.25;
my $current_npc_index = 0;  # Start with 1842
my $shuffle_active = 0;      # Flag to track if the shuffle should happen
my $count = 0;               # Initialize count for signal tracking

sub EVENT_SPAWN {
    my $npc_id = 128094;
    quest::spawn2($npc_id, 0, 0, -1455.53, -2380.75, -1053.04, 131.25);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        $count++;
        #quest::shout("DEBUG: Received signal 1. Count = $count.");
        if ($count == 2 && !quest::isnpcspawned(1839)) {
            #quest::shout("DEBUG: Spawning NPC 1839.");
            quest::spawn2(1839, 0, 0, 417.93, -8.81, 8.60, 376);
            $count = 0;
        }
    } 
    elsif ($signal == 2) {
        #quest::shout("DEBUG: Received signal 2.");
        if (!quest::isnpcspawned($npc_ids[$current_npc_index])) {
            #quest::shout("DEBUG: Spawning NPC $npc_ids[$current_npc_index].");
            quest::spawn2($npc_ids[$current_npc_index], 0, 0, $spawn_loc_x, $spawn_loc_y, $spawn_loc_z, $spawn_heading);
            quest::settimer("depop_npc", 5);
        }
    }
    elsif ($signal == 10) {  # Start Frostbane's Hands rotation
        #quest::shout("DEBUG: Received signal 10. Checking hand status.");
        if (quest::isnpcspawned(1848) && quest::isnpcspawned(1849)) {
            $shuffle_active = 1;
            #quest::shout("DEBUG: Both hands are up. Starting rotation immediately.");
            
            # Perform the first shuffle immediately
            shuffle_hands();
            
            # Start random rotation timer
            my $shuffle_time = quest::ChooseRandom(60, 75, 90, 120);
            #quest::shout("DEBUG: Next hand shuffle in $shuffle_time seconds.");
            quest::settimer("shuffle_hands", $shuffle_time);
        } else {
            #quest::shout("DEBUG: One or both hands are missing. Rotation not started.");
        }
    }
   elsif ($signal == 11) {  # Stop Frostbane's Hands rotation
    #quest::shout("DEBUG: Received signal 11. Stopping rotation.");
    $shuffle_active = 0;
    quest::stoptimer("shuffle_hands");

    # Ensure neither hand remains permanently invulnerable
    quest::signalwith(1848, 1);
    quest::signalwith(1849, 1);
    }
}

sub shuffle_hands {
    if (quest::isnpcspawned(1848) && quest::isnpcspawned(1849)) {
        if (quest::ChooseRandom(0, 1) == 0) {
            #quest::shout("DEBUG: Activating Right Hand (1848), Freezing Left Hand (1849).");
            quest::signalwith(1848, 1);  # Right Hand Attacks
            quest::signalwith(1849, 2);  # Left Hand Freezes
        } else {
            #quest::shout("DEBUG: Activating Left Hand (1849), Freezing Right Hand (1848).");
            quest::signalwith(1849, 1);  # Left Hand Attacks
            quest::signalwith(1848, 2);  # Right Hand Freezes
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_npc") {
        my $current_npc_id = $npc_ids[$current_npc_index];
        #quest::shout("DEBUG: Depopping NPC $current_npc_id.");
        quest::depop($current_npc_id);
        $current_npc_index = ($current_npc_index + 1) % scalar(@npc_ids);

        if ($npc_ids[$current_npc_index] == 1846) {
            #quest::shout("DEBUG: Last NPC in rotation, spawning 1846.");
            quest::spawn2($npc_ids[$current_npc_index], 0, 0, $spawn_loc_x, $spawn_loc_y, $spawn_loc_z, $spawn_heading);
            quest::stoptimer("depop_npc");
        } else {
            #quest::shout("DEBUG: Spawning next NPC in rotation: $npc_ids[$current_npc_index].");
            quest::spawn2($npc_ids[$current_npc_index], 0, 0, $spawn_loc_x, $spawn_loc_y, $spawn_loc_z, $spawn_heading);
            quest::settimer("depop_npc", 5);
        }
    }
    elsif ($timer eq "shuffle_hands" && $shuffle_active) {
        shuffle_hands();
        my $next_shuffle_time = quest::ChooseRandom(60, 75, 90, 120);
        #quest::shout("DEBUG: Next hand shuffle in $next_shuffle_time seconds.");
        quest::settimer("shuffle_hands", $next_shuffle_time);
    }
}
