sub EVENT_SPAWN {
    # === Trash Stat Application ===
    $npc->ModifyNPCStat("level", 55);
    $npc->ModifyNPCStat("ac", 9000);
    $npc->ModifyNPCStat("max_hp", 100000);
    $npc->ModifyNPCStat("hp_regen", 600);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 3500);
    $npc->ModifyNPCStat("max_hit", 4500);
    $npc->ModifyNPCStat("atk", 800);
    $npc->ModifyNPCStat("accuracy", 800);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 3);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 55);
    $npc->ModifyNPCStat("aggro", 45);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 700);
    $npc->ModifyNPCStat("sta", 700);
    $npc->ModifyNPCStat("agi", 700);
    $npc->ModifyNPCStat("dex", 700);
    $npc->ModifyNPCStat("wis", 700);
    $npc->ModifyNPCStat("int", 700);
    $npc->ModifyNPCStat("cha", 500);

    $npc->ModifyNPCStat("mr", 150);
    $npc->ModifyNPCStat("fr", 150);
    $npc->ModifyNPCStat("cr", 150);
    $npc->ModifyNPCStat("pr", 150);
    $npc->ModifyNPCStat("dr", 150);
    $npc->ModifyNPCStat("corruption_resist", 120);
    $npc->ModifyNPCStat("physical_resist", 300);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");

    # Ensure full HP after modifying max_hp
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Start the timer for depop on spawn (10 minutes)
    quest::settimer("depop_check", 600); # 600 seconds = 10 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Stop the depop timer if engaged in combat
        quest::stoptimer("depop_check");
    } elsif ($combat_state == 0) {
        # Restart the depop timer if combat ends
        quest::settimer("depop_check", 600);
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        if (!$npc->IsEngaged()) {
            # Depop the NPC if not engaged
            quest::depop();
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Ensure the timer doesn't interfere post-death
    quest::stoptimer("depop_check");
}