sub EVENT_DEATH_COMPLETE {
    # Check if NPC 1799 is not already spawned
    if (!quest::isnpcspawned(1799)) {
        # Generate a random number between 0 and 1
        my $chance = int(rand(100));  # Random number between 0 and 99

        # 25% chance for NPC 1799 to spawn
        if ($chance < 25) {
            # Spawn NPC 1799 at the specified location
            quest::spawn2(1799, 0, 0, 283.33, 1520.50, 5.64, 243.50);
            #plugin::Whisper("A strange presence fills the air as a dragon construct rises from the earth!.");
        }
    }
}