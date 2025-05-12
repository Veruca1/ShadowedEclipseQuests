sub EVENT_ITEM {
    # Check if the player hands in the correct item to gain access to Kaesora
    if (plugin::check_handin(\%itemcount, 31688 => 1)) {
        # Grant access to Kaesora by setting the zone flag
        quest::set_zone_flag(88);   # Set zone flag for access to Kaesora

        # Notify the player about the access
        $client->Message(15, "You have been granted access to Kaesora!");
	quest::we(14,"Help me congratulate $name! $name has been granted access to Kaesora!");

        # The Guardian of Kaesora provides additional lore or warning
        $client->Message(14, "Be cautious as you enter Kaesora. It is said that powerful forces guard the secrets within, and not all who enter return unscathed.");
    }
    else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount);
    }
}
