sub EVENT_SPAWN {
    # Spawn NPCs at specific locations
    quest::spawn2(44115, 0, 0, 504.21, -34.94, 3.78, 122.25); # NPC 'Choose'
    quest::spawn2(44116, 0, 0, 493.72, -64.16, 3.67, 122.25); # NPC 'Your'
    quest::spawn2(44117, 0, 0, 518.57, -91.72, 3.92, 122.25); # NPC 'Fate'
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Depop the NPCs
        my $choose = $entity_list->GetMobByNpcTypeID(44115); # Get NPC 'Choose'
        my $your = $entity_list->GetMobByNpcTypeID(44116);   # Get NPC 'Your'
        my $fate = $entity_list->GetMobByNpcTypeID(44117);   # Get NPC 'Fate'

        $choose->Depop(0) if $choose; # Depop without spawn timer
        $your->Depop(0) if $your;     # Depop without spawn timer
        $fate->Depop(0) if $fate;     # Depop without spawn timer

        # Set a timer to respawn the NPCs in 3 minutes
        quest::settimer("respawn_npcs", 180);
    }
}

sub EVENT_TIMER {
    if ($timer eq "respawn_npcs") {
        quest::stoptimer("respawn_npcs");

        # Respawn the NPCs at their original locations
        quest::spawn2(44115, 0, 0, 504.21, -34.94, 3.78, 122.25); # NPC 'Choose'
        quest::spawn2(44116, 0, 0, 493.72, -64.16, 3.67, 122.25); # NPC 'Your'
        quest::spawn2(44117, 0, 0, 518.57, -91.72, 3.92, 122.25); # NPC 'Fate'
    }
}
