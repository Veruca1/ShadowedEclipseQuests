# Global variable to track received signals
my %received_signals;

sub EVENT_SPAWN {
    # Placeholder for any other logic in EVENT_SPAWN without spawning mechanics
}

sub EVENT_SIGNAL {
    # Check if the signal is between 1 and 6
    if ($signal >= 1 && $signal <= 6) {
        # Mark the signal as received
        $received_signals{$signal} = 1;

        # Check if all 6 signals have been received
        if (scalar keys %received_signals == 6) {
            # Check if NPC 1730 is not already spawned
            if (!quest::isnpcspawned(1730)) {
                # Spawn NPC 1730 at the specified location
                quest::spawn2(1730, 0, 0, -55.06, 4.05, -132.32, 1.25);
            }

            # Reset the received signals for future use (optional)
            %received_signals = ();
        }
    }
    # Check if the signal is 7
    elsif ($signal == 7) {
        # Check if NPC 1731 is not already spawned
        if (!quest::isnpcspawned(1731)) {
            # Spawn NPC 1731 at the specified location
            quest::spawn2(1731, 0, 0, -56.53, -75.04, -97.32, 3.00);
        }
    }
}
