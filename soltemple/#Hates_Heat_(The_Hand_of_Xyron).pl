sub EVENT_SPAWN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # === Base stats (no multipliers here) ===
    my $base_level    = 75;
    my $base_ac       = 20000;
    my $base_hp       = 90000000;
    my $base_regen    = 500;
    my $base_min_hit  = 55000;
    my $base_max_hit  = 80000;
    my $base_atk      = 1500;
    my $base_accuracy = 1800;
    my $base_delay    = 6;
    my $base_hs       = 32;   # base heroic strikethrough

    # === Apply raw baseline stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level",    $base_level);
    $npc->ModifyNPCStat("ac",       $base_ac);
    $npc->ModifyNPCStat("max_hp",   $base_hp);
    $npc->ModifyNPCStat("hp_regen", $base_regen);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",  $base_min_hit);
    $npc->ModifyNPCStat("max_hit",  $base_max_hit);
    $npc->ModifyNPCStat("atk",      $base_atk);
    $npc->ModifyNPCStat("accuracy", $base_accuracy);
    $npc->ModifyNPCStat("avoidance", 100);

    $npc->ModifyNPCStat("attack_delay", $base_delay);
    $npc->ModifyNPCStat("heroic_strikethrough", $base_hs);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
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

    ## --- Black Mirror visual & buff ---
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

    # === Apply raid scaling now ===
    plugin::RaidScaling($entity_list, $npc);

     # Full heal
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # --- HP event and depop timers ---
    quest::setnexthpevent(70);
    quest::settimer("depop_me", 1800);
    $npc->SetInvul(0);
    $npc->SetDisableMelee(0);
}

sub EVENT_HP {
    # First HP check at 70%
    if ($hpevent == 70) {
        quest::setnexthpevent(40);
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("Hahaha think you can stop me? I will suck the life out of the elements and destroy you all!");
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
    }
    # Second HP check at 40%
    elsif ($hpevent == 40) {
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::setnexthpevent(15);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("You are stronger than I thought! Arghhhhhh!");
    }
    # Third HP check at 15%
    elsif ($hpevent == 15) {
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("No, hate..must..prevail...one last time!");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_cycle") {
        # Get assigned spell set
        my $data = quest::get_data("mirror_spellset") || "";
        my @spells = split(/,/, $data);

        return unless @spells;  # No spells assigned

        # Pick one of the assigned spells
        my $spell_id = $spells[int(rand(@spells))];

        # Pick a random hate target
        my $target = $npc->GetHateRandom();
        if ($target) {
            $npc->CastSpell($spell_id, $target->GetID());
        }
    }
    elsif ($timer eq "defeat_minions") {
        quest::shout("Arrrrggghh Feel the heat of hate consume you!");
        # grabs everyone on the hate list and nukes them
        my @hatelist = $npc->GetHateList();
        foreach my $n (@hatelist) {
            next unless defined $n;
            next unless $n->GetEnt();
            next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());
            $npc->SpellFinished(41208, $n->GetEnt()->CastToMob());
        }
        # depops all elementals
        my @depop_list = (502000..502003);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id);
        }
        quest::stoptimer("defeat_minions");
    }
    elsif ($timer eq "depop_me") {
        quest::depop(2194);
        my @depop_list = (502000..502004);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id);
        }
        quest::stopalltimers();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Combat start logic
    }
    elsif ($combat_state == 0) {
        $npc->SetInvul(0);
        $npc->SetDisableMelee(0);
        quest::setnexthpevent(70);
        $npc->SetHP($npc->GetMaxHP());
        my @depop_list = (502000..502003);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id);
        }
    }
}

sub EVENT_SIGNAL {
    my $earth_check = $entity_list->GetMobByNpcTypeID(502000);
    my $water_check = $entity_list->GetMobByNpcTypeID(502002);
    my $fire_check  = $entity_list->GetMobByNpcTypeID(502003);
    my $air_check   = $entity_list->GetMobByNpcTypeID(502001);

    if ($signal == 101 && !$earth_check && !$water_check && !$fire_check && !$air_check) {
        quest::stoptimer("defeat_minions");
        $npc->SetInvul(0);
        $npc->SetDisableMelee(0);
        quest::modifynpcstat("runspeed", 2);
    } else {
        quest::stoptimer("defeat_minions");
        quest::settimer("defeat_minions", 40);
    }
}

sub EVENT_DEATH_COMPLETE {
    # Depop a specific NPC and stop timers
    quest::depop(502004);
    quest::stopalltimers();
    quest::signalwith(2193, 87);

my @boss_ids = (2194, 2195, 2196, 2197);
my $zone_to_unlock = "arcstone";
my $unlocked_status = 0;
my $npc_id = $npc->GetNPCTypeID();
if (grep { $_ == $npc_id } @boss_ids) {
    quest::set_data("arcstone_boss_killed_" . $npc_id, 1);
    my $boss_name = $npc->GetCleanName();
    quest::debug("Arcstone Guardian $boss_name ($npc_id) has been defeated!");
    my $all_killed = 1;
    my $killed_count = 0;
    foreach my $boss_id (@boss_ids) {
        my $killed = quest::get_data("arcstone_boss_killed_" . $boss_id);
        if ($killed) {
            $killed_count++;
        } else {
            $all_killed = 0;
        }
    }
    if ($all_killed) {
        quest::debug("All 4 Arcstone Guardians have been defeated! Unlocking Arcstone...");
        my $dbh = plugin::LoadMysql();
        if ($dbh) {
            my $sql = "UPDATE zone SET min_status = ? WHERE short_name = ? AND zoneidnumber = ?";
            my $sth = $dbh->prepare($sql);
            if ($sth->execute($unlocked_status, $zone_to_unlock, 369)) {
                quest::debug("Successfully unlocked Arcstone! Min_status changed from 80 to $unlocked_status");
                quest::ze(15, "The ancient seals have been broken! The way to Arcstone, Isle of Spirits, is now open to all!");
                quest::we(15, "The four Guardians have fallen! Arcstone, Isle of Spirits, has been unlocked!");
            } else {
                quest::debug("ERROR: Failed to update Arcstone min_status: " . $DBI::errstr);
            }
            $sth->finish();
            $dbh->disconnect();
        } else {
            quest::debug("ERROR: Failed to connect to database for Arcstone unlock");
        }
    } else {
        my $remaining = 4 - $killed_count;
        quest::debug("Arcstone unlock progress: $killed_count of 4 guardians defeated.");
        if ($killed_count == 1) {
            quest::ze(14, "The first Guardian has fallen! Three more must be defeated to unlock Arcstone.");
        } elsif ($killed_count == 2) {
            quest::ze(14, "Two Guardians down! The seals of Arcstone are weakening...");
        } elsif ($killed_count == 3) {
            quest::ze(14, "Three Guardians have been defeated! Only one remains before Arcstone is unlocked!");
        }
        my $killer = $entity_list->GetClientByID($killer_id);
        if ($killer) {
            $killer->Message(15, "You have defeated $boss_name! [$killed_count/4 Guardians defeated]");
        }
    }
}
}