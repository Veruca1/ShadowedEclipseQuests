sub EVENT_ITEM {
    # Check if the player handed in item 17717
    if (plugin::check_handin(\%itemcount, 17717 => 1)) {
        quest::say("Thank you for this item, I still hate you, but here is your reward.");

        # Give the player item 17721
        quest::summonitem(17721);

        # Depop the NPC
        quest::depop();
    } else {
        quest::say("I have no need for this item, fool!");

        # Return all items to the player
        plugin::return_items(\%itemcount);
    }
}
