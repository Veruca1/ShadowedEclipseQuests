# ===========================================================
# default.pl — Wakening Lands (wakening)
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
        1752,      # Wuoshi
        1699,      # Disembodied Voice
        1743,      # Rhaenyra_Elarian
        1407,      # lesser disturbance
        10         # zone_controller
    );
    return if exists $exclusion_list->{$npc_id};

    # ===========================================================
    # General setup
    # ===========================================================
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    # === Baseline stats ===
    my $base_stats = $is_boss ? {
        level       => 60,
        ac          => 20000,
        max_hp      => 2750000,
        hp_regen    => 2500,
        min_hit     => 7700,
        max_hit     => 8700,
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
    } : {
        level       => 55,
        ac          => 9500,
        max_hp      => 275000,
        hp_regen    => 700,
        min_hit     => 4700,
        max_hit     => 5700,
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

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Wakening
    my $wakening_zone_id = 119;

    # Check if the current zone is Wakening
    if ($zoneid == $wakening_zone_id) {
        # Define the chance to spawn NPC
        my $chance_to_spawn = 13; # 13% chance

        # Generate a random number between 1 and 100
        my $random_chance = int(rand(100)) + 1;

        # Only proceed if the random number is less than or equal to the chance to spawn
        if ($random_chance <= $chance_to_spawn) {
            # Get the location of the dead NPC
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();

            # Spawn NPC 1745 at the death location
            quest::spawn2(1745, 0, 0, $x, $y, $z, $h);
        }
    }
}
