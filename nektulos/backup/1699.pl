sub EVENT_SPAWN {
  # Set the proximity range with a 50-unit radius in X, Y, and Z directions
  quest::set_proximity_range(50, 50, 50);
}

sub EVENT_ENTER {
  # Send a message to the player when they enter the proximity area
  $client->Message(14, "You see a mysterious presence just ahead.");
}
