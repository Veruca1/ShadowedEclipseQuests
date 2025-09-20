my $is_boss      = 0;
my $scaled_spawn = 0;  # track if scaling already applied at spawn

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusion list check
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Boss flag
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    if ($is_boss) {
        # --- Boss baseline stats ---
        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 30000000);
        $npc->ModifyNPCStat("hp_regen", 3000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 55000);
        $npc->ModifyNPCStat("max_hit", 75000);
        $npc->ModifyNPCStat("atk", 2500);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 50);
        $npc->ModifyNPCStat("attack_delay", 6);
        $npc->ModifyNPCStat("heroic_strikethrough", 33);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("mr", 400);
        $npc->ModifyNPCStat("fr", 400);
        $npc->ModifyNPCStat("cr", 400);
        $npc->ModifyNPCStat("pr", 400);
        $npc->ModifyNPCStat("dr", 400);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat(
            "special_abilities",
            "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1"
        );

        # Apply scaling once on spawn
        plugin::RaidScaling($entity_list, $npc);
        $scaled_spawn = 1;  # mark as scaled
    }

    # Full heal
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1 && $is_boss) {
        # Only apply scaling if not already scaled at spawn
        if (!$scaled_spawn) {
            plugin::RaidScaling($entity_list, $npc);
            $scaled_spawn = 1; # mark to block further scaling
        }

        quest::debug("[Boss] Combat started, setting spider timers");
        quest::settimer("spider_first", 2);   # first wave after 2s
        quest::settimer("spider_loop", 20);   # repeating waves every 20s
    } else {
        quest::debug("[Boss] Combat ended, stopping spider timers");
        quest::stoptimer("spider_first");
        quest::stoptimer("spider_loop");

        # Optional: depop remaining spiders when boss leashes
        quest::depopall(205161);
        quest::depopall(205162);
    }
}

sub EVENT_TIMER {
    return unless $npc;

    # get boss loc each time
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    if ($timer eq "spider_first") {
        quest::debug("[Boss] Spider first wave spawning at boss loc...");
        quest::spawn2(205161, 0, 0, $x+5, $y+5, $z, $h);
        quest::spawn2(205161, 0, 0, $x-5, $y-5, $z, $h);
        quest::stoptimer("spider_first"); # one-time
    }
    elsif ($timer eq "spider_loop") {
        quest::debug("[Boss] Spider loop wave spawning at boss loc...");
        quest::spawn2(205161, 0, 0, $x+10, $y, $z, $h);
        quest::spawn2(205161, 0, 0, $x-10, $y, $z, $h);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::depopall(205161);
    quest::depopall(205162);
}