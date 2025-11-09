# ===========================================================
# default.pl — Iceclad Ocean (iceclad)
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
        110043,    # Balix_Misteyes
        1615,      # an_empty_chest
        110083,    # Icebreaker
        110085,    # turtle_shouter
        110096,    # Commander_Vjorik
        110108,    # Vas_Thorel
        110114,    # Seal_Spawn
        110115,    # _#_6
        110118,    # General_Bragmur_
        110033,    # General_Bragmur
        110072     # Soulbinder_Cubnitskin
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
        ac          => 18000,
        max_hp      => 1000000,
        hp_regen    => 2000,
        min_hit     => 4000,
        max_hit     => 5500,
        atk         => 1000,
        accuracy    => 1000,
        hst         => 7,
        slow_mit    => 70,
        aggro       => 50,
        assist      => 1,
        str       => 900, sta => 900, agi => 900, dex => 900,
        wis       => 900, int => 900, cha => 700,
        mr        => 200, fr => 200, cr => 200, pr => 200, dr => 200,
        corr      => 200, phys => 500,
        sa        => "3,1^5,1^7,1^8,1^9,1",
    } : {
        level       => 55,
        ac          => 9000,
        max_hp      => 150000,
        hp_regen    => 600,
        min_hit     => 3500,
        max_hit     => 4500,
        atk         => 800,
        accuracy    => 800,
        hst         => 3,
        slow_mit    => 55,
        aggro       => 45,
        assist      => 1,
        str       => 700, sta => 700, agi => 700, dex => 700,
        wis       => 700, int => 700, cha => 500,
        mr        => 150, fr => 150, cr => 150, pr => 150, dr => 150,
        corr      => 120, phys => 300,
        sa        => "3,1^5,1^7,1",
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