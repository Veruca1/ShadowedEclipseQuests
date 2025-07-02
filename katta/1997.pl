sub EVENT_SPAWN {
    return unless $npc;

    # ✅ 20% HARDER than 1996
    $npc->ModifyNPCStat("level", 72);
    $npc->ModifyNPCStat("ac", 103680);
    $npc->ModifyNPCStat("max_hp", 82944000);
    $npc->ModifyNPCStat("hp_regen", 414720);
    $npc->ModifyNPCStat("mana_regen", 20736);

    $npc->ModifyNPCStat("min_hit", 28800);
    $npc->ModifyNPCStat("max_hit", 43200);
    $npc->ModifyNPCStat("atk", 3317);
    $npc->ModifyNPCStat("accuracy", 4147);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("slow_mitigation", 100);

    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);

    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 2488);
    $npc->ModifyNPCStat("sta", 2488);
    $npc->ModifyNPCStat("agi", 2488);
    $npc->ModifyNPCStat("dex", 2488);
    $npc->ModifyNPCStat("wis", 2488);
    $npc->ModifyNPCStat("int", 2488);
    $npc->ModifyNPCStat("cha", 2074);

    $npc->ModifyNPCStat("mr", 210);
    $npc->ModifyNPCStat("fr", 210);
    $npc->ModifyNPCStat("cr", 210);
    $npc->ModifyNPCStat("pr", 210);
    $npc->ModifyNPCStat("dr", 210);
    $npc->ModifyNPCStat("corruption_resist", 1037);
    $npc->ModifyNPCStat("physical_resist", 20736);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # ✅ Correct special abilities for your server mapping
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^4,1^5,1^12,1^13,1^14,1^15,1^16,1^17,1^21,1^29,1");

    # Heal to full
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Invulnerability check
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
    if ($mob) {
        $npc->SetInvul(1);
    } else {
        $npc->SetInvul(0);
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
            quest::depopzone(0);  # ✅ Wipe entire zone
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

sub EVENT_DEATH_COMPLETE {
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);

    if ($mob) {
        # If the core NPC is alive, respawn this phase
        quest::spawn2(1997, 0, 0, $x, $y, $z, $h);
    } else {
        # Otherwise, final spawn (or end)
        quest::spawn2(1987, 0, 0, $x, $y, $z, $h);
    }
}