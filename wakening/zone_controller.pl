sub EVENT_SPAWN {
    # Despawn if already present (dupe prevention on zone resume)
    my $existing = $entity_list->GetNPCByNPCTypeID(1752);
    $existing->Depop(1) if $existing;

    # Now spawn fresh instance
    quest::spawn2(1752, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::settimer("spawn_npc_1833", 10); # 10 sec delay
    }
    elsif ($signal == 2) {
        quest::settimer("spawn_npc_1752_delay", 120); # 2 min delay
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1833") {
        quest::stoptimer("spawn_npc_1833");
        quest::spawn2(1833, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
    }
    elsif ($timer eq "spawn_npc_1752_delay") {
        quest::stoptimer("spawn_npc_1752_delay");

        my $existing = $entity_list->GetNPCByNPCTypeID(1752);
        if (!$existing) {
            quest::spawn2(1752, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
        }
    }
}