# Global flag to track if mirror logic has already been triggered
my $checked_mirror = 0;
my $mirror_trigger_hp = 0;

my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # --- Player count detection (clients only) ---
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }

    # --- Scaling multiplier ---
    my $scale = 1.0;
    if ($client_count >= 5) {
        $scale = 1.0 + 0.25 * ($client_count - 4);  # 5=1.25, 6=1.5, 7=1.75, etc.
    }

    # --- Base stats (as-is from original) ---
    my $base_level    = 75;
    my $base_ac       = 20000;
    my $base_hp       = 90000000;
    my $base_regen    = 500;
    my $base_min_hit  = 25000;
    my $base_max_hit  = 70000;
    my $base_atk      = 1500;
    my $base_accuracy = 1800;
    my $base_delay    = 5;
    my $base_hs       = 37; # keep original base

    # --- Apply scaled stats ---
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

    # Attack delay (floored at 4)
    my $new_delay = $base_delay - ($client_count - 4);
    $new_delay = 4 if $new_delay < 4;
    $npc->ModifyNPCStat("attack_delay", $new_delay);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);

    # Heroic strikethrough scaling (base 37, +1 per client above 4, capped 38)
    my $new_hs = $base_hs + ($client_count - 4);
    $new_hs = 37 if $new_hs < 37;
    $new_hs = 38 if $new_hs > 38;
    $npc->ModifyNPCStat("heroic_strikethrough", $new_hs);

    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # --- Stat attributes ---
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # --- Resistances ---
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # --- Traits ---
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # --- Loot ---
    my $veru = plugin::verugems();
    my @veru_ids = keys %$veru;
    $npc->AddItem($veru_ids[int(rand(@veru_ids))]);

    my $gear = plugin::ch6classgear();
    my @gear_ids = map { @{$gear->{$_}} } keys %$gear;
    for (1..5) {
        $npc->AddItem($gear_ids[int(rand(@gear_ids))]);
    }

    my $cred = plugin::huntercred();
    my @cred_ids = keys %$cred;
    for (1..5) {
        $npc->AddItem($cred_ids[0]);
    }

    # Set HP to scaled max
    $npc->SetHP($npc->GetMaxHP());

    $checked_mirror = 0;
    $wrath_triggered = 0;
    quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        $checked_mirror = 0;
        quest::stoptimer("mirror_check");
    }
}

sub EVENT_HP {
    if ($hpevent == 80 && !$checked_mirror) {
        $mirror_trigger_hp = int(rand(69)) + 11;
        quest::settimer("mirror_check", 5);
    }

    # --- Mandatory Call for Help at 80% and 30% ---
    if ($hpevent == 80 || $hpevent == 30) {
        quest::shout("Minions of darkness, lend me your strength!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }

        # --- Spawn 3 random adds (NPCIDs 2179, 2180) ---
        my @add_npcs = (2179, 2180);
        for (4..6) {
            my $chosen = $add_npcs[int(rand(@add_npcs))];
            quest::spawn2($chosen, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        }

        if ($hpevent == 80) {
            quest::setnexthpevent(30);
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # --- Wrath of Luclin Logic ---
    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 100) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            return unless defined $x && defined $y && defined $z;
            my $radius = 50;
            my $dmg = 100000;

            my $excluded_npc_ids = plugin::GetExclusionList();

            foreach my $e ($entity_list->GetClientList()) {
                next unless $e;
                $e->Damage($npc, $dmg, 0, 1, false) if $e->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $e->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_npc_ids->{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }

            foreach my $b ($entity_list->GetBotList()) {
                next unless $b;
                $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $b->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_npc_ids->{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_TIMER {
    if ($timer eq "mirror_check") {
        return if $checked_mirror;

        my $hp_pct = int($npc->GetHPRatio());
        return if $hp_pct < 10 || $hp_pct > $mirror_trigger_hp;

        my $found_client = 0;
        my @clients = $entity_list->GetClientList();

        foreach my $client (@clients) {
            next unless $client && $client->GetHP() > 0;

            my $item = $client->GetItemAt(22);  # Ammo slot
            my $item_id = $item ? $item->GetID() : 0;
            my $has_mirror = ($item_id == 49764);

            my $buff_slot = $client->FindBuff(40778);
            my $has_buff = ($buff_slot != -1);

            next unless $has_mirror && $has_buff;
            $found_client = 1;

            my $roll = int(rand(100));
            if ($roll < 25) {
                quest::shout("The mirror cracks... and something darker stirs.");
                quest::settimer("mirror_tint", 1);

                my $new_hp     = int($npc->GetMaxHP() * 1.5);
                my $new_min    = int($npc->GetMinDMG() * 1.5);
                my $new_max    = int($npc->GetMaxDMG() * 1.5);
                my $new_atk    = int($npc->GetATK() * 1.5);
                my $new_hstrik = int($npc->GetNPCStat("heroic_strikethrough") || 0) + 1;

                $npc->ModifyNPCStat("max_hp", $new_hp);
                $npc->ModifyNPCStat("min_hit", $new_min);
                $npc->ModifyNPCStat("max_hit", $new_max);
                $npc->ModifyNPCStat("atk", $new_atk);
                $npc->ModifyNPCStat("attack_delay", 4);
                $npc->ModifyNPCStat("heroic_strikethrough", $new_hstrik);
                $npc->SetHP($npc->GetMaxHP());

                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

                my $base_name = $npc->GetCleanName();
                my $title_tag = "the Reflected";
                my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
                $npc->TempName($new_name);
                $npc->ModifyNPCStat("lastname", "Reflected");

                my @reflected_loot = (51987, 54945, 54946);
                $npc->AddItem($reflected_loot[int(rand(@reflected_loot))]);
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }

        if (!$found_client) {
            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
        }
    }

    elsif ($timer eq "mirror_tint") {
        quest::stoptimer("mirror_tint");
        $npc->SetNPCTintIndex(30);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(2182, 0, 0, -148.74, -745.93, -255.94, 94.50);
}