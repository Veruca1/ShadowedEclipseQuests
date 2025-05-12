sub EVENT_ITEM_CLICK {
  # Check if the correct item (33193) is clicked
  if ($itemid == 33193) {
    # Define the destination coordinates for Temple of Veeshan
    my $dest_x = -500.37;
    my $dest_y = -2023.37;
    my $dest_z = -45.90;
    my $dest_heading = 508.75;

    # Get the group object
    my $group = $client->GetGroup();

    if ($group) {
      # Get the instance ID of the group leader
      my $instance_id = $client->GetInstanceID();

      # Iterate through group members
      for (my $i = 0; $i < $group->GroupCount(); $i++) {
        my $member = $group->GetMember($i);
        if ($member && $member->IsClient()) {
          # Teleport each group member to the correct instance
          $member->CastToClient()->MovePCInstance(124, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
        }
      }      
      $client->Message(4, "Your group has been teleported to your instance of Temple of Veeshan!");
    } else {
      # If no group, teleport the player only to their instance
      my $instance_id = $client->GetInstanceID();
      $client->MovePCInstance(124, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
      $client->Message(4, "You have been teleported to your instance of Temple of Veeshan!");
    }
  }
}
