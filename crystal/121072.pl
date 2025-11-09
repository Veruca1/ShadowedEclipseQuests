sub EVENT_SPAWN {
    return unless $npc;
     # On spawn, shout the message
    quest::shout("All hail Queen Dracnia!");

    my $is_boss = 1; # Force boss scaling for named

    my $base_stats = {
        level       => 60,
        ac          => 20000,
        max_hp      => 1100000,
        hp_regen    => 2500,
        min_hit     => 4500,
        max_hit     => 6500,
        atk         => 1200,
        accuracy    => 1100,
        hst         => 8,
        slow_mit    => 75,
        aggro       => 55,
        assist      => 1,
        str => 950, sta => 950, agi => 950, dex => 950,
        wis => 950, int => 950, cha => 750,
        mr => 220, fr => 220, cr => 220, pr => 220, dr => 220,
        corr => 220, phys => 550,
        sa => "3,1^5,1^7,1^8,1^9,1",
    };

    $npc->SetNPCFactionID(623);
    _apply_boss_stats($base_stats);

    $npc->ModifyNPCStat("attack_delay", 6);
    plugin::RaidScaling($entity_list, $npc);
    $npc->ModifyNPCStat("heroic_strikethrough", $base_stats->{hst});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub _apply_boss_stats {
    my ($s) = @_;

    $npc->ModifyNPCStat("level",     $s->{level});
    $npc->ModifyNPCStat("ac",        $s->{ac});
    $npc->ModifyNPCStat("max_hp",    $s->{max_hp});
    $npc->ModifyNPCStat("hp_regen",  $s->{hp_regen});
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   $s->{min_hit});
    $npc->ModifyNPCStat("max_hit",   $s->{max_hit});
    $npc->ModifyNPCStat("atk",       $s->{atk});
    $npc->ModifyNPCStat("accuracy",  $s->{accuracy});
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", $s->{hst});
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", $s->{slow_mit});
    $npc->ModifyNPCStat("aggro", $s->{aggro});
    $npc->ModifyNPCStat("assist", $s->{assist});

    $npc->ModifyNPCStat("str", $s->{str});
    $npc->ModifyNPCStat("sta", $s->{sta});
    $npc->ModifyNPCStat("agi", $s->{agi});
    $npc->ModifyNPCStat("dex", $s->{dex});
    $npc->ModifyNPCStat("wis", $s->{wis});
    $npc->ModifyNPCStat("int", $s->{int});
    $npc->ModifyNPCStat("cha", $s->{cha});

    $npc->ModifyNPCStat("mr", $s->{mr});
    $npc->ModifyNPCStat("fr", $s->{fr});
    $npc->ModifyNPCStat("cr", $s->{cr});
    $npc->ModifyNPCStat("pr", $s->{pr});
    $npc->ModifyNPCStat("dr", $s->{dr});
    $npc->ModifyNPCStat("corruption_resist", $s->{corr});
    $npc->ModifyNPCStat("physical_resist",   $s->{phys});

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", $s->{sa});
}

sub EVENT_DEATH_COMPLETE {
    # On death, send a signal to NPC ID 10
    quest::signalwith(10, 2, 0); # Signal NPC ID 10 with signal value 2
}
