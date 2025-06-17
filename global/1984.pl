sub EVENT_SPAWN {
    return unless $npc;

    # Visuals
    $npc->AddNimbusEffect(462);

    # Delay tint and buff to ensure visual consistency
    quest::settimer("init_effects", 1);

    # Apply stats
    my %stats = (
        ac                   => 20000,
        max_hp               => 7000000,
        min_hit              => 9000,
        max_hit              => 11000,
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

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Item drop logic
    my $item_id = 33208;

    # Always drop 1 item
    $npc->AddItem($item_id);

    # 25% chance to drop a second
    if (int(rand(100)) < 27) {
        $npc->AddItem($item_id);
    }

    # 10% chance to drop a third
    if (int(rand(100)) < 12) {
        $npc->AddItem($item_id);
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        # Apply visual tint
        $npc->SetNPCTintIndex(53);

        # Apply buff spell (e.g., 13378) directly to self
        $npc->CastSpell(13378, $npc->GetID()) if !$npc->FindBuff(13378);
    }
}