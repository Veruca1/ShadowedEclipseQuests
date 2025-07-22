my $core_spawned = 0;
my $core_trigger_hp = 0;

my @spawn_locs = (
    [6.09, 203.52, 70.29, 126.75],
    [-722.07, 431.27, 37.06, 357.00],
    [-1972.98, -162.78, 75.06, 6.00],
    [-1711.33, -601.00, 13.81, 139.00],
    [-93.80, -813.65, 9.26, 0.50],
    [328.50, -347.15, 555.95, 177.50],
    [-101.41, -831.63, 764.36, 381.50],
    [-2016.69, -493.75, 402.54, 336.75]
);

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ 20% HARDER than 1994
    $npc->ModifyNPCStat("level", 67);
    $npc->ModifyNPCStat("ac", 72000);
    $npc->ModifyNPCStat("max_hp", 57600000);
    $npc->ModifyNPCStat("hp_regen", 288000);
    $npc->ModifyNPCStat("mana_regen", 14400);

    $npc->ModifyNPCStat("min_hit", 20960);
    $npc->ModifyNPCStat("max_hit", 30600);
    $npc->ModifyNPCStat("atk", 2304);
    $npc->ModifyNPCStat("accuracy", 2880);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("slow_mitigation", 100);

    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);

    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1728);
    $npc->ModifyNPCStat("sta", 1728);
    $npc->ModifyNPCStat("agi", 1728);
    $npc->ModifyNPCStat("dex", 1728);
    $npc->ModifyNPCStat("wis", 1728);
    $npc->ModifyNPCStat("int", 1728);
    $npc->ModifyNPCStat("cha", 1440);

    $npc->ModifyNPCStat("mr", 180);
    $npc->ModifyNPCStat("fr", 180);
    $npc->ModifyNPCStat("cr", 180);
    $npc->ModifyNPCStat("pr", 180);
    $npc->ModifyNPCStat("dr", 180);
    $npc->ModifyNPCStat("corruption_resist", 720);
    $npc->ModifyNPCStat("physical_resist", 14400);

    $npc->ModifyNPCStat("runspeed", 0);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^4,1^5,1^12,1^13,1^14,1^15,1^16,1^17,1^21,1^29,1^33,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
    $npc->SetInvul($mob ? 1 : 0);
}

sub EVENT_COMBAT {
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
    $npc->SetInvul($mob ? 1 : 0);

    if ($combat_state == 1) {
        $core_spawned = 0;
        $core_trigger_hp = int(rand(61)) + 20;
        quest::setnexthpevent(80);
        quest::settimer("proximity_check", 5);
    } else {
        quest::stoptimer("proximity_check");
    }
}

sub EVENT_HP {
    if (!$core_spawned && $hpevent <= $core_trigger_hp) {
        my $loc = $spawn_locs[int(rand(@spawn_locs))];
        quest::spawn2(1998, 0, 0, @$loc);
        quest::shout("The Void's jaws remain closed while my hound hunts you in the shadows...");
        $core_spawned = 1;
    }

    if (!$core_spawned) {
        if ($hpevent > 20) {
            quest::setnexthpevent($hpevent - 5);
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "proximity_check") {
        my $npcid_to_check = 1998;
        my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
        $npc->SetInvul($mob ? 1 : 0);

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

sub EVENT_DAMAGE {
    my ($damage, $spell_id, $attacker) = @_;
    return int($damage * 0.5);
}

sub EVENT_DEATH_COMPLETE {
    my $npcid_to_check = 1998;
    my $mob = $entity_list->GetMobByNpcTypeID($npcid_to_check);
    my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

    if ($mob) {
        quest::spawn2(1995, 0, 0, $x, $y, $z, $h);
    } else {
        quest::spawn2(1996, 0, 0, $x, $y, $z, $h);
    }
}