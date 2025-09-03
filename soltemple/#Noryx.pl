sub EVENT_SPAWN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # === Player count detection ===
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }

    # === Scaling multiplier (raid starts at 5 clients) ===
    my $scale = 1.0;
    if ($client_count > 5) {
        $scale = 1.0 + 0.1 * ($client_count - 5);  # 6=1.1x, 7=1.2x, etc.
    }

    # === Base stats ===
    my $base_level    = 75;
    my $base_ac       = 20000;
    my $base_hp       = 90000000;
    my $base_regen    = 500;
    my $base_min_hit  = 45000;
    my $base_max_hit  = 80000;
    my $base_atk      = 1500;
    my $base_accuracy = 1800;
    my $base_delay    = 5;
    my $base_hs       = 36;

    # === Apply scaled stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", $base_level);
    $npc->ModifyNPCStat("ac",          int($base_ac       * $scale));
    $npc->ModifyNPCStat("max_hp",      int($base_hp       * $scale));
    $npc->ModifyNPCStat("hp_regen",    int($base_regen    * $scale));
    $npc->ModifyNPCStat("mana_regen",  10000);
    $npc->ModifyNPCStat("min_hit",     int($base_min_hit  * $scale));
    $npc->ModifyNPCStat("max_hit",     int($base_max_hit  * $scale));
    $npc->ModifyNPCStat("atk",         int($base_atk      * $scale));
    $npc->ModifyNPCStat("accuracy",    int($base_accuracy * $scale));
    $npc->ModifyNPCStat("avoidance",   100);

    # Attack delay (capped min 4)
    my $new_delay = $base_delay - ($client_count - 5);
    $new_delay = 4 if $new_delay < 4;
    $npc->ModifyNPCStat("attack_delay", $new_delay);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);

    # Heroic strikethrough (capped 38)
    my $new_hs = int($base_hs * $scale);
    $new_hs = 38 if $new_hs > 38;
    $npc->ModifyNPCStat("heroic_strikethrough", $new_hs);

    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Stat attributes ===
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # === Visibility and traits ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # Full heal to new max
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    ## --- Black Mirror tint & Nimbus buff ---
    $npc->SetNPCTintIndex(30);
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    ## --- Assign spell set ---
    quest::set_data("mirror_spellset", "40784,40785");
    quest::settimer("cast_cycle", 60);

    ## --- Reflected Title ---
    my $base_name = $npc->GetCleanName();
    my $title_tag = "the Reflected";
    my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
    $npc->TempName($new_name);
    $npc->ModifyNPCStat("lastname", "Reflected");

    # === HP events ===
    quest::setnexthpevent(80);
}

sub EVENT_AGGRO {
    quest::shout("⚠️ ALERT: Unauthorized access detected. Initiating quarantine protocols."); 
}

sub EVENT_HP {
    if ($hpevent == 80) {
        for my $h ($npc->GetHateList()) {
            my $ent = $h->GetEnt();
            next unless $ent && $ent->IsClient() && !$ent->IsPet();
            my $client = $ent->CastToClient() or next;

            my $inst = $client->GetInstanceID();
            $client->MovePCInstance(80, $inst, -72.57, 436.88, 29.88, 371.75);
            $npc->Shout("User flagged as malicious process. Relocating to Quarantine Node B.");
            last;
        }
        quest::setnexthpevent(50);

    } elsif ($hpevent == 50) {
        for my $h ($npc->GetHateList()) {
            my $ent = $h->GetEnt();
            next unless $ent && $ent->IsClient() && !$ent->IsPet();
            my $client = $ent->CastToClient() or next;

            my $inst = $client->GetInstanceID();
            $client->MovePCInstance(80, $inst, 83.45, 415.05, 29.88, 390.00);
            $npc->Shout("Suspicious code detected. Redirecting to Quarantine Node A.");
            last;
        }
        quest::setnexthpevent(15);

    } elsif ($hpevent == 15) {
        for my $h ($npc->GetHateList()) {
            my $ent = $h->GetEnt();
            next unless $ent && $ent->IsClient() && !$ent->IsPet();
            my $client = $ent->CastToClient() or next;

            my $inst = $client->GetInstanceID();
            $client->MovePCInstance(80, $inst, 29.08, 552.99, 17.88, 125.25);
            $npc->Shout("Final warning. Infectious process isolated in Quarantine Node C.");
            last;
        }
    }
}