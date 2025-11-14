# ===========================================================
# #Assistant_Kelrig.pl — Plane of Innovation (poinnovation)
# Shadowed Eclipse Quest: "Endurance Testing"
# -----------------------------------------------------------
# - Handles the endurance test encounter after Researcher Kaeon.
# - Provides clickable saylinks for "continue" and "quit".
# - On "continue", spawns the Endurance Trigger (206081) only.
# - On "quit", moves player back to safe coordinates in same instance.
# ===========================================================

sub EVENT_SAY {
    my $saylink_quit     = quest::saylink("quit", 1);
    my $saylink_continue = quest::saylink("continue", 1);

    if ($text =~ /hail/i) {
        quest::whisper("Interesting, your abilities have shown you to be sufficient. "
                     . "We would like to continue testing. "
                     . "Are you ready to [$saylink_continue] or would you like to [$saylink_quit] here?");
    }

    elsif ($text =~ /quit/i) {
        quest::whisper("We shall process the data that you have afforded us. Goodbye.");

        # --- Move player safely within their current instance ---
        my $instance_id = $client->GetInstanceID();
        if ($instance_id > 0) {
            quest::MovePCInstance("poinnovation", $instance_id, 301.42, 501.88, -50.01, 310.50);
        } else {
            quest::whisper("Instance could not be verified — teleporting failed.");
            quest::debug("Assistant Kelrig: Failed MovePCInstance, instance_id = 0.");
        }

        # --- Clean up ---
        quest::depop(206081);                  # Remove any existing trigger
        quest::spawn_condition($zonesn, 1, 0); # Reset spawn condition
        quest::depop();                        # Depop self
    }

    elsif ($text =~ /continue/i) {
        quest::whisper("Very well. I’ll return when you are finished.");

        # --- Spawn / Reset the Endurance Trigger Controller ---
        quest::depop(206081);
        quest::spawn2(206081, 0, 0, -206.45, -758.42, 4.14, 382.25);
        quest::debug("Assistant Kelrig: Spawned Endurance Trigger (206081) at (-206.45, -758.42, 4.14, 382.25).");

        # --- Depart while test runs ---
        quest::depop();
    }
}

sub EVENT_SIGNAL {
    quest::settimer("reset", 10);   # Wait 10 seconds before prompting again
}

sub EVENT_TIMER {
    if ($timer eq "reset") {
        my $saylink_quit = quest::saylink("quit", 1);
        quest::whisper("Excellent. This data will be of great use to us. "
                     . "Thank you for your time. Are you ready to [$saylink_quit]?");
        quest::stoptimer("reset");
    }
}