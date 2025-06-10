sub EVENT_SPAWN {
    return unless $npc;

    # Apply stats
    my %stats = (
        ac                   => 15000,
        max_hp               => 4500000,
        min_hit              => 7000,
        max_hit              => 8500,
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
    if (int(rand(100)) < 25) {
        $npc->AddItem($item_id);
    }

    # 10% chance to drop a third
    if (int(rand(100)) < 10) {
        $npc->AddItem($item_id);
    }
}
