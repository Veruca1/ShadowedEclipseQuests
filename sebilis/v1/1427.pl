sub EVENT_SIGNAL {
    # Retrieve the current signal count or initialize if not set
    my $signal_count = $npc->GetEntityVariable("signal_count") // 0;

    if ($signal == 1) {
        # Increment the signal counter
        $signal_count++;
        $npc->SetEntityVariable("signal_count", $signal_count);

        # Check if the signal count has reached 6
        if ($signal_count >= 6) {
            # Spawn NPC 1451 at the specified location
            quest::spawn2(1451, 0, 0, -761.03, -2034.03, -142.69, 154.75);
            $npc->SetEntityVariable("signal_count", 0); # Reset counter
        }
    }

    elsif ($signal == 2) {
        # Start a timer to spawn NPC 1450 at various locations with a 2-second delay
        quest::settimer("spawn_npc_1450", 2);
        # Initialize a counter to track which spawn point to use
        $npc->SetEntityVariable("spawn_counter", 0);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1450") {
        # List of spawn locations (X, Y, Z, Heading)
        my @locations = (
            [-781.86, -2075.27, -142.59, 134.50],
            [-757.30, -2127.50, -142.59, 219.25],
            [-706.08, -2162.93, -142.59, 135.50],
            [-644.74, -2154.00, -142.59, 84.75],
            [-616.96, -2103.94, -142.59, 9.50],
            [-618.90, -2054.40, -142.59, 464.50],
            [-669.70, -2009.88, -142.59, 398.25],
            [-729.35, -1999.76, -142.59, 354.50],
            [-764.93, -2019.80, -142.59, 165.00]
        );

        # Retrieve the current spawn counter
        my $counter = $npc->GetEntityVariable("spawn_counter");

        # Check if there are still locations to use
        if ($counter < scalar(@locations)) {
            # Get the current location
            my ($x, $y, $z, $h) = @{$locations[$counter]};
            
            # Spawn NPC 1450 at the current location
            quest::spawn2(1450, 0, 0, $x, $y, $z, $h);
            
            # Increment the spawn counter
            $npc->SetEntityVariable("spawn_counter", $counter + 1);
        } else {
            # Stop the timer when all locations have been used
            quest::stoptimer("spawn_npc_1450");
            
            # Start a new timer to spawn NPC 1449 after 5 seconds
            quest::settimer("spawn_real_boss", 5);
        }
    } 
    elsif ($timer eq "spawn_real_boss") {
        # Spawn the real boss NPC 1449 at the given location
        quest::spawn2(1449, 0, 0, -761.03, -2034.03, -142.69, 154.75);
        
        # Stop the timer after spawning the real boss
        quest::stoptimer("spawn_real_boss");
    }
}
