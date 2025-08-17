# player.pl

sub EVENT_ENTERZONE {
    # --- Version 0: NoTarget Emperor spawn (only if not already spawned) ---
    if ($zoneid == 162 && $instanceversion == 0) {
        my $emperor = $entity_list->GetNPCByNPCTypeID(162189);
        if (!$emperor) {
            quest::spawn2(162189, 0, 0, 877.0, -325.0, 400.5, 384);
        }
    }

    # --- Version 1: Marquee message ---
    if ($zoneid == 162 && $instanceversion == 1) {
        my $text = "The zone is eerily silent, and all you can hear is the distant ticking of a clock.";
        foreach my $c ($entity_list->GetClientList()) {
            next unless $c;
            $c->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
        }
    }

    # --- Version 0: Paradigm spawn ---
    if ($zoneid == 162 && $instanceversion == 0) {
        my $existing = $entity_list->GetNPCByNPCTypeID(2178);
        if (!$existing) {
            quest::settimer("spawn_paradigm", 20);
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_paradigm") {
        quest::stoptimer("spawn_paradigm");

        # Depop any existing Paradigm_of_Reflection
        my $npc = $entity_list->GetNPCByNPCTypeID(2178);
        $npc->Depop(1) if $npc;

        # Spawn fresh — will tint itself in its own EVENT_SPAWN
        quest::spawn2(2178, 0, 0, 261.74, -576.25, -255.74, 1.00);
    }
}