sub EVENT_ITEM_CLICK {
  # Ensure the item ID is correct
  return unless $itemid == 839;

  # Only proceed if the player is in zone 111 (Frozenshadow)
  return unless $client->GetZoneID() == 111;

  # Define destination coordinates
  my $dest_x = -476.03;
  my $dest_y = 176.90;
  my $dest_z = 1.25;
  my $dest_heading = 12.50;

  # Get the player's group
  my $group = $client->GetGroup();

  # Get instance ID
  my $instance_id = $client->GetInstanceID();

  if ($group) {
    # Loop through group members
    for (my $i = 0; $i < $group->GroupCount(); $i++) {
      my $member = $group->GetMember($i);
      if ($member && $member->IsClient()) {
        $member->CastToClient()->MovePCInstance(111, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
      }
    }
    $client->Message(4, "Your group has been teleported to your instance of Tower of Frozenshadow!");
  } else {
    # Solo teleport
    $client->MovePCInstance(111, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
    $client->Message(4, "You have been teleported to your instance of Tower of Frozenshadow!");
  }
}