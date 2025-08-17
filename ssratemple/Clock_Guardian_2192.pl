# Clock_Guardian_2192.pl
# Guardian starts invulnerable until within 40 units of 2191, then unlocks

my $unlock_distance = 40;
my $unlocked = 0;

sub EVENT_SPAWN {
    # Base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 29000);
    $npc->ModifyNPCStat("max_hp", 145000000);
    $npc->ModifyNPCStat("hp_regen", 1700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 42000);
    $npc->ModifyNPCStat("max_hit", 82000);
    $npc->ModifyNPCStat("atk", 1700);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 20);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # Start invulnerable
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1^35,1");

    # Heal to full
    $npc->SetHP($npc->GetMaxHP()) if $npc->GetMaxHP() > 0;

    # Check proximity every 2 seconds
    quest::settimer("check_guardian", 2);
}

sub EVENT_TIMER {
    if ($timer eq "check_guardian" && !$unlocked) {
        my $guardian1 = $entity_list->GetNPCByNPCTypeID(2191);
        if ($guardian1) {
            # 2D distance check (ignores Z height difference)
            my $dx = $npc->GetX() - $guardian1->GetX();
            my $dy = $npc->GetY() - $guardian1->GetY();
            my $dist = sqrt($dx**2 + $dy**2);

            if ($dist <= $unlock_distance) {
                # Unlock both guardians
                $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1^35,0");
                $guardian1->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1^35,0");

                $unlocked = 1; # Prevents repeat unlock attempts
                # No stoptimer here so it continues to run for debug; optional to remove later
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(2186, 11);
}