sub EVENT_SPAWN {
    # Set a timer to despawn the NPC after 5 minutes (300 seconds) of not being in combat
    quest::settimer("despawn", 300);
}

sub EVENT_TIMER {
    if ($timer eq "despawn") {
        # Despawn the NPC if the timer expires
        quest::depop();
    }
}

sub EVENT_COMBAT {
    # Reset the despawn timer when the NPC engages in combat
    quest::stoptimer("despawn");
    quest::settimer("despawn", 300);  # Restart the despawn timer
}

sub EVENT_DEATH {
    # Ensure the despawn timer is stopped if the NPC dies
    quest::stoptimer("despawn");
}

sub EVENT_DEATH_COMPLETE {
    # Check if the Temporal Amplifier (NPC ID 1294) is up in the zone
    my $temporal_amplifier = $entity_list->GetMobByNpcTypeID(1294);

    if ($temporal_amplifier) {
        # Get the location of the dying NPC
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn two NPCs with ID 1295 at the same location
        quest::spawn2(1295, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1295, 0, 0, $x, $y, $z, $h);
    }
}
