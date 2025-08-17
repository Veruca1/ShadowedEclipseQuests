my $minions_spawned = 0;
my $checked_mirror = 0;

sub EVENT_SPAWN {
    return unless $npc;
    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    quest::shout("Hahhahaha! Well well well, my old friend. Still at it are you? She will consume you in the planes, you know this right?");

    # Base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 29000);
    $npc->ModifyNPCStat("max_hp", 145000000);
    $npc->ModifyNPCStat("hp_regen", 1700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 42000);
    $npc->ModifyNPCStat("max_hit", 82000);
    $npc->ModifyNPCStat("atk", 1700);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 20);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # Heal to full
    $npc->SetHP($npc->GetMaxHP()) if $npc->GetMaxHP() > 0;

    # Buffs, nimbus, HP events
    $minions_spawned = 0;
    $checked_mirror = 0;
    quest::setnexthpevent(75);
    quest::settimer("init_effects", 1);
    quest::settimer("lunar_nimbus_buff", 8);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 10);
        quest::settimer("mirror_check", 5);
        quest::setnexthpevent(75) if $minions_spawned == 0;
    } else {
        quest::stoptimer("spell_cast");
        quest::stoptimer("mirror_check");
        $checked_mirror = 0;
    }
}

sub EVENT_HP {
    if ($hpevent == 75 && $minions_spawned < 1) {
        Summon_Minions(1);
        $minions_spawned = 1;
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50 && $minions_spawned < 2) {
        Summon_Minions(2);
        $minions_spawned = 2;
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25 && $minions_spawned < 3) {
        Summon_Minions(3);
        $minions_spawned = 3;
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        my @buffs = (
            5278, 5297, 5488, 10028, 10031,
            10013, 10664, 9414, 300, 15031, 2530
        );
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
            my $has_buff   = $client->FindBuff(40778);

            # Require both the item and the buff
            next unless $has_mirror && $has_buff;

            my $roll = int(rand(100));
            if ($roll < 25) {
                quest::shout("The mirror cracks... and something darker stirs.");
                $npc->ModifyNPCStat("max_hp", int($npc->GetMaxHP() * 1.5));
                $npc->ModifyNPCStat("min_hit", int($npc->GetMinDMG() * 1.5));
                $npc->ModifyNPCStat("max_hit", int($npc->GetMaxDMG() * 1.5));
                $npc->ModifyNPCStat("atk", int($npc->GetATK() * 1.5));
                $npc->ModifyNPCStat("attack_delay", 5);
                $npc->ModifyNPCStat("heroic_strikethrough", 24);
                $npc->SetHP($npc->GetMaxHP());
                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
                $npc->SetNPCTintIndex(30);

                # --- Add title on transform ---
                my $base_name = $npc->GetCleanName();
                my $title_tag = "the Reflected";
                my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
                $npc->TempName($new_name);
                $npc->ModifyNPCStat("lastname", "Reflected");
                # --- end title ---
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    quest::shout("Minions, assist me in battle!");

    my $boss = $npc;
    return unless $boss;

    my $top_target = $boss->GetHateTop();
    return unless $top_target;

    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        my $minion_id = quest::spawn2(1257, 0, 0, $x, $y, $z, $npc->GetHeading());

        my $minion = $entity_list->GetNPCByID($minion_id);
        next unless $minion;
        $minion->AddToHateList($top_target, 1);
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
}