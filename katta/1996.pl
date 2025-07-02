sub EVENT_SPAWN {
    return unless $npc;

    # ✅ 20% HARDER than previous
    $npc->ModifyNPCStat("level", 69);
    $npc->ModifyNPCStat("ac", 86400);             # 72,000 * 1.2
    $npc->ModifyNPCStat("max_hp", 69120000);      # 57.6M * 1.2
    $npc->ModifyNPCStat("hp_regen", 345600);      # 288,000 * 1.2
    $npc->ModifyNPCStat("mana_regen", 17280);     # 14,400 * 1.2

    $npc->ModifyNPCStat("min_hit", 24000);        # ✅ 20% more than 20,000
    $npc->ModifyNPCStat("max_hit", 36000);        # ✅ 20% more than 30,000
    $npc->ModifyNPCStat("atk", 2764);             # 2,304 * 1.2
    $npc->ModifyNPCStat("accuracy", 3456);        # 2,880 * 1.2
    $npc->ModifyNPCStat("avoidance", 100);        # Maxed
    $npc->ModifyNPCStat("slow_mitigation", 100);  # Full slow resist

    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);  # 46 * 1.2 = 55

    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 2074);   # 1,728 * 1.2
    $npc->ModifyNPCStat("sta", 2074);
    $npc->ModifyNPCStat("agi", 2074);
    $npc->ModifyNPCStat("dex", 2074);
    $npc->ModifyNPCStat("wis", 2074);
    $npc->ModifyNPCStat("int", 2074);
    $npc->ModifyNPCStat("cha", 1728);   # 1,440 * 1.2

    $npc->ModifyNPCStat("mr", 200);     # 720 * 1.2
    $npc->ModifyNPCStat("fr", 200);
    $npc->ModifyNPCStat("cr", 200);
    $npc->ModifyNPCStat("pr", 200);
    $npc->ModifyNPCStat("dr", 200);
    $npc->ModifyNPCStat("corruption_resist", 864);
    $npc->ModifyNPCStat("physical_resist", 17280); # 14,400 * 1.2

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # ✅ Correct special abilities for your server mappings
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^4,1^5,1^12,1^13,1^14,1^15,1^16,1^17,1^21,1^29,1");

    # Heal to full after stat change
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Invulnerability check on spawn
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
            quest::depopzone(0);  # ✅ Depop entire zone
            quest::stoptimer("proximity_check");
        }
    }
}

# ✅ Halves spell damage only
sub EVENT_DAMAGE {
    my ($damage, $spell_id, $attacker) = @_;
    my $new_damage = int($damage * 0.5);
    return $new_damage;
}

sub EVENT_DEATH_COMPLETE {
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);

    if ($mob) {
        # Respawn this NPC if the core NPC is alive
        quest::spawn2(1996, 0, 0, $x, $y, $z, $h);
    } else {
        # Otherwise, advance to next phase
        quest::spawn2(1997, 0, 0, $x, $y, $z, $h);
    }
}