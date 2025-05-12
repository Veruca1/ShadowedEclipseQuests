sub EVENT_SAY {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $tyranthrax_hand_in = "$char_id-tyranthrax_hand_in";

    ### Lockouts ################################
    my $tyranthrax_lock = $client->GetBucket("-tyranthrax_lockout");

    ### tyranthrax id and coordinates ############
    my $tyranthrax_id = 86176;
    my $tyranthrax_x = 270.88;
    my $tyranthrax_y = 542.38;
    my $tyranthrax_z = 4.84;
    my $tyranthrax_h = 378.75;
    #############################################
    
    if ($text =~ /hail/i) {
        if (quest::get_data($tyranthrax_hand_in)) {
            plugin::Whisper("I see you have already did a turn in. Would you like to fight " . quest::saylink("Tyranthrax") . "?");
        } else {
            plugin::Whisper("I have nothing for you, begone.");
        }
    }

    if ($text =~ /Tyranthrax/i) {
        if (quest::get_data($tyranthrax_hand_in) == 1) {
            if (!$tyranthrax_lock) {
                 $client->SetBucket("-tyranthrax_lockout", 1, 90);
                quest::depop(1203);
                quest::spawn2($tyranthrax_id, 0, 0, $tyranthrax_x, $tyranthrax_y, $tyranthrax_z, $tyranthrax_h);
            }else{
            quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-tyranthrax_lockout")) . "] to use again.");
            }
        }
    }
}

sub EVENT_ITEM {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $tyranthrax_hand_in = "$char_id-tyranthrax_hand_in";
    
    ### Item ID for the book ####################
    my $book_id = 17674;  # Replace with the actual book ID

    if (plugin::check_handin(\%itemcount, $book_id => 1)) {
        quest::set_data($tyranthrax_hand_in, 1);
        plugin::Whisper("Thank you for the book. Now you can challenge Tyranthrax when you're ready.");
    } else {
        plugin::return_items(\%itemcount);
    }
}