sub EVENT_SPAWN {
    quest::spawn2(1911, 0, 0, -477.71, -2007.34, 45.19, 57.75);

    if ($instanceversion == 1) {
        quest::signalwith(1911, 1, 0);  # Optional delay of 0 ms
    }
}

sub EVENT_SIGNAL {
    if ($signal == 10) {
        # Depop NPC with ID 124080
        my $npc_to_depop = $entity_list->GetMobByNpcTypeID(124080);
        if ($npc_to_depop) {
            $npc_to_depop->Depop();
        }

        # Spawn NPC ID 1238 at (-739.4, 517.2, 121), heading 510
        quest::spawn2(1238, 0, 0, -739.4, 517.2, 121, 510);
    }
    elsif ($signal == 11) {
        # Depop NPC with ID 124021
        my $npc_to_depop = $entity_list->GetMobByNpcTypeID(124021);
        if ($npc_to_depop) {
            $npc_to_depop->Depop();
        }

        # Spawn NPC ID 124155 at (-739.4, 517.2, 121), heading 510
        quest::spawn2(124155, 0, 0, -739.4, 517.2, 121, 510);
    }
    elsif ($signal == 40) {
        # Depop all NPCs with IDs 1594 and 1595
        quest::depopall(1594);
        quest::depopall(1595);
    }
    elsif ($signal == 50) {
        quest::settimer("spawn_1957", 300); # 5 minutes in seconds
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_1957") {
        quest::stoptimer("spawn_11967");

        if (!quest::isnpcspawned(1957)) {
            quest::spawn2(1957, 0, 0, -739.4, 517.2, 121, 510);
        }
    }
}