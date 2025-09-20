sub EVENT_SPAWN {
    quest::settimer(1, 600);  # Depop after 10 minutes
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::setglobal("pop_cod_bertox", 1, 5, "F");  # Flag for killing Bertox
        $client->Message(4, "You receive a character flag!");

        # --- Begin group/raid zone flag propagation ---
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();
        my $flagged = 0;

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(204);  # PoN zone flag
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to the Plane of Nightmares.");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(204);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to the Plane of Nightmares.");
            }
        } else {
            $client->SetZoneFlag(204);
            quest::we(14, "$name has earned access to the Plane of Nightmares.");
        }
        # --- End group/raid zone flag propagation ---
    }

    {
        $pop_cod_bertox = undef;
    }
}

sub EVENT_TIMER {
    if ($timer == 1) {
        quest::depop();
    }
}