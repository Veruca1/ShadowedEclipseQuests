# ===========================================================
# default.pl — Ssraeshza Temple (ssratemple)
# Shadowed Eclipse Scaling System
# - Applies baseline stats to all non-excluded NPCs.
# - Uses legacy "Old Ssra" raw stat tiers (no scaling multipliers).
# - Bosses use the high-end Luclin-era baseline (25.5 M HP, 50k–70k hits).
# - Trash uses mid-tier baseline (6.5 M HP, 24k–40k hits).
# - Vision and detection fully enabled across all NPCs.
# ===========================================================

my $is_boss = 0;
my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

my $exclusion_list = {
    10      => 1,   # Zone_Controller
    163075  => 1,   # Grieg
    1595    => 1,   # Nyseria's Guard
    1712    => 1,   # Nyseria

    # Cursed event NPCs (exclude from baseline/stat scaling)
    162271  => 1,   # #cursed_two
    162260  => 1,   # #cursed_one
    162272  => 1,   # #cursed_three
    162273  => 1,   # #cursed_four
    162274  => 1,   # #cursed_five
    162275  => 1,   # #cursed_six
    162276  => 1,   # #cursed_seven
    162277  => 1,   # #cursed_eight
    162278  => 1,   # #cursed_nine
    162279  => 1,   # #cursed_ten
    162142  => 1,   # #cursed_ten
    162280  => 1   # #cursed_controller
};
    return if exists $exclusion_list->{$npc_id};

    # ===========================================================
    # General setup
    # ===========================================================
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    # ===========================================================
    # === BASELINE STATS (Old Ssra) ===
    # ===========================================================
    my $base_stats = $is_boss ? {
        # --- Boss Baseline ---
        level       => 65,
        ac          => 30000,
        max_hp      => 25000000,
        hp_regen    => 2500,
        min_hit     => 50000,
        max_hit     => 70000,
        atk         => 2500,
        accuracy    => 2000,
        hst         => 32,
        slow_mit    => 90,
        aggro       => 60,
        assist      => 1,
        str => 1200, sta => 1200, agi => 1200, dex => 1200,
        wis => 1200, int => 1200, cha => 1000,
        mr => 400, fr => 400, cr => 400, pr => 400, dr => 400,
        corr => 500, phys => 1000,
        sa => "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1",
    } : {
        # --- Trash Baseline ---
        level       => 62,
        ac          => 20000,
        max_hp      => 1750000,
        hp_regen    => 800,
        min_hit     => 24000,
        max_hit     => 40000,
        atk         => 2500,
        accuracy    => 1800,
        hst         => 22,
        slow_mit    => 80,
        aggro       => 55,
        assist      => 1,
        str => 1000, sta => 1000, agi => 1000, dex => 1000,
        wis => 1000, int => 1000, cha => 800,
        mr => 300, fr => 300, cr => 300, pr => 300, dr => 300,
        corr => 300, phys => 800,
        sa => "3,1^5,1^7,1^8,1^9,1^10,1^14,1",
    };

    # Apply baseline
    _apply_baseline($base_stats);
    $npc->ModifyNPCStat("attack_delay", $is_boss ? 9 : 10);

    # ===========================================================
    # Optional: Keep raid scaling if desired (disabled otherwise)
    # ===========================================================
    # plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    $npc->ModifyNPCStat("heroic_strikethrough", $base_stats->{hst});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    quest::setnexthpevent(75) if $is_boss;
}

# ===========================================================
# Internal helper: apply baseline stats cleanly
# ===========================================================
sub _apply_baseline {
    my ($s) = @_;

    $npc->ModifyNPCStat("level",     $s->{level});
    $npc->ModifyNPCStat("ac",        $s->{ac});
    $npc->ModifyNPCStat("max_hp",    $s->{max_hp});
    $npc->ModifyNPCStat("hp_regen",  $s->{hp_regen});
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   $s->{min_hit});
    $npc->ModifyNPCStat("max_hit",   $s->{max_hit});
    $npc->ModifyNPCStat("atk",       $s->{atk});
    $npc->ModifyNPCStat("accuracy",  $s->{accuracy});
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", $s->{hst});
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", $s->{slow_mit});
    $npc->ModifyNPCStat("aggro", $s->{aggro});
    $npc->ModifyNPCStat("assist", $s->{assist});

    $npc->ModifyNPCStat("str", $s->{str});
    $npc->ModifyNPCStat("sta", $s->{sta});
    $npc->ModifyNPCStat("agi", $s->{agi});
    $npc->ModifyNPCStat("dex", $s->{dex});
    $npc->ModifyNPCStat("wis", $s->{wis});
    $npc->ModifyNPCStat("int", $s->{int});
    $npc->ModifyNPCStat("cha", $s->{cha});

    $npc->ModifyNPCStat("mr", $s->{mr});
    $npc->ModifyNPCStat("fr", $s->{fr});
    $npc->ModifyNPCStat("cr", $s->{cr});
    $npc->ModifyNPCStat("pr", $s->{pr});
    $npc->ModifyNPCStat("dr", $s->{dr});
    $npc->ModifyNPCStat("corruption_resist", $s->{corr});
    $npc->ModifyNPCStat("physical_resist",   $s->{phys});

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", $s->{sa});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
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