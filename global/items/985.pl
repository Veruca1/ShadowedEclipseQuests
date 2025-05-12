sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();              # Get the player's character ID
    my $flag_985 = "$char_id-985_handin";              # Unique flag per character
    my $name = $client->GetCleanName();                # Get player's name for broadcast

    if (quest::get_data($flag_985)) {
        $client->Message(15, "You have already used a Second Bot Doll. It has no effect.");
    } else {
        $client->Message(15, "You feel a new power awaken—your second bot is now available.");
        $client->SetBotSpawnLimit(2);                  # Grant access to a second bot
        quest::set_data($flag_985, 1);                 # Set the flag so it can’t be reused
        $client->NukeItem(985);                        # Consume the item from inventory

        quest::we(7, "Help me congratulate $name! They have defeated the Agent of Zarrin and acquired an additional companion!");
    }
}
