sub EVENT_ITEM_CLICK {
    # Check if the Coin of Fate (Item ID 523) exists in the player's inventory
    if (quest::countitem(523) >= 1) {
        # Perform your actions here
        quest::we(14, "$name has used the Coin of Fate!");
        
        # Remove the Coin of Fate from the player's inventory
        quest::removeitem(523, 1);

        # Randomly determine which effect to trigger (1 to 10)
        my $random_effect = plugin::RandomRange(1, 10);

        # Apply the random effect
        if ($random_effect == 1) {
            # Summon a stack of 20 items (33179)
            $client->SummonItem(33179, 20);
        }
        elsif ($random_effect == 2) {
            # Summon a stack of 20 items (33180)
            $client->SummonItem(33180, 20);
        }
        elsif ($random_effect == 3) {
            # Summon a single item (33182)
            $client->SummonItem(33182);
        }
        elsif ($random_effect == 4) {
            # Summon a single item (43494)
            $client->SummonItem(43494);
        }
        elsif ($random_effect == 5) {
            # Teleport to Kedge Keep (Zone 64) at specified location
            $client->MovePC(64, 103.79, 10.57, -277.62, 214.25);
        }
        elsif ($random_effect == 6) {
            # Teleport to Befallen (Zone 36) at specified location
            $client->MovePC(36, 0, 0, 0, 0);
        }
        elsif ($random_effect == 7) {
            # Summon the Portable Banker Device (Item ID 540)
            $client->SummonItem(540);
        }
        elsif ($random_effect == 8) {
            # Reduce user's HP to 1
            $client->SetHP(1);
            # Send a whispered message
            $client->Message(15, "Your health has been reduced to 1 HP. This is part of a courtesy we like to extend to our most enthusiastic players. Thank you for your non-fiscal patronage.");
        }
        elsif ($random_effect == 9) {
            # Teleport to Beholder Zone (Zone ID 16) at specified location
            $client->MovePC(16, -387.41, 432.66, -96.22, 281.25);
        }
        elsif ($random_effect == 10) {
            # Summon an AA 3 Point Scroll (Item ID 490)
            $client->SummonItem(490);
        }

        # Exit after performing the effect
        return;
    } else {
        # If the Coin of Fate is not found in the inventory
        $client->Message(13, "Coin of Fate not found in your inventory, must be in an actual inventory slot, not a bag!");
    }
}