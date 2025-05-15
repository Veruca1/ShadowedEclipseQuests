sub EVENT_SPAWN {
    # Match HP of THO on spawn
    my $tho = $entity_list->GetNPCByNPCTypeID(1947);
    if ($tho) {
        my $tho_hp = $tho->GetHP();
        $npc->SetHP($tho_hp);  # Set current HP to match THO
    }

    # Begin monitoring for balance at 50%
    quest::setnexthpevent(50);
}

sub EVENT_HP {
    if ($hpevent == 50) {
        # Do nothing here – THO script handles the merge/despawn logic.
    }
}