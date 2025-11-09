my @spawn_locs = (
    [-707.20, -174.74, -42.03, 7.75],
    [-564.95, -31.18, -43.63, 385.00],
    [-707.27, 109.83, -43.97, 256.00],
    [-851.28, -32.10, -43.57, 127.75]
);

sub EVENT_SPAWN {
    if (defined $npc) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 40000);
        $npc->ModifyNPCStat("max_hp", 5000000);
        $npc->SetHP($npc->GetMaxHP());
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8500);
        $npc->ModifyNPCStat("max_hit", 13000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 150);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 30);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("mr", 1000);
        $npc->ModifyNPCStat("fr", 1000);
        $npc->ModifyNPCStat("cr", 1000);
        $npc->ModifyNPCStat("pr", 1000);
        $npc->ModifyNPCStat("dr", 1000);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 0);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5^7,1^8,1^13,1^14,1^17,1^21,1^31,1^33,1");
    }
}

sub EVENT_COMBAT {
    if (defined $combat_state) {
        if ($combat_state == 1) {
            quest::shout("Knowledge is infection. Let me share what I’ve learned.");
            $spirit_ready = 1;
            quest::setnexthpevent(80);
        } elsif ($combat_state == 0) {
            $spirit_ready = 0;
        }
    }
}

sub EVENT_HP {
    return unless $spirit_ready;

    if ($hpevent == 80) {
        spawn_spirits();
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        spawn_spirits();
        quest::setnexthpevent(25);
    } elsif ($hpevent == 25) {
        spawn_spirits();
    }
}

sub spawn_spirits {
    quest::shout("Trapped spirits of the Lyceum, rise and obey! Do NOT use your wands of light on them!");

    my @shuffled = shuffle_array(@spawn_locs);
    my $num_spirits = int(rand(4)) + 1;
    $num_spirits = scalar(@shuffled) if $num_spirits > scalar(@shuffled);

    for (my $i = 0; $i < $num_spirits; $i++) {
        my $loc = $shuffled[$i];
        next unless defined $loc && ref($loc) eq 'ARRAY' && scalar(@$loc) == 4;
        my ($x, $y, $z, $h) = @$loc;
        quest::spawn2(1966, 0, 0, $x, $y, $z, $h);
    }
}

sub shuffle_array {
    my @array = @_;
    return () if scalar(@array) == 0;

    for (my $i = @array - 1; $i > 0; $i--) {
        my $j = int(rand($i + 1));
        next unless defined $array[$i] && defined $array[$j];
        @array[$i, $j] = @array[$j, $i];
    }
    return @array;
}

sub EVENT_DEATH_COMPLETE {
    if (int(rand(100)) < 20) {
        quest::spawn2(1976, 0, 0, $x, $y, $z, $h);
    }
}