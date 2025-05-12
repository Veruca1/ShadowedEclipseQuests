sub EVENT_SAY {
    # Get the character's ID
    my $char_id = $client->CharacterID(); 
    # Create a data bucket/flag for character to use later
    my $thaum_flag = "$char_id-Thaumaturgist_kill";
    my $has_thaum_flag = quest::get_data($thaum_flag);

    if ($text =~ /hail/i && defined $has_thaum_flag && $has_thaum_flag == 1) {
        quest::message(14, "Thanks again for helping me with the Thaumaturgist. I will let you know if I need your assistance again.");
    } elsif ($text =~ /hail/i && $ulevel >= 30 && (!defined $has_thaum_flag || $has_thaum_flag != 1)) {
        quest::message(14, "I offer you the ability to summon an additional companion, but this comes with a price. Are you " . quest::saylink("interested") . "?");
    } elsif ($text =~ /interested/i && $ulevel >= 30) {
        quest::message(14, "Good, bring me back the head of The Thaumaturgist! That is all I ask, and I will grant you an extra companion.");
    } else {
        quest::message(14, "Begone! I will let you know when it is time for your aid!");
    }
}

sub EVENT_ITEM {
    # Get the character's ID
    my $char_id = $client->CharacterID(); 
    # Creates data bucket/flag for character to use later
    my $thaum_flag = "$char_id-Thaumaturgist_kill";
    # Checks if they hand in is correct
    if (plugin::check_handin(\%itemcount, 9544 => 1) && $ulevel >= 30) {
        
        quest::message(14, "Thanks for your service, this necromancer has caused enough troubles. As promised here is your extra companion.");
        # Increases the bot spawn limit to 3
        $client->SetBotSpawnLimit(3);
        # Sends a message to the zone
        quest::we(7, "Help me congratulate $name! They have assisted Elondra Aradune in defeating The Thaumaturgist and received an additional companion!");
        # Sets flag for later use to check if they have handed in the head
        quest::set_data($thaum_flag, 1);

    } else {
        plugin::return_items(\%itemcount);
    }
}
