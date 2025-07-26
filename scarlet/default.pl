my $is_boss = 0;
my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();
    
    # Use plugin to check exclusion list
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};
    
    $is_boss = ($raw_name =~ /^#/ || ($npc_id == 1919 && $npc_id != 1974)) ? 1 : 0;
    $npc->SetNPCFactionID(623);
    $wrath_triggered = 0;

    if ($is_boss) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 35500000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 12000);
        $npc->ModifyNPCStat("max_hit", 20000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 110);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 32);
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

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1");

        # ✅ Boss loot
        my $veru = plugin::verugems();
        my @veru_ids = keys %$veru;
        $npc->AddItem($veru_ids[int(rand(@veru_ids))]);

        if (int(rand(100)) < 25) {
            my $scar = plugin::botscar();
            my @scar_ids = keys %$scar;
            $npc->AddItem($scar_ids[int(rand(@scar_ids))]);}
            
        if (int(rand(100)) < 20) {
            my $gear = plugin::ch6classgear();
            my @all_gear_ids = map { @{$gear->{$_}} } keys %$gear;
            $npc->AddItem($all_gear_ids[int(rand(@all_gear_ids))]);
        }

        quest::setnexthpevent(75);
    } else {
        $npc->ModifyNPCStat("level", 61);
        $npc->ModifyNPCStat("ac", 20000);
        $npc->ModifyNPCStat("max_hp", 8500000);
        $npc->ModifyNPCStat("hp_regen", 800);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8000);
        $npc->ModifyNPCStat("max_hit", 12000);
        $npc->ModifyNPCStat("atk", 1200);
        $npc->ModifyNPCStat("accuracy", 1800);
        $npc->ModifyNPCStat("avoidance", 100);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 22);
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

        # ✅ Non-boss loot
        my $veru = plugin::verugems();
        my @veru_ids = keys %$veru;
        $npc->AddItem($veru_ids[int(rand(@veru_ids))]);

        if (int(rand(100)) < 17) {
            my $scar = plugin::botscar();
            my @scar_ids = keys %$scar;
            $npc->AddItem($scar_ids[int(rand(@scar_ids))]);
        }
    }

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_HP {
    return unless $npc;
    return unless $is_boss;

    if ($hpevent == 75 || $hpevent == 25) {
        # Check if NPC has debuff spell 40745 active
        if ($npc->FindBuff(40745)) {
            #plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the woods, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }

        quest::setnexthpevent(25) if $hpevent == 75;
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
        quest::settimer("reset_hp_event", 75) if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain" && $is_boss) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;
        my $radius = 50;
        my $dmg = 6000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }
    }

    if ($timer eq "reset_hp_event" && $is_boss) {
        quest::setnexthpevent(75);
        quest::stoptimer("reset_hp_event");
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;
    
    my $npc_id = $npc->GetNPCTypeID() || 0;
    # Use plugin to check exclusion list
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            return unless defined $x && defined $y && defined $z;
            my $radius = 50;
            my $dmg = 40000;

            # Get exclusion list from plugin for pet checks
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



sub EVENT_DEATH_COMPLETE {
    return unless $npc;

    my %named_ids = (
        175281 => 1,  # #Bloodtribe_Ancient
        175014 => 1,  # #Bloodtribe_Sneakster
        175246 => 1,  # #Bloodtribe_Surveyor
        175273 => 1,  # #Knight_of_the_Dread_Sun
        175227 => 1,  # #Kraen_Flameweaver
        175218 => 1,  # #Sectoid
        175223 => 1,  # #Sun_Revenant_Chancellor
        175184 => 1   # #Sunlord_Wedazi
    );

    my $npc_id = $npc->GetNPCTypeID() || 0;
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    my $ent = $entity_list->GetMobID($killer_id);
    my $client;

    if ($ent) {
        if ($ent->IsClient()) {
            $client = $ent->CastToClient();
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
            } elsif ($owner && $owner->IsBot()) {
                my $bot_owner = $owner->CastToBot()->GetOwner();
                if ($bot_owner && $bot_owner->IsClient()) {
                    $client = $bot_owner->CastToClient();
                }
            }
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
            }
        }
    }

    return unless $client;

    my $base_ip = $client->GetIP();
    my @ip_clients;
    if ($client->GetRaid()) {
        my $raid = $client->GetRaid();
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $m = $raid->GetMember($i);
            push @ip_clients, $m if $m && $m->IsClient() && $m->GetIP() eq $base_ip;
        }
    } elsif ($client->GetGroup()) {
        my $group = $client->GetGroup();
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $m = $group->GetMember($i);
            push @ip_clients, $m if $m && $m->IsClient() && $m->GetIP() eq $base_ip;
        }
    } else {
        push @ip_clients, $client;
    }

    # 35% trash flag
    if (plugin::RandomRange(1, 100) <= 35) {
        foreach my $pc (@ip_clients) {
            next unless $pc && $pc->IsClient();
            $pc = $pc->CastToClient();
            my $cid = $pc->CharacterID();
            my $trash_flag = "~scarlet_trash_flag_${cid}";
            my $trash_count_key = "${trash_flag}_count";

            unless (quest::get_data($trash_flag)) {
                my $count = quest::get_data($trash_count_key) || 0;
                $count++;
                quest::set_data($trash_count_key, $count);
                $pc->Message(15, "Essence gathered... [$count/40]");
                if ($count >= 40) {
                    quest::set_data($trash_flag, 1);
                    $pc->Message(14, "You've gathered enough essence from Scarlet's minions.");
                }
            }
        }
    }

    # 100% named flag
    if (exists $named_ids{$npc_id}) {
        foreach my $pc (@ip_clients) {
            next unless $pc && $pc->IsClient();
            $pc = $pc->CastToClient();
            my $cid = $pc->CharacterID();
            my $named_flag = "~scarlet_named_flag_${npc_id}_${cid}";
            unless (quest::get_data($named_flag)) {
                quest::set_data($named_flag, 1);
                $pc->Message(15, "You absorb the essence of the vanquished named...");
            }
        }
    }

    # Final flag check
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();
        my $pname = $pc->GetCleanName();

        my $trash_flag = "~scarlet_trash_flag_${cid}";
        my $final_flag = "~scarlet_final_flag_${cid}";
        next if quest::get_data($final_flag);
        next unless quest::get_data($trash_flag);

        my $complete = 1;
        foreach my $id (keys %named_ids) {
            my $check = "~scarlet_named_flag_${id}_${cid}";
            unless (quest::get_data($check)) {
                $complete = 0;
                last;
            }
        }

        if ($complete) {
            quest::set_data($final_flag, 1);
            $pc->SetZoneFlag(169);  # Letalis
            $pc->Message(14, "You have earned access to Mons Letalis!");
            quest::we(14, "$pname has earned access to Mons Letalis!");
        }
    }
}