sub EVENT_ITEM_CLICK {
  # Check if the correct item (839) is clicked
  if ($itemid == 839) {
    # Define the destination coordinates for Frozenshadow (Zone 111)
    my $dest_x = -476.03;
    my $dest_y = 176.90;
    my $dest_z = 1.25;
    my $dest_heading = 12.50;  # Heading should be a float

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
          $member->CastToClient()->MovePCInstance(111, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
        }
      }
      # Notify the group leader that the group has been teleported to their instance of Tower of Frozenshadow
      $client->Message(4, "Your group has been teleported to your instance of Tower of Frozenshadow!");
    } else {
      # If no group, teleport the player only to their instance
      my $instance_id = $client->GetInstanceID();
      $client->MovePCInstance(111, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
      $client->Message(4, "You have been teleported to your instance of Tower of Frozenshadow!");
    }
  }
}
