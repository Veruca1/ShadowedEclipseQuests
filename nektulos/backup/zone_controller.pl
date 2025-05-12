# Variable to track the signal count
my $signal_count = 0;

# Variable to store the required number of signals (random between 5 and 12)
my $required_signals = 0;

# Variable to track if the druid cycle has ended
my $druid_cycle_ended = 0;

# Define spawn locations for the 4 NPCs (1715)
my @spawn_locs = (
  [778.26, 88.35, 9.79, 472.75],  # Location 1
  [816.99, 15.88, 9.79, 427.25],  # Location 2
  [877.28, 26.72, 9.79, 424.50],  # Location 3
  [869.58, 67.80, 9.79, 482.50],  # Location 4
);

# Track if signals 3, 4, 5, and 6 have been received
my %signals_received = (
  3 => 0,
  4 => 0,
  5 => 0,
  6 => 0,
);

# Variable to track the current NPC in the sequence (starting with 1716)
my $current_npc = 1716;

sub EVENT_SPAWN {
  # Generate a random number between 5 and 12 for the required signals
  $required_signals = int(rand(8)) + 5;  # Random number between 5 and 12
  quest::spawn2(1698, 0, 0, -775.11, 1753.95, 7.99, 420);
  quest::spawn2(1699, 0, 0, -954.84, 1859.68, 59.33, 202);
}

sub EVENT_SIGNAL {
  # Skip all further actions if the druid cycle has ended
  return if $druid_cycle_ended;

 # Handle signal 1 (spawning NPC 1706 after 3 signals)
  if ($signal == 1) {
    $signal_count_1++;

    if ($signal_count_1 == 3) {
      quest::spawn2(1706, 0, 0, -60.10, 857.81, 15.22, 7.50);
      $signal_count_1 = 0;  # Reset count after spawning
    }
  }

  if ($signal == 2) {
    # Increment the signal count when signal 2 is received
    $signal_count++;

    # If 4 NPCs (1715) have died, respawn them at the defined locations
    if ($signal_count % 4 == 0) {
      foreach my $loc (@spawn_locs) {
        quest::spawn2(1715, 0, 0, @$loc);  # Respawn NPC 1715 at each location
      }
    }

    # Once the total signal count reaches the required number, depop all 1715s and spawn one of 1716-1719 in sequence
    if ($signal_count == $required_signals) {
      quest::depopall(1715);  # Depop all NPCs with ID 1715

      # Spawn the current NPC in the sequence (1716, 1717, 1718, 1719)
      quest::spawn2($current_npc, 0, 0, 823.46, 62.08, 50.57, 503.25);

      # Move to the next NPC in the sequence, wrapping around if necessary
      $current_npc++;
      if ($current_npc > 1719) {
        $current_npc = 1716;  # Reset back to 1716 after 1719
      }

      # Reset the signal count and generate a new random number for required signals
      $signal_count = 0;
      $required_signals = int(rand(8)) + 5;  # Random number between 5 and 12
    }
  }

  # Track signals 3, 4, 5, and 6 for the final event
  if ($signal >= 3 && $signal <= 6) {
    $signals_received{$signal} = 1;  # Mark the signal as received

    # Check if all signals 3, 4, 5, and 6 have been received
    if ($signals_received{3} && $signals_received{4} && $signals_received{5} && $signals_received{6}) {
      # Set the flag to indicate the druid cycle has ended
      $druid_cycle_ended = 1;

      # Depop all 1715 NPCs to stop the druid cycle permanently
      quest::depopall(1715);

      # Send a green message to all clients in the zone
      my @clients = $entity_list->GetClientList();
      foreach my $client (@clients) {
        if ($client) {
          $client->Message(14, "As the druid beasts fall silent, the air becomes heavy, and a powerful presence emerges from the druid ring stones!");
        }
      }

      # Spawn NPC 1720 at the specified location
      quest::spawn2(1720, 0, 0, 832.01, 83.58, 12.62, 4.25);
    }
  }

  # Handle signal 99 to restart the druid cycle, only if the cycle has not ended
  if ($signal == 99 && !$druid_cycle_ended) {
    # Send a green message to all clients in the zone
    my @clients = $entity_list->GetClientList();
    foreach my $client (@clients) {
      if ($client) {
        $client->Message(14, "As the Ancient Druid Beast collapses, you hear a hum coming from the druid ring stones, as if it's about to start all over again. Be ready!");
      }
    }

    # Set a 15-second timer to respawn the 1715 NPCs
    quest::settimer("restart_druid_cycle", 15);
  }
}

sub EVENT_TIMER {
  if ($timer eq "restart_druid_cycle") {
    # Respawn the 4 NPCs (1715) at their locations if the cycle has not ended
    if (!$druid_cycle_ended) {
      foreach my $loc (@spawn_locs) {
        quest::spawn2(1715, 0, 0, @$loc);  # Respawn NPC 1715 at each location
      }

      # Reset the signal count and generate a new random number for required signals
      $signal_count = 0;
      $required_signals = int(rand(8)) + 5;  # Random number between 5 and 12
    }

    # Stop the timer
    quest::stoptimer("restart_druid_cycle");
  }
}
