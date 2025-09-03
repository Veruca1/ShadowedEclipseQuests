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
    # Get the character's ID
    my $char_id = $client->CharacterID(); 
    # Create a data bucket/flag for character to use later
    my $thaum_flag = "$char_id-Thaumaturgist_kill";
    my $has_thaum_flag = quest::get_data($thaum_flag);

    if ($text =~ /hail/i && defined $has_thaum_flag && $has_thaum_flag == 1) {
        quest::whisper("Thanks again for helping me with the Thaumaturgist. I will let you know if I need your assistance again.");
    } elsif ($text =~ /hail/i && $ulevel >= 30 && (!defined $has_thaum_flag || $has_thaum_flag != 1)) {
        quest::whisper("I offer you the ability to summon an additional companion, but this comes with a price. Are you " . quest::saylink("interested") . "?");
    } elsif ($text =~ /interested/i && $ulevel >= 30) {
        quest::whisper("Good, bring me back the head of The Thaumaturgist! That is all I ask, and I will grant you an extra companion.");
    } else {
        quest::whisper("Begone! I will let you know when it is time for your aid!");
    }
}

sub EVENT_ITEM {
    # Get the character's ID
    my $char_id = $client->CharacterID(); 
    # Creates data bucket/flag for character to use later
    my $thaum_flag = "$char_id-Thaumaturgist_kill";
    # Checks if they hand in is correct
    if (plugin::check_handin(\%itemcount, 9544 => 1) && $ulevel >= 30) {
        
        my $current_limit = $client->GetBotSpawnLimit(); # Get current bot spawn limit
        my $new_limit = 3;

        # Only upgrade if current limit is less than the new limit
        if ($current_limit < $new_limit) {
            quest::whisper("Thanks for your service, this necromancer has caused enough troubles. As promised here is your extra companion.");
            # Increases the bot spawn limit to 3
            $client->SetBotSpawnLimit($new_limit);
            # Sends a message to the zone
            quest::we(7, "Help me congratulate $name! They have assisted Elondra Aradune in defeating The Thaumaturgist and received an additional companion!");
        } else {
            # Player already has this limit or higher
            quest::whisper("Thanks for your service defeating The Thaumaturgist, but you already have a bot spawn limit of $current_limit, which is equal to or higher than what I can offer ($new_limit). Your limit remains unchanged.");
        }

        # Sets flag for later use to check if they have handed in the head (regardless of upgrade)
        quest::set_data($thaum_flag, 1);

    } else {
        plugin::return_items(\%itemcount);
    }
}