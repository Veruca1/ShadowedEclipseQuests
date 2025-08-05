sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 254;  # Shard of Disruption (ID 254)
    my $flag = "$char_id-disturbance_flag";  # Create a unique flag identifier for this NPC and item

    # Check if the player handed in the required item (Shard of Disruption)
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);
        
        quest::whisper("You have done well. You may now simply hail me to proceed in the future.");

        # Spawn NPC 1425, one NPC 1439, and one NPC 1442 at the specific locations after the hand-in
        quest::spawn2(1425, 0, 0, -644.02, -63.53, 16.98, 131.00);  # NPC 1425
        quest::spawn2(1439, 0, 0, -645.05, -91.67, 16.98, 130.50);  # NPC 1439
        quest::spawn2(1442, 0, 0, -634.64, -91.67, 16.96, 128.25);  # NPC 1442

        # Send a signal with 1 to NPC 1427 with a delay of 2 seconds
        quest::signalwith(1427, 1, 2);

        # Set a timer to trigger after 5 seconds (5000 ms) for NPC movement
        quest::settimer("move_npcs", 5);
    } else {
        # Return the item if it's not the correct one
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer eq "move_npcs") {
        # Stop the timer after movement starts
        quest::stoptimer("move_npcs");

        # Make NPC 1439 move to the specified location
        my $npc1 = $entity_list->GetMobByNpcTypeID(1439);
        if ($npc1) {
            $npc1->CastToNPC()->MoveTo(-591.27, -55.87, 17.26, 125.00, 1);  # NPC 1439 walks
        }

        # Make NPC 1442 move to the specified location
        my $npc2 = $entity_list->GetMobByNpcTypeID(1442);
        if ($npc2) {
            $npc2->CastToNPC()->MoveTo(-589.75, -90.53, 16.77, 124.50, 1);  # NPC 1442 walks
        }

        # Make NPC 1425 move to the specified location
        my $npc3 = $entity_list->GetMobByNpcTypeID(1425);
        if ($npc3) {
            $npc3->CastToNPC()->MoveTo(-613.47, -77.35, 16.77, 127.75, 1);  # NPC 1425 walks
        }

        # Set another timer to handle depop and transformation to NPC 1443 after 10 more seconds
        quest::settimer("transform_npcs", 10);
    }

    if ($timer eq "transform_npcs") {
        # Stop the timer for the transformation
        quest::stoptimer("transform_npcs");

        # Depop NPC 1439 and replace with NPC 1443 at the same location
        my $npc1 = $entity_list->GetMobByNpcTypeID(1439);
        if ($npc1) {
            my $x1 = $npc1->GetX();
            my $y1 = $npc1->GetY();
            my $z1 = $npc1->GetZ();
            my $h1 = $npc1->GetHeading();
            $npc1->Depop();
            quest::spawn2(1443, 0, 0, $x1, $y1, $z1, $h1);  # Spawn NPC 1443 at 1439's position
        }

        # Depop NPC 1442 and replace with NPC 1443 at the same location
        my $npc2 = $entity_list->GetMobByNpcTypeID(1442);
        if ($npc2) {
            my $x2 = $npc2->GetX();
            my $y2 = $npc2->GetY();
            my $z2 = $npc2->GetZ();
            my $h2 = $npc2->GetHeading();
            $npc2->Depop();
            quest::spawn2(1443, 0, 0, $x2, $y2, $z2, $h2);  # Spawn NPC 1443 at 1442's position
        }
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-disturbance_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-disturbance_cooldown";  # A unique cooldown key
    my $cooldown_time = 30;  # 30 second cooldown

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                quest::whisper("Welcome back. Let me trigger the event for you.");
                
                # Spawn NPC 1425, one NPC 1439, and one NPC 1442 at the specified locations after the hail
		# Send a signal with 1 to NPC 1427 with a delay of 2 seconds
                quest::signalwith(1427, 1, 2);
                quest::spawn2(1425, 0, 0, -644.02, -63.53, 16.98, 131.00);  # NPC 1425
                quest::spawn2(1439, 0, 0, -645.05, -91.67, 16.98, 130.50);  # NPC 1439
                quest::spawn2(1442, 0, 0, -634.64, -91.67, 16.96, 128.25);  # NPC 1442

                # Set a timer to trigger after 5 seconds (5000 ms) for NPC movement
                quest::settimer("move_npcs", 5);
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                quest::whisper("You must wait a little longer before you can trigger this event again. Time remaining: $remaining_time seconds.");
            }
        } else {
            quest::whisper("You must complete the hand-in before I can help you.");
        }
    }
}
