sub EVENT_SPAWN {
    return unless $npc;

    my $base_stats = {
        level       => 55,
        ac          => 9500,
        max_hp      => 100000,
        hp_regen    => 700,
        min_hit     => 3600,
        max_hit     => 4800,
        atk         => 850,
        accuracy    => 850,
        hst         => 4,
        slow_mit    => 60,
        aggro       => 45,
        assist      => 1,
        str => 750, sta => 750, agi => 750, dex => 750,
        wis => 750, int => 750, cha => 550,
        mr => 160, fr => 160, cr => 160, pr => 160, dr => 160,
        corr => 130, phys => 320,
        sa => "3,1^5,1^7,1",
    };

    $npc->SetNPCFactionID(623);
    _apply_trash_stats($base_stats);

    $npc->ModifyNPCStat("attack_delay", 7);
    plugin::RaidScaling($entity_list, $npc);
    $npc->ModifyNPCStat("heroic_strikethrough", $base_stats->{hst});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub _apply_trash_stats {
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
    quest::signalwith(10, 1, 0); # Signal NPC ID 10 with signal value 1
}