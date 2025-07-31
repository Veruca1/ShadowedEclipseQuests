sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(0);

    $npc->ModifyNPCStat("level", 100);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 9000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 100000);
    $npc->ModifyNPCStat("max_hit", 200000);
    $npc->ModifyNPCStat("atk", 3000);
    $npc->ModifyNPCStat("accuracy", 1900);
    $npc->ModifyNPCStat("avoidance", 105);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 90);
    $npc->ModifyNPCStat("aggro", 57);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1100);
    $npc->ModifyNPCStat("int", 1100);
    $npc->ModifyNPCStat("cha", 900);

    $npc->ModifyNPCStat("mr", 350);
    $npc->ModifyNPCStat("fr", 350);
    $npc->ModifyNPCStat("cr", 350);
    $npc->ModifyNPCStat("pr", 350);
    $npc->ModifyNPCStat("dr", 350);
    $npc->ModifyNPCStat("corruption_resist", 400);
    $npc->ModifyNPCStat("physical_resist", 900);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "12,1^13,1^14,1^15,1^16,1^17,1^31,1^18,1^35,1^26,1^28,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^46,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        #$client->Message(15, "Hunt Master says, 'Greetings, hunter! I am the Hunt Master. If you bring me hunting trophies, like rare beast remains, I will reward you with Hunter Credits. These credits can be used to purchase powerful items that I carry. Keep your eyes open—new trophies and rewards arrive often!'");
        quest::popup("Hunt Master", "Greetings, hunter!<br><br>I am the <b>Hunt Master</b>. Bring me rare hunting trophies and I will reward you with <b>Hunter Credits</b>.<br><br>You can spend these credits on powerful items I carry. Be sure to check in often—new items and trade-ins are added regularly!");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 33209 => 1)) {
        my $credits = quest::ChooseRandom(5..10);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(33209, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39594 => 1)) {
        my $credits = quest::ChooseRandom(11..25);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(39594, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39596 => 1)) {
        my $credits = quest::ChooseRandom(26..35);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(39596, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39616 => 1)) {
        my $credits = quest::ChooseRandom(36..45);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(39616, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 42420 => 1)) {
        my $credits = quest::ChooseRandom(46..55);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(42420, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 42448 => 1)) {
        my $credits = quest::ChooseRandom(56..65);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        # REMOVE quest::removeitem(42448, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 43647 => 1)) {
    my $credits = quest::ChooseRandom(66..95);
    $client->Message(15, "You receive $credits Hunter Credits.");
    quest::summonitem(33208, $credits);
    # REMOVE quest::removeitem(43647, 1);
}
    else {
        plugin::return_items(\%itemcount);
    }
}