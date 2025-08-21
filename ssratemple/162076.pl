my $is_raid = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # Detect raid: 6+ real clients, exclude bots
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }
    $is_raid = ($client_count >= 6) ? 1 : 0;
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1 && $is_raid) {
        quest::settimer("raid_wrath_pulse", 10);
    } else {
        quest::stoptimer("raid_wrath_pulse");
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "raid_wrath_pulse" && $is_raid) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;

        my $radius = 50;
        my $dmg = 50000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }
    }
}