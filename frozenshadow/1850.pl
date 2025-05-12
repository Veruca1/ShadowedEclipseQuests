sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (3240, 36883);

    # Apply buffs to NPC 44133 itself
    foreach my $spell_id (@buffs) {
        $npc->SpellFinished($spell_id, $npc);
    }
    
    # Set a timer to check health
    quest::settimer("check_health", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # 1 means NPC has entered combat
        # Nagini's shout message
        quest::shout("The Dark Lord commands! I shall strike down all who oppose him!");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn the main NPC
    quest::spawn2(243672, 0, 0, -6.04, 533.46, 309.70, 257.25);

    # Define the locations and NPCs to spawn at each location
    my @locations = (
        [82.00, 486.00, 307.10, 0.00, 111157],  # Location 1 - NPC 111157
        [82.00, 522.00, 307.10, 0.00, 1854],    # Location 2 - NPC 1854
        [82.00, 556.00, 307.10, 0.00, 1855],    # Location 3 - NPC 1855
        [38.00, 570.00, 307.10, 0.00, 1856],    # Location 4 - NPC 1856
        [-28.00, 570.00, 307.10, 0.00, 1857],   # Location 5 - NPC 1857
        [-66.00, 556.00, 307.10, 0.00, 1858],   # Location 6 - NPC 1858
        [-65.00, 522.00, 307.10, 0.00, 1859],   # Location 7 - NPC 1859
        [-65.00, 486.00, 307.10, 0.00, 1860],   # Location 8 - NPC 1860
    );

    # Spawn each NPC at the specified location
    foreach my $loc (@locations) {
        my ($x, $y, $z, $h, $npc_id) = @$loc;
        
        # Spawn the NPC at the location
        quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
    }
}