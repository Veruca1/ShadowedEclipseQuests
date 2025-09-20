# POD Boss Grummice - Out of Bounds Check + Death Spawn

sub EVENT_COMBAT {
    my ($combat_state) = @_;

    if ($combat_state == 1) {
        # Engage: start OOB check timer (6 sec)
        quest::settimer("OOBcheck", 6000);
    } else {
        # Disengage: stop OOB check
        quest::stoptimer("OOBcheck");
    }
}

sub EVENT_TIMER {
    my ($timer) = @_;

    if ($timer eq "OOBcheck") {
        quest::stoptimer("OOBcheck");

        # Check NPC X coordinate
        if ($npc->GetX() < 1800) {
            # Out of bounds: reset to bind + wipe hate
            $npc->GotoBind();
            $npc->WipeHateList();
        } else {
            # Still in-bounds: restart OOB check
            quest::settimer("OOBcheck", 6000);
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn Planar Projection on death
    quest::spawn2(
        202366,  # NPC type ID
        0, 0,    # Grid / unused params
        $npc->GetX(),
        $npc->GetY(),
        $npc->GetZ(),
        $npc->GetHeading()
    );
}