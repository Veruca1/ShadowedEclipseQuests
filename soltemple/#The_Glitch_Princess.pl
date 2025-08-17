sub EVENT_SPAWN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Base stats and combat config
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 90000000); 
    $npc->ModifyNPCStat("hp_regen", 500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 25000);
    $npc->ModifyNPCStat("max_hit", 70000);
    $npc->ModifyNPCStat("atk", 1500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 19);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Stat attributes
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # Resistances
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # Visibility and special traits
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    $npc->SetHP($npc->GetMaxHP());

    ## --- Black Mirror visual & buff applied immediately ---
    $npc->SetNPCTintIndex(30);
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    ## --- Spell set for 2195 ---
    quest::set_data("mirror_spellset", "40786,40787");

    ## --- Start spell casting timer (30 seconds) ---
    quest::settimer("cast_cycle", 20);

    # Cast Mirror Transformation Buff if not already active
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    # --- Add title on transform ---
    my $base_name = $npc->GetCleanName();
    my $title_tag = "the Reflected";
    my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
    $npc->TempName($new_name);
    $npc->ModifyNPCStat("lastname", "Reflected");
    # --- end title ---
}

sub EVENT_TIMER {
    if ($timer eq "cast_cycle") {
        my $data = quest::get_data("mirror_spellset") || "";
        my @spells = split(/,/, $data);
        return unless @spells;

        my $spell_id = $spells[int(rand(@spells))];
        my $target = $npc->GetHateRandom();
        $npc->CastSpell($spell_id, $target->GetID()) if $target;
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(2193, 87);
}