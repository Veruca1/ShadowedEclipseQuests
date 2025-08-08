sub EVENT_SPAWN {
    # Modify NPC stats
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", 15000);
    $npc->ModifyNPCStat("max_hp", 500000);
    $npc->ModifyNPCStat("hp_regen", 1200);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 20000);
    $npc->ModifyNPCStat("max_hit", 40000);
    $npc->ModifyNPCStat("atk", 1900);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 80);
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

    $npc->ModifyNPCStat("mr", 800);
    $npc->ModifyNPCStat("fr", 800);
    $npc->ModifyNPCStat("cr", 800);
    $npc->ModifyNPCStat("pr", 800);
    $npc->ModifyNPCStat("dr", 800);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 3);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1^27,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Start the hunt timer
    quest::settimer("hunt", 1);

    # Start depop check timer
    quest::settimer("check_despawn", 120); # 2 minutes
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();

        # Remove GMs
        @clients = grep { !$_->GetGM() } @clients;

        if (@clients) {
            my $target = $clients[rand @clients];
            $target->Message(15, "You feel like you are being watched");
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), true);
        }

        quest::settimer("hunt", 5); # Repeat every 5 seconds
    }

    elsif ($timer eq "check_despawn") {
        # If not in combat after 2 minutes, depop
        if ($npc->GetCombatState() == 0) {
            quest::stoptimer("hunt");
            quest::stoptimer("check_despawn");
            quest::depop();
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");
    quest::stoptimer("check_despawn");
}