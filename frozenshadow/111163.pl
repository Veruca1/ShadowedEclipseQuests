my $crabbe_summoned = 0;
my $goyle_summoned = 0;

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("slytherin_wrath", 5);   # AoE magic every 5 seconds
        quest::settimer("draco_taunt", 30);      # Taunt every 30 seconds
        quest::settimer("hp_check", 2);         # HP check every 2 seconds

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Draco Malfoy sneers: 'Oh, this is just rich. You think you can fight *me*?'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("slytherin_wrath");
        quest::stoptimer("draco_taunt");
        quest::stoptimer("hp_check");
        $crabbe_summoned = 0;
        $goyle_summoned = 0;
    }
}

sub EVENT_TIMER {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 50;  # Damage radius

    if ($timer eq "slytherin_wrath") {
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $damage = 700 + int(rand(500)); # Randomized damage between 700-1200
                $entity->Damage($npc, $damage, 0, 1, false);
                $entity->Message(14, "Draco Malfoy flicks his wand with a smirk, unleashing a hex that lashes at you with Slytherin fury!");
            }
        }
    }
    elsif ($timer eq "draco_taunt") {
        my @taunts = (
            "Draco scoffs: 'Is that all you've got? My *house elves* could fight better than you!'",
            "Draco smirks: 'Pathetic. I bet you’re a Mudblood, aren't you?'",
            "Draco yells: 'You’ll pay for this! My father will hear about it!'",
            "Draco laughs: 'You might as well surrender now. I *always* win.'"
        );
        my $random_taunt = $taunts[rand @taunts];

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, $random_taunt);
        }
    }
    elsif ($timer eq "hp_check") {
        my $hp_percent = ($npc->GetHP() / $npc->GetMaxHP());

        if ($hp_percent <= 0.75 && $crabbe_summoned == 0) {
            $crabbe_summoned = 1;
            quest::shout("'Crabbe! Get over here and deal with these losers!'");
            quest::spawn2(1736, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading()); # Spawns Crabbe
        }

        if ($hp_percent <= 0.35 && $goyle_summoned == 0) {
            $goyle_summoned = 1;
            quest::shout("'Goyle, you idiot! Help me out here!'");
            quest::spawn2(1737, 0, 0, $npc->GetX() - 5, $npc->GetY() - 5, $npc->GetZ(), $npc->GetHeading()); # Spawns Goyle
        }
    }
}
