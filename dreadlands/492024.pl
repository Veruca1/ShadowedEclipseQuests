my $current_wave = 0;
my $total_waves = 10;

# Define the NPC IDs for each wave
my %wave_npcs = (
    1 => [2000041],
    2 => [2000041, 2000042],
    3 => [2000041, 2000042, 2000043],
    4 => [2000044],
    5 => [2000044, 2000045],
    6 => [2000044, 2000045, 2000046],
    7 => [2000041, 2000042, 2000043, 2000044],
    8 => [2000041, 2000042, 2000043, 2000044, 2000045],
    9 => [2000041, 2000042, 2000043, 2000044, 2000045, 2000046],
    10 => [1280]
);

# Hash to track the number of NPCs needed per wave
my %wave_kill_count = (
    1 => 1,
    2 => 2,
    3 => 3,
    4 => 1,
    5 => 2,
    6 => 3,
    7 => 4,
    8 => 5,
    9 => 6,
    10 => 1
);

# Hash to track the number of NPCs spawned and killed for each wave
my %npc_status = ();

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Welcome to the Endless Onslaught event! Ready to test the waves? Please click " . 
                       quest::saylink("Yes") . " to start or " . 
                       quest::saylink("No") . " to decline.");
    } elsif ($text=~/yes/i) {
        quest::whisper("Starting the first wave now!");
        $current_wave = 1;
        SpawnWave($current_wave);  # Start the first wave immediately
    } elsif ($text=~/no/i) {
        quest::whisper("Maybe next time!");
    }
}

sub SpawnWave {
    my ($wave_number) = @_;

    # Check if this is a valid wave
    if (exists $wave_npcs{$wave_number}) {
        my @npc_ids = @{$wave_npcs{$wave_number}};
        SpawnNPCs(\@npc_ids);

        # Initialize or reset NPC status for the wave
        $npc_status{$wave_number} = {
            spawned => $wave_kill_count{$wave_number},
            killed => 0
        };

        quest::whisper("Wave $wave_number spawned.");
    } else {
        quest::whisper("Invalid wave number $wave_number.");
    }
}

sub SpawnNPCs {
    my ($npc_ids) = @_;
    
    my $base_x = 9559.19;
    my $base_y = 2696.28;
    my $base_z = 1043.13;
    my $base_h = 297.50;
    my $radius = 200;

    foreach my $npc_id (@$npc_ids) {
        my $angle = rand(360);  # Random angle in degrees
        my $distance = rand($radius);  # Random distance within the radius
        my $rad_angle = $angle * (3.14159 / 180);  # Convert angle to radians

        my $spawn_x = $base_x + cos($rad_angle) * $distance;
        my $spawn_y = $base_y + sin($rad_angle) * $distance;
        my $spawn_z = $base_z;

        quest::spawn2($npc_id, 0, 0, $spawn_x, $spawn_y, $spawn_z, $base_h);
    }
}

sub EVENT_DEATH {
    my $npc_id = $npc->GetNPCTypeID();

    if (exists $npc_status{$current_wave}) {
        my $status = $npc_status{$current_wave};

        # Increment the kill count for the current wave
        $status->{killed}++;

        # Log current NPC status for debugging
        quest::whisper("NPC $npc_id died. Kills needed for wave $current_wave: $status->{killed}/$status->{spawned}");

        # Check if all required NPCs for the wave are killed
        if ($status->{killed} >= $wave_kill_count{$current_wave}) {
            quest::whisper("All required NPCs in wave $current_wave are dead. Moving to wave " . ($current_wave + 1));

            # Move to the next wave
            $current_wave++;
            if ($current_wave <= $total_waves) {
                SpawnWave($current_wave);  # Start the next wave immediately
            } else {
                quest::whisper("All waves completed. The event has ended.");
                # Arena Marshall remains active and does not respawn
            }
        }
    }
}
