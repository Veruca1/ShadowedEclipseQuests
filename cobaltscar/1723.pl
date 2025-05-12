sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Retrieve the character ID for the player
        my $char_id = $client->CharacterID();  # Get the player's unique character ID

        # Send the green text message to the player
        $client->Message(14, "Greetings again, it is good to see you. We don't have much detailed information about this area. Siren's Grotto is sealed off and requires a key to enter. However, to construct the key it is said you need to gather 10 specific items. Those being 2 siren scales, 2 othmir short beers, 2 pristine wyvern hides, and then 4 impression items: Siren, Wyvern, Othmir, and Sea Beast. The impressions are no doubt from some form of leadership from those groups. As for what to combine those items in, you will need to use some sort of 10-slot container. Perhaps you are already familiar with such a container?");
    }
}
