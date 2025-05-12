sub EVENT_ITEM_CLICK {
  # Check if the correct item (477) is clicked
  if ($itemid == 477) {
    # Define the destination coordinates for Veeshan's Peak (Zone 108)
    my $dest_x = -464.59;
    my $dest_y = 707.47;
    my $dest_z = 449.01;
    my $dest_heading = 0;  # Adjust heading if needed

    # Get the player's current instance ID
    my $instance_id = $client->GetInstanceID();

    # Teleport the player to the specified location in Veeshan's Peak (Zone 108) and instance
    $client->MoveZoneInstance($instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);

    # Notify the player that they have been teleported
    $client->Message(4, "You have been teleported to Veeshan's Peak!");
  }
}