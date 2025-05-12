my $zomm_spawned = 0;

sub EVENT_SPAWN {
    $zomm_spawned = 0;
}

sub EVENT_AGGRO {
    $npc->AddToHateList($client, 1);
    quest::shout("You dare challenge Xyron's Elite?");
}

sub EVENT_COMBAT {
    if ($combat_state == 1 && $zomm_spawned == 0) {
        my $target = $npc->GetHateTop();
        if ($target) {
            my $zomm = quest::spawn2(1876, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
            $zomm_spawned = 1;
            quest::settimer("send_zomm", 1);
        }
    } elsif ($combat_state == 0) {
        $zomm_spawned = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "send_zomm") {
        quest::stoptimer("send_zomm");

        my $target = $npc->GetHateTop();
        if ($target) {
            my @npcs = $entity_list->GetNPCList();
            foreach my $e (@npcs) {
                if ($e->GetNPCTypeID() == 1876 && $e->CalculateDistance($npc) < 50) {
                    $e->AddToHateList($target, 1);
                    $e->Attack($target);
                }
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("May you burn, slowly, and painfully!");
    if (!quest::isnpcspawned(44133)) {
        quest::spawn2(44133, 0, 0, 254.51, 105.19, -25.50, 383.50);
    }
}
