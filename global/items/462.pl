sub EVENT_ITEM_CLICK {
  # Check if the correct item (462) is clicked
  if ($itemid == 462) {
    # Define the destination coordinates for Veeshan's Peak (Zone 108)
    my $dest_x = 180.38;
    my $dest_y = 238.75;
    my $dest_z = 362.83;
    my $dest_heading = 0.0;  # Heading should be a float

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
          $member->CastToClient()->MovePCInstance(108, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
        }
      }
      # Notify the group leader that the group has been teleported to their instance of Veeshan's Peak
      $client->Message(4, "Your group has been teleported to your instance of Veeshan's Peak!");
    } else {
      # If no group, teleport the player only to their instance
      my $instance_id = $client->GetInstanceID();
      $client->MovePCInstance(108, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
      $client->Message(4, "You have been teleported to your instance of Veeshan's Peak!");
    }
  }
}
