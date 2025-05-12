sub EVENT_DEATH {
    # Define a unique identifier for NPC 63119 to prevent multiple spawns
    my $npc_id = 63119;

    # Check if NPC 63119 is already present in the zone
    my $existing_npc = $entity_list->GetNPCByNPCTypeID($npc_id);

    if (!$existing_npc) {
        # NPC 63119 is not present, so we can safely spawn it
        quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        quest::shout("You fool! Hahahaha, Chronomancer Zarrin sends his regards.");
    } else {
        # NPC 63119 is already present; do nothing or shout a message
        quest::shout("An attempt to spawn another instance of NPC $npc_id was blocked.");
    }
}

sub EVENT_TIMER {
    # Define a timer to ensure no rapid re-spawning
    if ($timer eq "spawn_delay") {
        quest::stoptimer("spawn_delay");
        # Perform additional actions if needed when the timer ends
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Set a timer to prevent rapid re-spawning
        quest::settimer("spawn_delay", 10);  # 10 seconds delay or adjust as needed
    }
}
