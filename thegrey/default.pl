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
        $npc->ModifyNPCStat("max_hp", 45500000);
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

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

# ✅ Boss loot
my $veru = plugin::verugems();
my @veru_ids = keys %$veru;
$npc->AddItem($veru_ids[int(rand(@veru_ids))]);

if (int(rand(100)) < 30) {
    my $grey = plugin::botthegrey();
    my @grey_ids = keys %$grey;
    $npc->AddItem($grey_ids[int(rand(@grey_ids))]);
}

if (int(rand(100)) < 20) {
    my $gear = plugin::ch6classgear();
    my @all_gear_ids = map { @{$gear->{$_}} } keys %$gear;
    $npc->AddItem($all_gear_ids[int(rand(@all_gear_ids))]);
}

# 🏹 Guaranteed drop of 2 huntercred items (33208)
my $cred = plugin::huntercred();
my @cred_ids = keys %$cred;
$npc->AddItem($cred_ids[0]);
$npc->AddItem($cred_ids[0]);

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

if (int(rand(100)) < 5) {
    my $grey = plugin::botthegrey();
    my @grey_ids = keys %$grey;
    $npc->AddItem($grey_ids[int(rand(@grey_ids))]);
}

# 🏹 Guaranteed drop of 1 huntercred item (33208)
my $cred = plugin::huntercred();
my @cred_ids = keys %$cred;
$npc->AddItem($cred_ids[0]);
        
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
            ##plugin::debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the desert, arise and assist me!");
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

    my $npc_id = $npc->GetNPCTypeID() || 0;
    #plugin::debug("EVENT_DEATH_COMPLETE: NPC ID $npc_id, killer_id: $killer_id");

    my $exclusion_list = plugin::GetExclusionList();
    if (exists $exclusion_list->{$npc_id}) {
        #plugin::debug("NPC ID $npc_id is excluded. Skipping flag logic.");
        return;
    }

    # 10% spawn chance
    if (quest::ChooseRandom(1..100) <= 13) {
        #plugin::debug("Spawning 1984 at death location.");
        quest::spawn2(1984, 0, 0, $killed_x, $killed_y, $killed_z, $killed_h);
    }

    my $ent = $entity_list->GetMobID($killer_id);
    my $client;

    if ($ent) {
        if ($ent->IsClient()) {
            $client = $ent->CastToClient();
            #plugin::debug("Killer is client: " . $client->GetCleanName());
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
                #plugin::debug("Killer was pet, owner is client: " . $client->GetCleanName());
            } elsif ($owner && $owner->IsBot()) {
                my $bot_owner = $owner->CastToBot()->GetOwner();
                if ($bot_owner && $bot_owner->IsClient()) {
                    $client = $bot_owner->CastToClient();
                    #plugin::debug("Killer was bot pet, owner is client: " . $client->GetCleanName());
                }
            }
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
                #plugin::debug("Killer is bot, owner is client: " . $client->GetCleanName());
            }
        }
    }

    unless ($client) {
        #plugin::debug("Could not resolve killer to client. Exiting.");
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

    my %named_ids = (
        171068 => 1,
        171056 => 1,
        171065 => 1,
        171057 => 1,
        171073 => 1
    );

    my %has_final_flag;
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();
        my $final_flag = "Grey_AllFlags_${cid}";
        $has_final_flag{$cid} = quest::get_data($final_flag) ? 1 : 0;
    }

    # 35% trash flag roll once
    if (plugin::RandomRange(1, 100) <= 35) {
        foreach my $pc (@ip_clients) {
            next unless $pc && $pc->IsClient();
            $pc = $pc->CastToClient();
            my $cid = $pc->CharacterID();
            next if $has_final_flag{$cid};
            my $trash_flag = "~Grey_Trash_${cid}~";
            my $trash_count_key = "${trash_flag}_count";

            unless (quest::get_data($trash_flag)) {
                my $count = quest::get_data($trash_count_key) || 0;
                $count++;
                quest::set_data($trash_count_key, $count);
                $pc->Message(15, "Essence gathered... [$count/40]");
                #plugin::debug("Trash count now $count for " . $pc->GetCleanName());

                if ($count >= 40) {
                    quest::set_data($trash_flag, 1);
                    $pc->Message(14, "You've gathered enough essence from the Grey's minions.");
                    #plugin::debug("Trash flag complete for " . $pc->GetCleanName());
                }
            }
        }
    }

    # 75% named flag roll once
    if (exists $named_ids{$npc_id} && plugin::RandomRange(1, 100) <= 75) {
        foreach my $pc (@ip_clients) {
            next unless $pc && $pc->IsClient();
            $pc = $pc->CastToClient();
            my $cid = $pc->CharacterID();
            next if $has_final_flag{$cid};
            my $named_flag = "${npc_id}_Grey_${cid}";
            unless (quest::get_data($named_flag)) {
                quest::set_data($named_flag, 1);
                $pc->Message(15, "You absorb the essence of the vanquished named...");
                #plugin::debug("Named flag set: $named_flag for " . $pc->GetCleanName());
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

        my $trash_flag = "~Grey_Trash_${cid}~";
        my $final_flag = "Grey_AllFlags_${cid}";
        next unless quest::get_data($trash_flag);

        my $complete = 1;
        foreach my $id (keys %named_ids) {
            my $check = "${id}_Grey_${cid}";
            unless (quest::get_data($check)) {
                $complete = 0;
                #plugin::debug("Missing flag $check for $pname");
                last;
            }
        }

        if ($complete) {
            quest::set_data($final_flag, 1);
            $pc->SetZoneFlag(162);
            $pc->Message(14, "You have earned access to Ssraeshza Temple!");
            quest::we(14, "$pname has earned access to Ssraeshza Temple!");
            #plugin::debug("Zoneflag granted to $pname");
        }
    }
} 
