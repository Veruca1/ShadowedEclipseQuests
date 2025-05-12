sub EVENT_SAY {
    if ($text=~/hail/i) {
        my $task_id = 17;  # Task ID for City of Mist Access
        $client->Message(14, "Greetings, adventurer. There is a disturbance in The City of Mist, formerly known as Torsis. To gain access to the city, I need you to run a few errands for me.");
        quest::assigntask($task_id);  # Assign task ID 17
    }
}

sub EVENT_ITEM {
    my $item_id_33027 = 33027;
    my $stack_size = 30;
    my $item_id_access_90 = 33120;  # Item ID for City of Mist access
    my $item_id_access_85 = 33030;  # Item ID for Lake of Ill Omen access
    my $task_id_18 = 18;  # Task ID for the next quest after City of Mist access is granted

    # Check if the player handed in exactly 30 of item ID 33027
    if (plugin::check_handin(\%itemcount, $item_id_33027 => $stack_size)) {
        quest::say("Very well, good luck!");
        # Spawn NPC 1392 at the specified location with heading
        quest::spawn2(1392, 0, 0, 286.18, 1245.05, -338.84, 264.25);
    }
    # Check if the player handed in item 33120 for City of Mist access
    elsif (plugin::check_handin(\%itemcount, $item_id_access_90 => 1)) {
        quest::say("You have proven yourself worthy. You now have access to the City of Mist.");
        quest::set_zone_flag(90);  # Grant access to City of Mist (zone ID 90)
        quest::say("Additionally, I have another task for you.");
        quest::assigntask($task_id_18);  # Assign task ID 18 after granting access
    }
    # Check if the player handed in item 33030 for Lake of Ill Omen access
    elsif (plugin::check_handin(\%itemcount, $item_id_access_85 => 1)) {
        $client->Message(14, "Outstanding! You have undone Zarrin's work in Torsis and saved Zal`Ashiir. Amazing work adventurer. However, you are needed at once at the Lake of Ill Omen. Meet up with Syrik Iceblood at the lake's western shore.");
        quest::set_zone_flag(85);  # Grant access to Lake of Ill Omen (zone ID 85)
    }
    else {
        # Return the items if the condition is not met
        plugin::return_items(\%itemcount);
    }
}
