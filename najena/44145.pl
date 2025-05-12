sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Check for aggro from any entity
        if ($npc->IsEngaged()) {
            # Send a marquee message to all group members
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 3000, "A deep maniacal laughter fills the dungeon");
            }

            # Shout a message to the entire zone
            quest::shout("You weak pathetic fools! You stand no chance reaching the great plane of hate! Chronomancer Zarrin has bestowed upon the Eclipse the ability to control! You will soon be our puppets!");

            # Make the NPC immediately disappear
            quest::depop();
        }
    }
}
