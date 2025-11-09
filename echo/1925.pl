sub EVENT_SPAWN {
    return unless $npc;

    quest::shout("Guards, stand ready!");
    $npc->SetLevel(63);

    my %stats = (
        ac                   => 15000,
        max_hp               => 2750000,
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

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    my $npc_id = 153095;

    my $already_spawned = eval { quest::isnpcspawned($npc_id) };
    if (defined $already_spawned && !$already_spawned) {
        quest::spawn2($npc_id, 0, 0, -312.44, 1164.53, -15.23, 387.75);
    }
}
