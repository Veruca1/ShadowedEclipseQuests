# ===========================================================
# default.pl — Kael Drakkel (kael)
# Shadowed Eclipse Scaling System
# - Applies custom baseline stats to all non-excluded NPCs.
# - Uses RaidScaling for adaptive group power adjustment.
# ===========================================================

my $is_boss      = 0;
my $scaled_spawn = 0;  # prevent double scaling

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # ===========================================================
    # Exclusion list — ignore these NPCs for scaling/stat logic
    # ===========================================================
    my $exclusion_list = plugin::GetExclusionList();
    $exclusion_list->{$_} = 1 for (
        10,    # zone_controller
        1764   # Announcer_Michael_Buffer_of_Frostbane
    );
    return if exists $exclusion_list->{$npc_id};

    # ===========================================================
    # General setup
    # ===========================================================
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    # === Baseline stats ===
    my $base_stats = $is_boss ? {
        level       => 65,
        ac          => 25000,
        max_hp      => 2000000,
        hp_regen    => 3000,
        min_hit     => 9500,
        max_hit     => 12500,
        atk         => 1400,
        accuracy    => 1200,
        hst         => 10,
        slow_mit    => 85,
        aggro       => 60,
        assist      => 1,
        str => 1100, sta => 1100, agi => 1100, dex => 1100,
        wis => 1000, int => 1000, cha => 850,
        mr => 260, fr => 260, cr => 260, pr => 260, dr => 260,
        corr => 260, phys => 650,
        sa => "3,1^5,1^7,1^8,1^9,1^12,1",
    } : {
        level       => 58,
        ac          => 12500,
        max_hp      => 120000,
        hp_regen    => 800,
        min_hit     => 6200,
        max_hit     => 7400,
        atk         => 950,
        accuracy    => 900,
        hst         => 5,
        slow_mit    => 65,
        aggro       => 50,
        assist      => 1,
        str => 850, sta => 850, agi => 850, dex => 850,
        wis => 800, int => 800, cha => 600,
        mr => 180, fr => 180, cr => 180, pr => 180, dr => 180,
        corr => 140, phys => 360,
        sa => "3,1^5,1^7,1",
    };

    _apply_baseline($base_stats);
    $npc->ModifyNPCStat("attack_delay", $is_boss ? 6 : 7);

    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;
    $npc->ModifyNPCStat("heroic_strikethrough", $base_stats->{hst});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub _apply_baseline {
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
    $npc->ModifyNPCStat("avoidance", 55);
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

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    # === Kael-specific rare spawn logic ===
    my $kael_zone_id = 113;
    if ($zoneid == $kael_zone_id) {
        my $chance_to_spawn = 10; # 10% chance
        my $roll = int(rand(100)) + 1;

        if ($roll <= $chance_to_spawn) {
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();

            # Example: spawn #Keldor_the_Cold-Hearted (custom rare)
            quest::spawn2(1188, 0, 0, $x, $y, $z, $h);
        }
    }
}