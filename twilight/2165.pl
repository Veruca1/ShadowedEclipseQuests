use List::Util qw(max);

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ PET 2165 base stats (halved)
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 10000);
    $npc->ModifyNPCStat("max_hp", 3775000);
    $npc->ModifyNPCStat("hp_regen", 500);
    $npc->ModifyNPCStat("mana_regen", 5000);
    $npc->ModifyNPCStat("min_hit", 10000);
    $npc->ModifyNPCStat("max_hit", 20000);
    $npc->ModifyNPCStat("atk", 700);
    $npc->ModifyNPCStat("accuracy", 1000);
    $npc->ModifyNPCStat("avoidance", 45);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 16);  # rounded down
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 600);
    $npc->ModifyNPCStat("sta", 600);
    $npc->ModifyNPCStat("agi", 600);
    $npc->ModifyNPCStat("dex", 600);
    $npc->ModifyNPCStat("wis", 600);
    $npc->ModifyNPCStat("int", 600);
    $npc->ModifyNPCStat("cha", 500);

    $npc->ModifyNPCStat("mr", 150);
    $npc->ModifyNPCStat("fr", 150);
    $npc->ModifyNPCStat("cr", 150);
    $npc->ModifyNPCStat("pr", 150);
    $npc->ModifyNPCStat("dr", 150);
    $npc->ModifyNPCStat("corruption_resist", 250);
    $npc->ModifyNPCStat("physical_resist", 500);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Start ramp-up HP event chain
    quest::setnexthpevent(75);

    # ✅ Start timer for visual effects + buff
    quest::settimer("init_effects", 1);
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 75) {
        quest::shout("The guardian's rage grows stronger!");
        $npc->ModifyNPCStat("min_hit", 12000);
        $npc->ModifyNPCStat("max_hit", 25000);
        $npc->ModifyNPCStat("atk", 800);
        $npc->ModifyNPCStat("accuracy", 1200);
        $npc->ModifyNPCStat("avoidance", 50);
        quest::setnexthpevent(50);

    } elsif ($hpevent == 50) {
        quest::shout("The guardian strikes harder as it weakens!");
        $npc->ModifyNPCStat("min_hit", 14000);
        $npc->ModifyNPCStat("max_hit", 30000);
        $npc->ModifyNPCStat("atk", 900);
        $npc->ModifyNPCStat("accuracy", 1400);
        $npc->ModifyNPCStat("avoidance", 55);
        quest::setnexthpevent(25);

    } elsif ($hpevent == 25) {
        quest::shout("The guardian is furious — its final blows are deadly!");
        $npc->ModifyNPCStat("min_hit", 16000);
        $npc->ModifyNPCStat("max_hit", 35000);
        $npc->ModifyNPCStat("atk", 1100);
        $npc->ModifyNPCStat("accuracy", 1600);
        $npc->ModifyNPCStat("avoidance", 60);
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        # ✅ Apply visual tint
        $npc->SetNPCTintIndex(53);

        # ✅ Force buff: 13378
        $npc->SpellFinished(13378, $npc) if !$npc->FindBuff(13378);
    }
}