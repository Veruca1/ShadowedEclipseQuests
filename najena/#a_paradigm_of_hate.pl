sub EVENT_SPAWN {
    # Spawn NPC 1427 at the specific location (315.99, 285.28, 1.25) with heading 251.00
    quest::spawn2(1427, 0, 0, 315.99, 285.28, 1.25, 251.00);
}

sub EVENT_SAY {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $puppetmaster_hand_in = "$char_id-puppetmaster_hand_in";

    ### Lockouts ################################
    my $puppetmaster_lock = $client->GetBucket("-puppetmaster_lockout");

    ### puppetmaster id and coordinates ############
    my $puppetmaster_id = 44137;
    my $puppetmaster_x = 223.04;
    my $puppetmaster_y = -14.00;
    my $puppetmaster_z = 2.50;
    my $puppetmaster_h = 383.50;
    #############################################
    
    if ($text =~ /hail/i) {
        if (quest::get_data($puppetmaster_hand_in)) {
            plugin::Whisper("I see you have already did a turn in. Would you like to fight " . quest::saylink("The Puppetmaster") . "?");
        } else {
            plugin::Whisper("I have nothing for you, begone.");
        }
    }

    if ($text =~ /Puppetmaster/i) {
        if (quest::get_data($puppetmaster_hand_in) == 1) {
            if (!$puppetmaster_lock) {
                $client->SetBucket("-puppetmaster_lockout", 1, 300);
                quest::depop(1203);
                quest::spawn2($puppetmaster_id, 0, 0, $puppetmaster_x, $puppetmaster_y, $puppetmaster_z, $puppetmaster_h);
            } else {
                quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-puppetmaster_lockout")) . "] to use again.");
            }
        }
    }
}

sub EVENT_ITEM {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $puppetmaster_hand_in = "$char_id-puppetmaster_hand_in";
    
    ### Item IDs for the dolls ####################
    my $doll1_id = 17721;  
    my $doll2_id = 17722;  
    my $doll3_id = 17723;  
    my $doll4_id = 17724;  

    if (plugin::check_handin(\%itemcount, $doll1_id => 1, $doll2_id => 1, $doll3_id => 1, $doll4_id => 1)) {
        quest::set_data($puppetmaster_hand_in, 1);
        plugin::Whisper("Thank you for the dolls. Now you can challenge The Puppetmaster when you're ready.");
    } else {
        plugin::return_items(\%itemcount);
    }
}
