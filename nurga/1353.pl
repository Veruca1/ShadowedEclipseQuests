sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When combat starts
        quest::settimer("random_cast", 40);  # Set timer for random casting every 40 seconds
        quest::settimer("spawn_npcs", 30);  # Set timer for spawning NPCs every 30 seconds
        # quest::settimer("spawn_fabled1", 60);  # Set timer for spawning NPCs every 60 seconds
    } else {
        quest::stoptimer("random_cast");  # Stop random casting timer if combat ends
        quest::stoptimer("spawn_npcs");   # Stop the NPC spawning timer if combat ends
        # quest::stoptimer("spawn_fabled1");   # Stop the NPC spawning timer if combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "random_cast") {
        # List of spells to cast (36860 and 36861)
        my @spells = (36860, 36861);
        
        # Pick a random spell from the list
        my $random_spell = $spells[rand @spells];
        
        # Cast the random spell on the NPC’s target
        $npc->CastSpell($random_spell, $npc->GetTarget()->GetID());
    }
    
    if ($timer eq "spawn_npcs") {
        # Spawn NPCs with ID 107030 at different locations
        quest::spawn2(107030, 0, 0, $x + 10, $y, $z, $h);  # Adjust coordinates as needed
        # quest::spawn2(107030, 0, 0, $x - 10, $y, $z, $h);  # Adjust coordinates as needed
        # quest::spawn2(107030, 0, 0, $x, $y + 10, $z, $h);  # Adjust coordinates as needed
    }

    if ($timer eq "spawn_fabled1") {
        # quest::spawn2(107160, 0, 0, $x + 10, $y, $z, $h);  # Adjust coordinates as needed
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send signal 50 to NPC 1352
    quest::signalwith(1352, 50, 2);
}
