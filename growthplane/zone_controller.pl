# List of NPC IDs for mini-bosses
my @mini_boss_ids = (
    127097, 127020, 127047, 127093, 127018, 127023, 127022, 127035, 127040, 127096,
    127019, 127017, 127021, 127042, 127015, 127016
);

# List of NPC IDs for regular mobs
my @npc_ids = (
    127059, 127088, 127067, 127034, 127037, 127014, 127046, 127029, 127002, 127013,
    127092, 127065, 127025, 127032, 127008, 127071, 127056, 127044, 127004, 127103, 127036
);

# Original spawn location for NPC ID 1834
my $x = 612.57;
my $y = 138.02;
my $z = -88.59;
my $heading = 260;

my $npc_count = 0;  # Counter for spawned regular NPCs
my $mini_boss_count = 0;  # Counter for spawned mini-bosses

# Original spawn logic for regular NPCs
sub EVENT_SPAWN {
    my $npc_id = 1834; # ID of the NPC you want to spawn

    # Check if the NPC is already spawned
    if (!quest::isnpcspawned($npc_id)) {
        # If not spawned, spawn the NPC at the specified location
        quest::spawn2($npc_id, 0, 0, $x, $y, $z, $heading);
    }
}

# Handle signals
sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Apply Camera Effect
        $npc->CameraEffect(1000, 3);

        # Get all clients in the zone
        my @clients = $entity_list->GetClientList();

        # Define the text for the marquee
        my $text = "Tunare has been made aware of your presence.";

        # Send the marquee message to each client in the zone
        foreach my $client (@clients) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
        }

        # Start spawning regular NPCs immediately
        quest::settimer("npc_spawn_timer", 30);  # Start immediately with a 30-second interval for the first spawn
    }
}

# Handle timers
sub EVENT_TIMER {
    if ($timer eq "npc_spawn_timer") {
        # Check if we've spawned 20 regular NPCs yet
        if ($npc_count < 20) {
            # Pick a random NPC ID
            my $npc_id = $npc_ids[int(rand(scalar(@npc_ids)))] ;

            # Spawn the NPC at the fixed location of NPC ID 1834
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $heading);

            # Increase NPC count
            $npc_count++;

            # Continue spawning NPCs every 30 seconds
            if ($npc_count < 20) {
                quest::settimer("npc_spawn_timer", 30);  # Set the interval to 30 seconds for the next spawn
            }
        }
        else {
            # Stop the timer once all regular NPCs are spawned
            quest::stoptimer("npc_spawn_timer");

            # Start spawning mini-bosses after 20 regular NPCs
            quest::settimer("mini_boss_spawn_timer", 60);  # Start mini-boss spawns every 1 minute
        }
    }

    # Handle mini-boss spawning after the regular NPCs
    if ($timer eq "mini_boss_spawn_timer") {
        if ($mini_boss_count < 4) {
            # Pick a random mini-boss NPC ID
            my $mini_boss_id = $mini_boss_ids[int(rand(scalar(@mini_boss_ids)))] ;

            # Spawn the mini-boss at the fixed location (same as regular NPC spawn location)
            quest::spawn2($mini_boss_id, 0, 0, $x, $y, $z, $heading);

            # Increase mini-boss count
            $mini_boss_count++;

            # Continue spawning mini-bosses every 1 minute
            if ($mini_boss_count < 4) {
                quest::settimer("mini_boss_spawn_timer", 60);  # Set the interval to 1 minute for the next mini-boss spawn
            }
        }
        else {
            # Stop the timer once 4 mini-bosses are spawned
            quest::stoptimer("mini_boss_spawn_timer");

            # Spawn the final NPC 127001 after mini-bosses have been spawned
            quest::spawn2(127001, 0, 0, $x, $y, $z, $heading);
        }
    }
}
