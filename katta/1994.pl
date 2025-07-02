sub EVENT_SPAWN {
    return unless $npc;

    # ✅ 20% HARDER BOSS STATS (scaled up)
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 60000);             # +20% AC
    $npc->ModifyNPCStat("max_hp", 48000000);      # +20% HP
    $npc->ModifyNPCStat("hp_regen", 240000);      # +20% regen
    $npc->ModifyNPCStat("mana_regen", 12000);     # +20% mana regen

    $npc->ModifyNPCStat("min_hit", 10800);        # +20% min hit
    $npc->ModifyNPCStat("max_hit", 18000);        # +20% max hit
    $npc->ModifyNPCStat("atk", 1920);             # +20% ATK
    $npc->ModifyNPCStat("accuracy", 2400);        # +20% accuracy
    $npc->ModifyNPCStat("avoidance", 100);        # Maxed
    $npc->ModifyNPCStat("slow_mitigation", 100);  # Full slow resist

    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);  # +20% strikethrough

    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1440);
    $npc->ModifyNPCStat("sta", 1440);
    $npc->ModifyNPCStat("agi", 1440);
    $npc->ModifyNPCStat("dex", 1440);
    $npc->ModifyNPCStat("wis", 1440);
    $npc->ModifyNPCStat("int", 1440);
    $npc->ModifyNPCStat("cha", 1200);

    $npc->ModifyNPCStat("mr", 170);
    $npc->ModifyNPCStat("fr", 170);
    $npc->ModifyNPCStat("cr", 170);
    $npc->ModifyNPCStat("pr", 170);
    $npc->ModifyNPCStat("dr", 170);
    $npc->ModifyNPCStat("corruption_resist", 600);
    $npc->ModifyNPCStat("physical_resist", 12000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # ✅ Correct special abilities (your server mappings!)
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
        quest::settimer("proximity_check", 5);  # Check every 5 seconds
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
        quest::spawn2(1994, 0, 0, $x, $y, $z, $h);
    } else {
        quest::spawn2(1995, 0, 0, $x, $y, $z, $h);
    }
}