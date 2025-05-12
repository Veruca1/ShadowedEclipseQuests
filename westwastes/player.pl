sub EVENT_ENTERZONE {
    # Zone ID check (use the actual zone ID for the zone in question)
    if ($zoneid == 120) {  # Replace 120 with the actual zone ID you want to target
        
        # Only trigger when a player enters the zone
        if ($client) {  # Ensure it's a player that entered the zone
            
            # Additional player level check (optional)
            if ($ulevel >= 1) {  # Check if player level is at least 1 (you can adjust this level as needed)
                # Start a 5-second timer to depop NPCs after zone entry
                quest::settimer("depop_npcs", 5);
            }
        }
    }
}

sub EVENT_TIMER {
    # Check if the timer is the "depop_npcs" timer
    if ($timer eq "depop_npcs") {
        # List of NPC IDs to depop
        my @npc_ids_to_depop = (
            120061, 120065, 120041, 120048, 120130, 120046, 120122, 120015,
            120004, 120100, 120014, 120019, 120018, 120086, 120024, 120120,
            120007, 120057, 120043, 120053, 120017, 120056, 120134, 120055,
            120016, 120084, 120106, 120073, 120126, 120087, 120114, 120107,
            120006, 120123, 120005, 120117, 120135, 120042, 120008, 120025
        );
        
        # First depop loop
        foreach my $npc_id (@npc_ids_to_depop) {
            quest::depopall($npc_id);
        }

        # Start a second timer for the second depop after another 5 seconds
        quest::settimer("depop_npcs_second", 5);
        
        # Stop the first timer once the first depop is done
        quest::stoptimer("depop_npcs");
    }

    # Second depop process
    if ($timer eq "depop_npcs_second") {
        # List of NPC IDs to depop again
        my @npc_ids_to_depop = (
            120061, 120065, 120041, 120048, 120130, 120046, 120122, 120015,
            120004, 120100, 120014, 120019, 120018, 120086, 120024, 120120,
            120007, 120057, 120043, 120053, 120017, 120056, 120134, 120055,
            120016, 120084, 120106, 120073, 120126, 120087, 120114, 120107,
            120006, 120123, 120005, 120117, 120135, 120042, 120008, 120025
        );
        
        # Second depop loop
        foreach my $npc_id (@npc_ids_to_depop) {
            quest::depopall($npc_id);
        }

        # Stop the second timer once the action is complete
        quest::stoptimer("depop_npcs_second");
    }
}
