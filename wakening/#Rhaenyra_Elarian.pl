sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Whisper message to the player
        quest::whisper("You have arrived at a most troubling time, adventurer. If you are here seeking the blessings of Tunare, I fear you will find only silence.");

        # Pop-up window with detailed lore and instructions
        quest::popup("Something Is Amiss in the Wakening Lands", "
        <c '#FFCC00'>*The elven envoy stands at the threshold of the Plane of Growth, her expression troubled, her voice filled with unease.*</c><br><br>

        \"You have arrived at a most troubling time, adventurer. The Wakening Lands are not as they should be. The defenders—beasts, spirits, and guardians alike—stand idle as invaders ravage the land. They do not fight. They do not flee. They simply… watch, as if the fate of this sacred place no longer concerns them.\"<br><br>

        <c '#FFCC00'>*She gestures toward the Plane of Growth’s entrance, her gaze darkening.*</c><br><br>

        \"And worse still, Tunare herself does not answer my call. The gateway remains sealed, barring all who would enter. I have never known Her to turn away from Her own creation. Something is very, very wrong.\"<br><br>

        <c '#FFCC00'>*She turns back to you, studying you with measured hope.*</c><br><br>

        \"We must uncover the truth. Why do the guardians forsake their duty? What force holds sway over them? If there is one among these lands who remembers the way things were—one who has seen the passage of time and the change it brings—it is them we must find.\"<br><br>

        \"Go forth, adventurer. Seek answers where you can. I fear we have little time.\"
        ");

        # Start a 40-second timer
        quest::settimer("roar_event", 40);
    }
}

sub EVENT_TIMER {
    if ($timer eq "roar_event") {
        quest::stoptimer("roar_event");

        # Get all clients in the zone
        my @clients = $entity_list->GetClientList();

        foreach my $client (@clients) {
            # Check if client exists (may not be always defined)
            if ($client) {
                # Send a green message to the client (Message ID 14 is green)
                $client->Message(14, "A loud ROAR suddenly comes from the south-east.");
            }
        }
    }

        # Spawn NPC ID 1744 at the three given locations
        quest::spawn2(1744, 0, 0, -2926.08, -2941.67, 29.19, 395.75);
        quest::spawn2(1744, 0, 0, -2961.33, -2876.01, 29.19, 358.75);
        quest::spawn2(1744, 0, 0, -3061.78, -2858.78, 29.19, 235.50);
	quest::spawn2(1699, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
    }

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the player's character ID
    my $flag_699 = "$char_id-699_handin";  # Databucket for item 699 hand-in
    my $flag_701 = "$char_id-701_handin";  # Databucket for item 701 hand-in (formerly 671)
    my $flag_809 = "$char_id-809_handin";  # Databucket for item 809 hand-in
    my $flag_820 = "$char_id-820_handin";  # Databucket for item 820 hand-in

    # Check if the player has already handed in item 699
    if (plugin::check_handin(\%itemcount, 699 => 1)) {
        if (quest::get_data($flag_699)) {
            quest::say("You have already handed in this item and cannot do so again.");
            plugin::return_items(\%itemcount);  # Return the item if already handed in
        } else {
            quest::say("You have proven your dedication. Here is what you seek.");
            quest::summonitem(693);  # Give the player item 693
            quest::set_data($flag_699, 1);  # Set the flag to prevent future hand-ins
        }
    }
    # Check if the player has already handed in item 701 (formerly 671)
    elsif (plugin::check_handin(\%itemcount, 701 => 1)) {
        if (quest::get_data($flag_701)) {
            quest::say("You have already handed in this item and cannot do so again.");
            plugin::return_items(\%itemcount);  # Return the item if already handed in
        } else {
            quest::say("Ah, you have brought the Planar Power Rank 8 Draft! Here, take this as a token of my appreciation.");
            quest::summonitem(676);  # Give the player item 676
            quest::set_data($flag_701, 1);  # Set the flag to prevent future hand-ins
        }
    }
    # Check if the player has handed in item 809
    elsif (plugin::check_handin(\%itemcount, 809 => 1)) {
        if (quest::get_data($flag_809)) {
            quest::say("You have already handed in this item and cannot do so again.");
            plugin::return_items(\%itemcount);  # Return the item if already handed in
        } else {
            quest::say("Thank you for providing the Combat Agility Rank 5 Draft. Here is your reward.");
            quest::summonitem(858);  # Give the player item 858
            quest::set_data($flag_809, 1);  # Set the flag to prevent future hand-ins
        }
    }
    # Check if the player has handed in item 820
    elsif (plugin::check_handin(\%itemcount, 820 => 1)) {
        if (quest::get_data($flag_820)) {
            quest::say("You have already handed in this item and cannot do so again.");
            plugin::return_items(\%itemcount);  # Return the item if already handed in
        } else {
            quest::say("You have provided the Planar Power Rank 9 Draft. Here is your reward.");
            quest::summonitem(859);  # Give the player item 859
            quest::set_data($flag_820, 1);  # Set the flag to prevent future hand-ins
        }
    }
    else {
        # If the item is not recognized, return it
        plugin::return_items(\%itemcount);
    }
}
