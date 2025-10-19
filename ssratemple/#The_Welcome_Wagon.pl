my $minions_spawned = 0;
my $checked_mirror  = 0;

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    quest::shout("Hahhahaha! Well well well, my old friend. Still at it are you? She will consume you in the planes, you know this right?");

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

    # === Base stats ===
    my $base_level    = 75;
    my $base_ac       = 29000;
    my $base_hp       = 145000000;
    my $base_regen    = 1700;
    my $base_min_hit  = 32000;
    my $base_max_hit  = 77000;
    my $base_atk      = 1600;
    my $base_accuracy = 1800;
    my $base_delay    = 9;
    my $base_hs       = 26;

    # === Apply scaled stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level",        $base_level);
    $npc->ModifyNPCStat("ac",           int($base_ac       * $scale));
    $npc->ModifyNPCStat("max_hp",       int($base_hp       * $scale));
    $npc->ModifyNPCStat("hp_regen",     int($base_regen    * $scale));
    $npc->ModifyNPCStat("mana_regen",   10000);
    $npc->ModifyNPCStat("min_hit",      int($base_min_hit  * $scale));
    $npc->ModifyNPCStat("max_hit",      int($base_max_hit  * $scale));
    $npc->ModifyNPCStat("atk",          int($base_atk      * $scale));
    $npc->ModifyNPCStat("accuracy",     int($base_accuracy * $scale));
    $npc->ModifyNPCStat("avoidance",    100);

    # Attack delay (capped at 4)
    my $new_delay = $base_delay - ($client_count - 4);
    $new_delay = 4 if $new_delay < 4;
    $npc->ModifyNPCStat("attack_delay", $new_delay);

    $npc->ModifyNPCStat("attack_speed",     100);
    $npc->ModifyNPCStat("slow_mitigation",  80);
    $npc->ModifyNPCStat("attack_count",     100);

    # Heroic strikethrough scaling (34 base, +1 per client > 4, capped at 38)
    my $new_hs = $base_hs + ($client_count - 4);
    $new_hs = 34 if $new_hs < 34;
    $new_hs = 38 if $new_hs > 38;
    $npc->ModifyNPCStat("heroic_strikethrough", $new_hs);

    $npc->ModifyNPCStat("aggro",  55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes ===
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
    $npc->ModifyNPCStat("physical_resist",   800);

    # === Traits ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # ✅ Guaranteed loot
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

    # Finalize HP after scaling
    $npc->SetHP($npc->GetMaxHP());

    $minions_spawned = 0;
    $checked_mirror  = 0;

    quest::setnexthpevent(75);
    quest::settimer("init_effects", 1);
    quest::settimer("lunar_nimbus_buff", 8);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 10);
        quest::settimer("luclin_strike", 30);
        quest::settimer("mirror_check", 5);
        quest::setnexthpevent(75) if $minions_spawned == 0;
    } else {
        quest::stoptimer("spell_cast");
        quest::stoptimer("luclin_strike");
        quest::stoptimer("mirror_check");
        $checked_mirror = 0;
    }
}

sub EVENT_HP {
    if ($hpevent == 75 && $minions_spawned < 1) {
        Call_For_Help(3);
        $minions_spawned = 1;
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50 && $minions_spawned < 2) {
        Call_For_Help(3);
        $minions_spawned = 2;
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25 && $minions_spawned < 3) {
        Call_For_Help(4);
        $minions_spawned = 3;
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");
        my @buffs = (10031, 10013, 10664, 9414, 300, 15031, 2530);
        foreach my $spell_id (@buffs) {
            $npc->SpellFinished($spell_id, $npc);
        }
    }
    elsif ($timer eq "lunar_nimbus_buff") {
        quest::stoptimer("lunar_nimbus_buff");
        $npc->CastSpell(21386, $npc->GetID()) if !$npc->FindBuff(21386);
    }
    elsif ($timer eq "spell_cast") {
        quest::castspell(40783, $npc->GetID());
    }
    elsif ($timer eq "luclin_strike") {
        return unless $npc->IsEngaged();
        $npc->Shout("My Wrath is unleashed!");
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        my $dmg = 100000;
        my $radius = 50;
        my $excluded = plugin::GetExclusionList();

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c;
            $c->Damage($npc, $dmg, 0, 1, false) if $c->CalculateDistance($x, $y, $z) <= $radius;
            my $pet = $c->GetPet();
            if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                next if $excluded->{$pet->GetNPCTypeID()};
                $pet->Damage($npc, $dmg, 0, 1, false);
            }
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b;
            $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;
            my $pet = $b->GetPet();
            if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                next if $excluded->{$pet->GetNPCTypeID()};
                $pet->Damage($npc, $dmg, 0, 1, false);
            }
        }
    }
    elsif ($timer eq "mirror_check") {
        return if $checked_mirror;
        my $hp_pct = int($npc->GetHPRatio());
        return if $hp_pct > 80 || $hp_pct < 10;

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            next if $client->GetHP() <= 0;

            my $item = $client->GetItemAt(22);
            my $item_id = $item ? $item->GetID() : 0;
            my $has_mirror = ($item_id == 49764);
            my $buff = $client->FindBuff(40778);
            my $has_buff = defined $buff && $buff;

            next unless $has_mirror && $has_buff;

            my $roll = int(rand(100));
            if ($roll < 25) {
                quest::shout("The mirror cracks... and something darker stirs.");
                $npc->ModifyNPCStat("max_hp", int($npc->GetMaxHP() * 1.5));
                $npc->ModifyNPCStat("min_hit", int($npc->GetMinDMG() * 1.5));
                $npc->ModifyNPCStat("max_hit", int($npc->GetMaxDMG() * 1.5));
                $npc->ModifyNPCStat("atk", int($npc->GetATK() * 1.5));
                $npc->ModifyNPCStat("attack_delay", 5);
                $npc->ModifyNPCStat("heroic_strikethrough", 35);
                $npc->SetHP($npc->GetMaxHP());
                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
                $npc->SetNPCTintIndex(30);

                my $base_name = $npc->GetCleanName();
                my $title_tag = "the Reflected";
                my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
                $npc->TempName($new_name);
                $npc->ModifyNPCStat("lastname", "Reflected");

                my @reflected_loot = (51985, 54955, 54956, 54957, 54958);
                $npc->AddItem($reflected_loot[int(rand(@reflected_loot))]);
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }
    }
}

sub Call_For_Help {
    my ($num_adds) = @_;
    $num_adds ||= 6;  # Fallback to 6 if somehow called without parameter

    quest::shout("Minions of darkness, lend me your strength!");
    my $top = $npc->GetHateTop();
    return unless $top;

    foreach my $mob ($entity_list->GetNPCList()) {
        next unless $mob && $mob->GetID() != $npc->GetID();
        my $dist = $npc->CalculateDistance($mob);
        $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
    }

    my @add_npcs = (2179, 2180);
    for (1..$num_adds) {
        my $chosen = $add_npcs[int(rand(@add_npcs))];
        quest::spawn2($chosen, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    my @death_lines = (
        "Your journey ends here... in the reflection that stares back forever.",
        "You have crossed into the Plane of Endless Reflections, where truth and madness are one.",
        "The mirror shatters... and now you see the Plane as it truly is — your eternal prison.",
        "Look closely — it is not me you face, but the shadow of your own fate.",
        "The Midnight Mirror cracks... Nyseria waits beyond, and her Coven watches from the void between planes."
    );
    quest::shout($death_lines[int(rand(@death_lines))]);
    quest::stoptimer("spell_cast");
    quest::stoptimer("luclin_strike");
}