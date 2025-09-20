sub EVENT_SPAWN {
    return unless $npc;

    # Exclusion list check (optional)
    my $exclusion_list = plugin::GetExclusionList();
    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if exists $exclusion_list->{$npc_id};

    # Get scaling from plugin (pass $entity_list)
    my ($multiplier, $hst_increase, $delay_reduction, $client_count) = plugin::RaidScaling($entity_list);

    # --- Trash mob baseline stats ---
    my $base_ac       = 20000;
    my $base_hp       = 3000000;
    my $base_regen    = 800;
    my $base_min_hit  = 44000;
    my $base_max_hit  = 55000;
    my $base_atk      = 2500;
    my $base_accuracy = 1800;
    my $base_hst      = 28;
    my $base_delay    = 10;

    # Apply scaling
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", int($base_ac * $multiplier));
    $npc->ModifyNPCStat("max_hp", int($base_hp * $multiplier));
    $npc->ModifyNPCStat("hp_regen", int($base_regen * $multiplier));
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", int($base_min_hit * $multiplier));
    $npc->ModifyNPCStat("max_hit", int($base_max_hit * $multiplier));
    $npc->ModifyNPCStat("atk", int($base_atk * $multiplier));
    $npc->ModifyNPCStat("accuracy", int($base_accuracy * $multiplier));
    $npc->ModifyNPCStat("avoidance", 50);

    # Adjusted values from plugin
    my $hst   = $base_hst + $hst_increase;
    $hst = 40 if $hst > 40;

    my $delay = $base_delay - $delay_reduction;
    $delay = 4 if $delay < 4;

    $npc->ModifyNPCStat("attack_delay", $delay);
    $npc->ModifyNPCStat("heroic_strikethrough", $hst);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");

    # Reset HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Start the adds timer
    quest::settimer("adds", 10);  # 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "adds") {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(205162, 0, 0, $x, $y, $z, $h); # NPC: a_bubonian_cronie
        quest::stoptimer("adds");
    }
}