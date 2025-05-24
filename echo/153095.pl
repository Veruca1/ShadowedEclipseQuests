sub EVENT_SPAWN {
    # Remember to manually set faction, hp regen rate, spell resists, atk delay, aggro radius, ATK
    return unless $npc;

    $npc->SetLevel(63);
    quest::shout("I'll make this quick!");

    my %stats = (
        ac                   => 18000,
        max_hp               => 5500000,
        min_hit              => 7000,
        max_hit              => 8500,
        accuracy             => 2000,
        avoidance            => 90,
        slow_mitigation      => 90,
        atk                  => 1400,
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

    $npc->SetHP($npc->GetMaxHP());  # Ensure full HP after setting max_hp
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::setnexthpevent(50);
    }
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 50) {
        quest::shout("Guards! assist me!");

        my $top_hate_target = $npc->GetHateTop();
        return unless $top_hate_target && $top_hate_target->IsClient();

        my $npc_list = $entity_list->GetNPCList();
        return unless $npc_list;

        my $npc_iterator = $npc_list->Iterator();

        while (my $mob = $npc_iterator->()) {
            next unless $mob;
            next if $mob->GetID() == $npc->GetID();
            next unless $mob->GetNPCTypeID() == 1923;

            $mob->AddToHateList($top_hate_target, 1);
        }
    }
}