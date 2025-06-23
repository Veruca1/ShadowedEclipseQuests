# 1986.pl

sub EVENT_SPAWN {
    return unless $npc;

    quest::settimer("init_effects", 1);

    # Apply stats
    my %stats = (
        ac                   => 20000,
        max_hp               => 7000000,
        min_hit              => 10000,
        max_hit              => 15000,
        accuracy             => 2000,
        avoidance            => 90,
        slow_mitigation      => 90,
        attack               => 1400,
        str                  => 1200,
        sta                  => 1200,
        dex                  => 1200,
        agi                  => 1200,
        int                  => 1200,
        wis                  => 1200,
        cha                  => 1000,
        physical_resist      => 1000,
        hp_regen_rate        => 1000,
        hp_regen_per_second  => 500,
        special_attacks      => "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1",
    );

    while (my ($stat, $value) = each %stats) {
        $npc->ModifyNPCStat($stat, "$value");
    }

    $npc->SetHP($npc->GetMaxHP());

    # Set first HP event at 75%
    quest::setnexthpevent(75);
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");
        $npc->SetNPCTintIndex(40);

        # Apply spell 12880 to self
        $npc->CastSpell(12880, $npc->GetID());
    }
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 75 || $hpevent == 25) {
        if ($npc->FindBuff(40745)) {
            plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the mountains, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }

        # Set the next HP event
        quest::setnexthpevent(25) if $hpevent == 75;
    }
}

sub EVENT_DEATH {
    # Send signal 99 to the zone controller (NPC ID 10)
    quest::signalwith(10, 99);
}