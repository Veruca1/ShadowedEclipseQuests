sub EVENT_SAY {
    ##### Data buckets for turn-in flags #######
    my $char_id = $client->CharacterID();  
    my $echobossfight_hand_in = "$char_id-echobossfight_hand_in";  

    ### Lockouts ################################
    my $echobossfight_lock = $client->GetBucket("-echobossfight_lockout");

    ### NPC ID and coordinates for the new NPC ############
    my $new_npc_id = 12345;  # Replace with actual Echo Boss NPC ID
    my $new_npc_x = $x;
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
                $client->SetBucket("-echobossfight_lockout", 1, 600);  # 10-minute lockout
                quest::depop(1926);  # Depop this NPC
                quest::spawn2($new_npc_id, 0, 0, $new_npc_x, $new_npc_y, $new_npc_z, $new_npc_h);  # Spawn Echo Boss
            } else {
                quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-echobossfight_lockout")) . "] to fight again.");
            }
        } else {
            plugin::Whisper("You need to hand in the 4 heads first.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  
    my $echobossfight_hand_in = "$char_id-echobossfight_hand_in";

    ### Updated item IDs for the heads ###
    my @head_item_ids = (40388, 40389, 40390, 40391);

    my $heads_given = 0;

    # Count how many of the required items were handed in
    foreach my $head_item_id (@head_item_ids) {
        if (plugin::check_handin(\%itemcount, $head_item_id => 1)) {
            $heads_given++;
        }
    }

    if ($heads_given == 4) {
        quest::set_data($echobossfight_hand_in, 1);  
        plugin::Whisper("Thank you for the heads. You are now flagged to challenge the Echo Boss.");
    } else {
        plugin::return_items(\%itemcount);  
        plugin::Whisper("I need all 4 unique heads to proceed.");
    }
}