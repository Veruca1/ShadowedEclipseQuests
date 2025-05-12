# #an_empty_chest.pl

sub EVENT_ITEM {
    # Item ID to trigger the event
    my $item_id = 9543;
    
    # Check if the player handed in the correct item
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Send a private message to the player
        $client->Message(15, "The chest shakes and rattles!");
        quest::doanim(3); # Replace with appropriate animation if needed

        # Coordinates for spawning the bosses
        my $spawn_x = -30.81;
        my $spawn_y = -582.56;
        my $spawn_z = -65.90;
        my $spawn_h = 20.00;
        
        # Despawn the current NPC
        #quest::depop_withtimer();
        
        # Spawn the two bosses
        quest::spawn2(36121, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h); # Monster
        quest::spawn2(36122, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h); # Mash
    } else {
        # Return the item if it is not the correct one
        plugin::return_items(\%itemcount);
    }
}
