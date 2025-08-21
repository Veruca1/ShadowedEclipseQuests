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

    # Check for raid presence: 6+ real clients (bots do NOT count)
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }
    my $is_raid = ($client_count >= 6) ? 1 : 0;

    if ($is_boss) {
        my $ac        = $is_raid ? 30000 * 1.5 : 30000;
        my $hp        = $is_raid ? 25500000 * 1.5 : 25500000;
        my $regen     = $is_raid ? 2500 * 1.5 : 2500;
        my $min_hit   = $is_raid ? 50000 * 1.5 : 50000;
        my $max_hit   = $is_raid ? 70000 * 1.5 : 70000;
        my $atk       = $is_raid ? 2500 * 1.5 : 2500;
        my $accuracy  = $is_raid ? 2000 * 1.5 : 2000;

        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", int($ac));
        $npc->ModifyNPCStat("max_hp", int($hp));
        $npc->ModifyNPCStat("hp_regen", int($regen));
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", int($min_hit));
        $npc->ModifyNPCStat("max_hit", int($max_hit));
        $npc->ModifyNPCStat("atk", int($atk));
        $npc->ModifyNPCStat("accuracy", int($accuracy));
        $npc->ModifyNPCStat("avoidance", 50);
        $npc->ModifyNPCStat("attack_delay", $is_raid ? 6 : 9);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", $is_raid ? 36 : 32);
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

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

        quest::setnexthpevent(75);

        # Set HP again after scaling
        my $max_hp = $npc->GetMaxHP();
        $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    } else {
        my $ac        = $is_raid ? 20000 * 1.5 : 20000;
        my $hp        = $is_raid ? 6500000 * 1.5 : 6500000;
        my $regen     = $is_raid ? 800 * 1.5 : 800;
        my $min_hit   = $is_raid ? 24000 * 1.5 : 24000;
        my $max_hit   = $is_raid ? 40000 * 1.5 : 40000;
        my $atk       = $is_raid ? 2500 * 1.5 : 2500;
        my $accuracy  = $is_raid ? 1800 * 1.5 : 1800;

        $npc->ModifyNPCStat("level", 62);
        $npc->ModifyNPCStat("ac", int($ac));
        $npc->ModifyNPCStat("max_hp", int($hp));
        $npc->ModifyNPCStat("hp_regen", int($regen));
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", int($min_hit));
        $npc->ModifyNPCStat("max_hit", int($max_hit));
        $npc->ModifyNPCStat("atk", int($atk));
        $npc->ModifyNPCStat("accuracy", int($accuracy));
        $npc->ModifyNPCStat("avoidance", 50);
        $npc->ModifyNPCStat("attack_delay", $is_raid ? 8 : 10);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", $is_raid ? 26 : 22);
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

        # Set HP again after scaling
        my $max_hp = $npc->GetMaxHP();
        $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
    }
}

# --- NEW: spawn Paradigm_of_Reflection (2178) 20s after a player enters,
#          but only if it's not already up ---
sub EVENT_ENTERZONE {
    # Spawn Paradigm_of_Reflection (2178) in 20 seconds if not already up
    my $existing = $entity_list->GetNPCByNPCTypeID(2178);
    if (!$existing) {
        quest::settimer("spawn_paradigm", 20);
    }
}

sub EVENT_HP {
    return unless $npc;
    return unless $is_boss;

    if ($hpevent == 75 || $hpevent == 25) {
        if ($npc->FindBuff(40745)) {           
            return;
        }

        quest::shout("Surrounding minions of the temple, arise and assist me!");
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
    # Handle player-driven timer even if $npc is undefined
    if ($timer eq "spawn_paradigm") {
        quest::stoptimer("spawn_paradigm");

        # Double-check it's still not up before spawning
        my $existing = $entity_list->GetNPCByNPCTypeID(2178);
        if (!$existing) {
            quest::spawn2(2178, 0, 0, 261.74, -576.25, -255.74, 1.00);
        }
    }

    # NPC-only timers require $npc
    if ($npc) {
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
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;
    
    my $npc_id = $npc->GetNPCTypeID() || 0;
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            return unless defined $x && defined $y && defined $z;
            my $radius = 50;
            my $dmg = 50000;

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

    my $npc_id = $npc->GetNPCTypeID() || 0;   
    my $exclusion_list = plugin::GetExclusionList();
    if (exists $exclusion_list->{$npc_id}) {        
        return;
    }

    # 10% spawn chance
    if (quest::ChooseRandom(1..100) <= 13) {        
        quest::spawn2(1984, 0, 0, $killed_x, $killed_y, $killed_z, $killed_h);
    }

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

    unless ($client) {        
        return;
    }

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

    my %has_final_flag;
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();
        my $final_flag = "SSRA_AllFlags_${cid}";
        $has_final_flag{$cid} = quest::get_data($final_flag) ? 1 : 0;
    }

    # Roll chance ONCE per kill
    my $essence_roll = plugin::RandomRange(1, 100);
    quest::debug("Essence roll result: $essence_roll"); # Debug logging

    if ($essence_roll <= 35) {
        foreach my $pc (@ip_clients) {
            next unless $pc && $pc->IsClient();
            $pc = $pc->CastToClient();
            my $cid = $pc->CharacterID();
            next if $has_final_flag{$cid};

            my $trash_flag = "~SSRA_Trash_${cid}~";
            my $trash_count_key = "${trash_flag}_count";

            unless (quest::get_data($trash_flag)) {
                my $count = quest::get_data($trash_count_key) || 0;
                $count++;
                quest::set_data($trash_count_key, $count);
                $pc->Message(15, "Essence gathered... [$count/100]");                

                if ($count >= 100) {
                    quest::set_data($trash_flag, 1);
                    $pc->Message(14, "You've gathered enough essence from the SSRA's minions.");                    
                }
            }
        }
    }

    # Check final flag
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();
        next if $has_final_flag{$cid};
        my $pname = $pc->GetCleanName();

        my $trash_flag = "~SSRA_Trash_${cid}~";
        my $final_flag = "SSRA_AllFlags_${cid}";
        next unless quest::get_data($trash_flag);

        my $complete = 1;
        my $complete = quest::get_data($trash_flag) ? 1 : 0;

        if ($complete) {
            quest::set_data($final_flag, 1);
            $pc->Message(14, "You have gathered all the needed essences in Ssraeshza Temple!");
            quest::we(14, "$pname has gathered the required essences in Ssraeshza Temple!");

            # --- Title & Discord Logic for Final Completion ---
            my $title_flag = "snake_slayer_title_" . $cid;

            if (!quest::get_data($title_flag)) {
                quest::set_data($title_flag, 1); # Mark as received title
                $pc->SetTitleSuffix("Snake Slayer", 1); # Grant suffix title
                $pc->NotifyNewTitlesAvailable();              # Refresh titles

                $pc->Message(14, "You have earned the title: Snake Slayer!");
                quest::we(13, "$pname has earned the title Snake Slayer!");
                quest::discordsend("titles", "$pname has earned the title of Snake Slayer!");
            }
        }
    }
}