sub EVENT_SAY {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $echobossfight_hand_in = "$char_id-echobossfight_hand_in";  # Store the turn-in flag for the heads

    ### Lockouts ################################
    my $echobossfight_lock = $client->GetBucket("-echobossfight_lockout");

    ### NPC ID and coordinates for the new NPC 12345 ############
    my $new_npc_id = 12345;  # Replace with the actual NPC ID
    my $new_npc_x = $x;  # Use current location or specify coordinates
    my $new_npc_y = $y;
    my $new_npc_z = $z;
    my $new_npc_h = $h;
    #############################################

    if ($text =~ /hail/i) {
        if (quest::get_data($echobossfight_hand_in)) {
            plugin::Whisper("You have already turned in the heads. You are now flagged to fight the Echo Boss. Would you like to challenge the Echo Boss?");
        } else {
            plugin::Whisper("I need the 4 heads before I can help you. Please hand them in.");
        }
    }

    if ($text =~ /Echo Boss/i) {
        if (quest::get_data($echobossfight_hand_in)) {
            if (!$echobossfight_lock) {
                $client->SetBucket("-echobossfight_lockout", 1, 600);  # Lockout for 10 minutes
                quest::depop(1926);  # Depop this NPC after the fight
                quest::spawn2($new_npc_id, 0, 0, $new_npc_x, $new_npc_y, $new_npc_z, $new_npc_h);  # Spawn new NPC
            } else {
                quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-echobossfight_lockout")) . "] to fight again.");
            }
        } else {
            plugin::Whisper("You need to hand in the 4 heads first.");
        }
    }
}

sub EVENT_ITEM {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $echobossfight_hand_in = "$char_id-echobossfight_hand_in";

    ### Item IDs for the heads ###################
    my @head_item_ids = (12345, 12346, 12347, 12348);  # Replace with actual head item IDs

    my $heads_given = 0;

    # Check if the player handed in all 4 heads
    foreach my $head_item_id (@head_item_ids) {
        if (plugin::check_handin(\%itemcount, $head_item_id => 1)) {
            $heads_given++;
        }
    }

    if ($heads_given == 4) {
        quest::set_data($echobossfight_hand_in, 1);  # Flag the player as having handed in the heads
        plugin::Whisper("Thank you for the heads. You are now flagged to challenge the Echo Boss.");
    } else {
        plugin::return_items(\%itemcount);  # Return items if not all heads were handed in
        plugin::Whisper("I need all 4 heads to proceed.");
    }
}