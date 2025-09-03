# Boss: Jim
# Baseline max HP = 20,000,000 for group
# Raid scaling applies the same multiplier across key stats (HP, AC, hits, etc.)

sub EVENT_SPAWN {
    return unless $npc;
    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusions
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Faction
    $npc->SetNPCFactionID(623);

    # --- Raid detection (6+ living clients; bots are NPCs, so they aren't counted) ---
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }
    my $is_raid = ($client_count >= 6) ? 1 : 0;

    # --- Scaling multiplier ---
    my $scale = $is_raid ? 1.5 : 1.0;

    # --- Core stats (baseline → scaled if raid) ---
    my $base_level    = 62;
    my $base_ac       = 20000;
    my $base_hp       = 20000000;          # <-- 20,000,000 baseline
    my $base_regen    = 800;
    my $base_min_hit  = 24000;
    my $base_max_hit  = 70000;
    my $base_atk      = 2500;
    my $base_accuracy = 1800;
    my $base_hs       = 26;                # heroic strikethrough

    $npc->ModifyNPCStat("level", $base_level);
    $npc->ModifyNPCStat("ac",          int($base_ac       * $scale));
    $npc->ModifyNPCStat("max_hp",      int($base_hp       * $scale));  # 30,000,000 if raid
    $npc->ModifyNPCStat("hp_regen",    int($base_regen    * $scale));
    $npc->ModifyNPCStat("mana_regen",  10000);
    $npc->ModifyNPCStat("min_hit",     int($base_min_hit  * $scale));
    $npc->ModifyNPCStat("max_hit",     int($base_max_hit  * $scale));
    $npc->ModifyNPCStat("atk",         int($base_atk      * $scale));
    $npc->ModifyNPCStat("accuracy",    int($base_accuracy * $scale));
    $npc->ModifyNPCStat("avoidance",   50);
    $npc->ModifyNPCStat("attack_delay", $is_raid ? 8 : 10);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", $is_raid ? ($base_hs + 4) : $base_hs);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # Resists
    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # Vision / mechanics
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # Special abilities
    # 3=Immune to Melee?, 5=Summon, 7=Unsnareable, 8=Unrootable, 9=Unmez, 10=Uncharm, 14=Unstunable
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");

    # --- Aesthetics / Glitch Nimbus ---
    $npc->SetNPCTintIndex(30);                             # tint 30
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);  # Mirror/Glitch Nimbus buff

    # --- Ensure he’s named Jim (visual only, won’t change DB) ---
    my $name = $npc->GetCleanName() // '';
    if ($name !~ /^Jim\b/i) {
        $npc->TempName("Jim");
    }

    # --- Full heal to new max ---
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}