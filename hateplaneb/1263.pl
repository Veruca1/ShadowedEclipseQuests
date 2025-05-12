sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 28361;  # The item to hand in
    my $flag = "$char_id-anomaly_flag";  # Unique flag identifier for this event
    my $cooldown_key = "$char_id-anomaly_cooldown";  # Cooldown key
    my $cooldown_time = 900;  # 15-minute cooldown in seconds

    # Check if the player handed in the correct item
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        # Notify the player of success
        $client->Message(15, "It's about time you return what you stole. Time for penance. I'd stand back if I were you.....");

        # Update the cooldown timer
        quest::set_data($cooldown_key, time());

        # Start a timer to depop this NPC (Anomaly) after a delay of 10 seconds
        quest::settimer("depop_anomaly", 10);
    } else {
        # Return the item if it's not the correct one
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-anomaly_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-anomaly_cooldown";  # Cooldown key
    my $cooldown_time = 900;  # 15-minute cooldown in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $last_cooldown_time = quest::get_data($cooldown_key);
            my $current_time = time();

            # Check if the cooldown has expired
            if (!$last_cooldown_time || ($current_time - $last_cooldown_time) > $cooldown_time) {
                # Update the cooldown timer
                quest::set_data($cooldown_key, $current_time);

                # Notify the player and trigger the event
                $client->Message(15, "Welcome back. Let me trigger the event for you.");
                quest::settimer("depop_anomaly", 10);
            } else {
                # Notify the player of remaining cooldown time
                my $remaining_time = $cooldown_time - ($current_time - $last_cooldown_time);
                $client->Message(15, "You must wait a little longer before triggering this event again. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            $client->Message(15, "You must complete the hand-in before I can help you.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_anomaly") {
        # Get the NPC's current location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Depop this NPC (Anomaly) and spawn the new NPC
        quest::depop_withtimer();
        quest::spawn2(223003, 0, 0, $x, $y, $z, $h);

        # Stop the timer
        quest::stoptimer("depop_anomaly");
    }
}
