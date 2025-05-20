# a_paradigm_of_hate.pl

sub EVENT_SAY {
    ##### Data buckets for turn-in flags ###
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $left_hand = "$char_id-left_hand";
    my $right_hand = "$char_id-right_hand";
    my $both_hands = "$char_id-heat_flag";
    ### Lockouts ############################
    
    my $left_hand_lock = $client->GetBucket("-left_lockout");
    my $right_hand_lock = $client->GetBucket("-right_lockout");
    my $both_hand_lock = $client->GetBucket("-heat_lockout");
    #### turn ins ############################
    my $right_hand_id = 9548;       # Item ID for a right hand
    my $left_hand_id = 9549;        # Item ID for a left hand
    my $partial_anger_id = 36125;   # NPC ID for Partial Anger
    my $hates_heat_id = 36126;      # NPC ID for Hates Heat

    # Coordinates for Partial Anger
    my $partial_anger_x = -33.94;
    my $partial_anger_y = -976.09;
    my $partial_anger_z = -65.90;
    my $partial_anger_h = 387.75;

    # Coordinates for Hates Heat
    my $hates_heat_x = -53.07;
    my $hates_heat_y = -842.14;
    my $hates_heat_z = -65.90;
    my $hates_heat_h = 323.75;
    ## Check for boss #####################
    $check_for_heat =  $entity_list->GetMobByNpcTypeID(36126);
    ########################################################

    if ($text =~ /hail/i) {
        plugin::Whisper("You must turn in either the left, right, or both hands. Turning in just one hand, left or right, will unlock Partial Anger (a chance at an illusion item). Turning in both hands will unlock the main boss. Once unlocked, simply hail me to respawn the fights after their cooldowns.");

        if (quest::get_data($both_hands)) {
            plugin::Whisper("What fight would you like to do?");
            plugin::Whisper("" . quest::saylink("Left") . " hand fight (Partial Anger)");
            plugin::Whisper("" . quest::saylink("Right") . " hand fight (Partial Anger)");
            plugin::Whisper("" . quest::saylink("Both") . " hands fight (The Main Event)");
        } elsif (quest::get_data($left_hand)) {
            plugin::Whisper("Would you like to respawn the left hand turn-in?");
            plugin::Whisper("" . quest::saylink("Left") . " hand fight (Partial Anger)");
        } elsif (quest::get_data($right_hand)) {
            plugin::Whisper("Would you like to respawn the right hand turn-in? (Partial Anger)");
            plugin::Whisper("" . quest::saylink("Right") . " hand fight");
        }
    }

    if ($text =~ /right/i) {
        if (quest::get_data($right_hand) == 1) {
            if (!$right_hand_lock) {
            # Lockout in seconds (1 hour)
            $client->SetBucket("-right_lockout", 1, 300);
            quest::spawn2($partial_anger_id, 0, 0, $partial_anger_x, $partial_anger_y, $partial_anger_z, $partial_anger_h);
            } else {
                quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-right_lockout")) . "] to use again.");
            }
        }
    }

    if ($text =~ /left/i) {
        if (quest::get_data($left_hand) == 1) {
            if (!$left_hand_lock) {
            # Lockout in seconds (1 hour)
            $client->SetBucket("-left_lockout", 1, 300);
            quest::spawn2($partial_anger_id, 0, 0, $partial_anger_x, $partial_anger_y, $partial_anger_z, $partial_anger_h);
            } else {
                quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-left_lockout")) . "] to use again.");
            }
        }
    }

    if ($text =~ /both/i) {
    if ($both_hand_lock) {
        quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-heat_lockout")) . "] to use again.");
    } elsif (!$check_for_heat) {
        if (quest::get_data($both_hands) == 1) {
            # Lockout in seconds (1 hour)
            $client->SetBucket("-heat_lockout", 1, 300);
            quest::spawn2($hates_heat_id, 0, 0, $hates_heat_x, $hates_heat_y, $hates_heat_z, $hates_heat_h);
            quest::spawn2(502004, 0, 0, -130.71, -806.90, -65.90, 0);
            quest::settimer("shake", 0.1);
        }
    } else {
        quest::message(315, "I cannot spawn this at the moment, there is already a Hates Heat up.");
    }
}

}


sub EVENT_ITEM {
    my $right_hand_id = 9548; # Item ID for a right hand
    my $left_hand_id = 9549; # Item ID for a left hand
    my $partial_anger_id = 36125; # NPC ID for Partial Anger
    my $hates_heat_id = 36126; # NPC ID for Hates Heat

    # Coordinates for Partial Anger
    my $partial_anger_x = -33.94;
    my $partial_anger_y = -976.09;
    my $partial_anger_z = -65.90;
    my $partial_anger_h = 387.75;

    # Coordinates for Hates Heat
    my $hates_heat_x = -53.07;
    my $hates_heat_y = -842.14;
    my $hates_heat_z = -65.90;
    my $hates_heat_h = 323.75;
    #####Data buckets for turn in flags###
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $left_hand = "$char_id-left_hand";
    my $right_hand = "$char_id-right_hand";
    my $both_hands = "$char_id-heat_flag";
   
    ######################################
    # Check if both items are handed in at the same time
    if (plugin::check_handin(\%itemcount, $right_hand_id => 1, $left_hand_id => 1)) {
        #sets flag for both hands
        quest::set_data($both_hands, 1);
        # Spawn Hates Heat
        quest::spawn2($hates_heat_id, 0, 0, $hates_heat_x, $hates_heat_y, $hates_heat_z, $hates_heat_h);
        # Spawns hates signal mob
        quest::spawn2(502004, 0, 0, -130.71, -806.90, -65.90, 0);
        # Schedule a longer camera shake and shout after a delay to ensure NPC has spawned
        quest::settimer("shake", 0.1);
    } 
    else {
        # Check if the right hand is handed in
        if (plugin::check_handin(\%itemcount, $right_hand_id => 1)) {
            #sets flag for right hand
            quest::set_data($right_hand, 1);
            # Spawn Partial Anger
            quest::spawn2($partial_anger_id, 0, 0, $partial_anger_x, $partial_anger_y, $partial_anger_z, $partial_anger_h);
        }
        # Check if the left hand is handed in
        if (plugin::check_handin(\%itemcount, $left_hand_id => 1)) {
            #sets flag for left hand
            quest::set_data($left_hand, 1);
            # Spawn Partial Anger
            quest::spawn2($partial_anger_id, 0, 0, $partial_anger_x, $partial_anger_y, $partial_anger_z, $partial_anger_h);
        }
    }
    # Return items if they are not the correct ones
    plugin::return_items(\%itemcount);
}

sub EVENT_TIMER {
    if ($timer eq "shake") {
        $npc->CameraEffect(3000, 6); # Longer shake duration
        quest::settimer("shout", 3.1); # Delay to ensure the shake completes before the shout
        quest::stoptimer("shake");
    }
    elsif ($timer eq "shout") {
        # Assuming the NPC 36126 will be the last spawned NPC
        my $npc_id = 36126;
        my $spawned_npc = $entity_list->GetNPCByNPCTypeID($npc_id);
        if ($spawned_npc) {
            $spawned_npc->Shout("I am Xyron's heated breath, you have sealed your doom!");
        }
        quest::stoptimer("shout");
    }
}

sub EVENT_DEATH_COMPLETE {
    if ($npc->GetNPCTypeID() == 36126) {
        $npc->Shout("You may think you have won, but you will fail where nobody gets rest!");
    }
}