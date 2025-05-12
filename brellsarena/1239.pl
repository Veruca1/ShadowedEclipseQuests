# NPC ID: 1239
# Manages wave spawning and detection of wave completion

my $current_wave = 0;
my $total_waves = 10;
my $spawn_radius = 100;  # Radius for spawning NPCs
my $check_interval = 5;  # Interval in seconds to check NPC counts
my $npc_count_before = 0;

# Hash to hold the NPC IDs for each wave
my %wave_mobs = (
    1 => [2000041],       # Wave 1: 1 mob
    2 => [2000041, 2000041],  # Wave 2: 2 mobs
    3 => [2000042, 2000042, 2000042],  # Wave 3: 3 mobs
    4 => [2000043],       # Wave 4: 1 mob
    5 => [2000044, 2000044],  # Wave 5: 2 mobs
    6 => [2000045, 2000045, 2000045],  # Wave 6: 3 mobs
    7 => [2000046, 2000046, 2000046, 2000046],  # Wave 7: 4 mobs
    8 => [2000047, 2000047, 2000047, 2000047, 2000047],  # Wave 8: 5 mobs
    9 => [2000048, 2000048, 2000048, 2000048, 2000048, 2000048],  # Wave 9: 6 mobs
    10 => [2000049]  # Wave 10: 1 mob
);

sub EVENT_SIGNAL {
    my $wave_number = $signal;

    if ($wave_number > 0 && $wave_number <= $total_waves) {
        $current_wave = $wave_number;

        # Initialize NPC counts before spawning
        $npc_count_before = scalar($entity_list->GetNPCList());

        # Define spawn location
        my $wave_start_loc_x = -43.50;
        my $wave_start_loc_y = -10.78;
        my $wave_start_loc_z = -10.32;

        # Get NPC IDs for the current wave
        my @wave_npcs = @{ $wave_mobs{$wave_number} };

        # Spawn the correct number of NPCs for the current wave
        foreach my $npc_id (@wave_npcs) {
            my $x = $wave_start_loc_x + int(rand($spawn_radius * 2)) - $spawn_radius;
            my $y = $wave_start_loc_y + int(rand($spawn_radius * 2)) - $spawn_radius;
            my $z = $wave_start_loc_z;
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, 0);
            
            #quest::shout("Debug: Spawning NPC $npc_id at $x, $y, $z.");
        }

        # Set a timer to check NPC counts
        quest::settimer("npc_check", $check_interval);
        quest::shout("Debug: NPCs for wave $wave_number spawned. Monitoring for completion.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "npc_check") {
        # Get the current NPC count
        my $npc_count_after = scalar($entity_list->GetNPCList());
        my $npc_count_spawned = $npc_count_after - $npc_count_before;

        # Check if wave is complete
        if ($npc_count_spawned <= 0) {
            quest::shout("Debug: Wave $current_wave completed. Spawning next wave.");
            quest::stoptimer("npc_check");
            if ($current_wave < $total_waves) {
                quest::signalwith(1239, $current_wave + 1, 2);  # Signal to start the next wave
            }
        } else {
            # Update previous count for the next check
            $npc_count_before = $npc_count_after;
        }
    }
}

sub EVENT_DEATH {
    # Optional: Handle any specific actions upon NPC death if needed
}
