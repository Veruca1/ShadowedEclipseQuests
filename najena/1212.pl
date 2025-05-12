sub EVENT_ITEM {
    # Check if the item handed in is 17719
    if (plugin::check_handin(\%itemcount, 17719 => 1)) {
        quest::say("Thank you for this item, I still hate you, but here is your reward.");
        
        # Give the player item 17723
        quest::summonitem(17723);
        
        # Depop the NPC
        quest::depop();
    } else {
        # If some other item is handed in, return it
        quest::say("I have no need for this item, fool!");
        plugin::return_items(\%itemcount);
    }
}
