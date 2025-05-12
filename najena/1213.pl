my $item_id = 17720;  # Item ID for the quest item
my $reward_item = 17724;  # Item ID for the reward

sub EVENT_ITEM {
    # Check if the player hands in item 17720
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Confirmation message for handing in the correct item
        quest::say("Thank you for this item, I still hate you, but here is your reward.");
        
        # Give the player the reward item
        quest::summonitem($reward_item);
        
        # Depop the NPC after completing the transaction
        quest::depop();
    } else {
        # Return any incorrect items handed in
        quest::say("I have no need for this item, fool!");
        
        # Return the items to the player
        plugin::return_items(\%itemcount);
    }
}
