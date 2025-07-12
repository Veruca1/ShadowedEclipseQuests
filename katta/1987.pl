sub EVENT_SPAWN {
    return unless $npc;

    # ✅ FINAL BOSS — 20% stronger than 1997
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 124416);
    $npc->ModifyNPCStat("max_hp", 101532800);
    $npc->ModifyNPCStat("hp_regen", 497664);
    $npc->ModifyNPCStat("mana_regen", 24883);

    $npc->ModifyNPCStat("min_hit", 34560);
    $npc->ModifyNPCStat("max_hit", 51840);
    $npc->ModifyNPCStat("atk", 3980);
    $npc->ModifyNPCStat("accuracy", 4976);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("slow_mitigation", 100);

    $npc->ModifyNPCStat("attack_delay", 10);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 35);

    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 2986);
    $npc->ModifyNPCStat("sta", 2986);
    $npc->ModifyNPCStat("agi", 2986);
    $npc->ModifyNPCStat("dex", 2986);
    $npc->ModifyNPCStat("wis", 2986);
    $npc->ModifyNPCStat("int", 2986);
    $npc->ModifyNPCStat("cha", 2488);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 1244);
    $npc->ModifyNPCStat("physical_resist", 24883);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # ✅ Final boss special abilities
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^4,1^5,1^12,1^13,1^14,1^15,1^16,1^17,1^21,1^29,1");

    # Full heal
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Core invul check (optional)
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
    if ($mob) {
        $npc->SetInvul(1);
    } else {
        $npc->SetInvul(0);
    }

    # ✅ Start HP events for phased adds
    quest::setnexthpevent(80);

    # ✅ UPDATED RANDOMIZED LOOT TABLES
    my @named_items = (
        42435,  # Sacred Lunar Shield of Healing
        42436,  # Sacred Lunar Shield of Chaos
        42437,  # Upside (Shawl of Lunar) Down (Madness)
        39591   # Glyph of Whirlwind
    );

    my @unnamed_items = (
        41152, 41153, 41154, 41155, 41156, 41157, 41158, 41173, 41174,
        87487, 117452
    );

    # Shuffle both lists
    my @shuffled_named   = sort { rand() <=> rand() } @named_items;
    my @shuffled_unnamed = sort { rand() <=> rand() } @unnamed_items;

    # ✅ Always drop 2 named
    $npc->AddItem($shuffled_named[0]);
    $npc->AddItem($shuffled_named[1]);

    # ✅ Always drop 2 unnamed
    $npc->AddItem($shuffled_unnamed[0]);
    $npc->AddItem($shuffled_unnamed[1]);

    # ✅ 35% chance for a 3rd unnamed
    if (int(rand(100)) < 35) {
        $npc->AddItem($shuffled_unnamed[2]);
    }
}

sub EVENT_HP {
    my $hp_event = $hpevent;
    my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());

    # Phased add spawns from 80% to 20%
    if ($hp_event == 80 || $hp_event == 70 || $hp_event == 60 ||
        $hp_event == 50 || $hp_event == 40 || $hp_event == 30 || $hp_event == 20) {

        for (1..3) {
            quest::spawn2(1948, 0, 0, $x + rand(20) - 10, $y + rand(20) - 10, $z, 0);
        }

        if ($hp_event == 80) {
            quest::setnexthpevent(70);
        } elsif ($hp_event == 70) {
            quest::setnexthpevent(60);
        } elsif ($hp_event == 60) {
            quest::setnexthpevent(50);
        } elsif ($hp_event == 50) {
            quest::setnexthpevent(40);
        } elsif ($hp_event == 40) {
            quest::setnexthpevent(30);
        } elsif ($hp_event == 30) {
            quest::setnexthpevent(20);
        } elsif ($hp_event == 20) {
            quest::setnexthpevent(10);  # Start final ramp-up
        }

    # Final damage ramp at 10%, 5%, 1%
    } elsif ($hp_event == 10) {
        $npc->ModifyNPCStat("min_hit", $npc->GetMinDMG() + 4000);
        $npc->ModifyNPCStat("max_hit", $npc->GetMaxDMG() + 6000);
        quest::setnexthpevent(5);

    } elsif ($hp_event == 5) {
        $npc->ModifyNPCStat("min_hit", $npc->GetMinDMG() + 5000);
        $npc->ModifyNPCStat("max_hit", $npc->GetMaxDMG() + 7000);
        quest::setnexthpevent(1);

    } elsif ($hp_event == 1) {
        $npc->ModifyNPCStat("min_hit", $npc->GetMinDMG() + 7000);
        $npc->ModifyNPCStat("max_hit", $npc->GetMaxDMG() + 9000);
    }
}

sub EVENT_COMBAT {
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);

    if ($mob) {
        $npc->SetInvul(1);
    } else {
        $npc->SetInvul(0);
    }

    if ($combat_state == 1) {
        quest::settimer("proximity_check", 5);
    } else {
        quest::stoptimer("proximity_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "proximity_check") {
        my $npcid_to_check = 1998;
        my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);

        if ($mob) {
            $npc->SetInvul(1);
        } else {
            $npc->SetInvul(0);
        }

        my $found_client = 0;
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            my $distance = $npc->CalculateDistance(
                $client->GetX(),
                $client->GetY(),
                $client->GetZ()
            );
            if ($distance <= 100) {
                $found_client = 1;
                last;
            }
        }

        if (!$found_client) {
            quest::shout("No players within range! The encounter collapses!");
            quest::depopzone(0);
            quest::stoptimer("proximity_check");
        }
    }
}

# ✅ Halve spell damage
sub EVENT_DAMAGE {
    my ($damage, $spell_id, $attacker) = @_;
    my $new_damage = int($damage * 0.5);
    return $new_damage;
}

# ❌ No EVENT_DEATH_COMPLETE needed!