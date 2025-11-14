# ===========================================================
# #Researcher_Kaeon.pl — Plane of Innovation (poinnovation)
# Shadowed Eclipse Quest: "Endurance Testing"
# -----------------------------------------------------------
# - Starts the Endurance Testing quest sequence.
# - Spawns #Assistant_Kelrig at a fixed location in the instance.
# - Moves the player to their own instance testing bay.
# - Includes clickable saylinks for "I will comply" and "ready".
# ===========================================================

sub EVENT_SPAWN {
    # Disable test-related spawn conditions on spawn (optional)
    #quest::spawn_condition($zonesn, 1, 0);
    #quest::spawn_condition($zonesn, 2, 0);
}

sub EVENT_SAY {
    my $saylink_comply = quest::saylink("I will comply", 1);
    my $saylink_ready  = quest::saylink("ready", 1);

    if ($text =~ /hail/i) {
        quest::whisper("Salutations. We have been monitoring your performance in the scrap yards. "
                     . "Your ability seems to rival your physical capabilities. "
                     . "We would like to test your endurance and mental abilities further. "
                     . "Would you comply to endurance testing? "
                     . "If so, please say [$saylink_comply].");
    }
    elsif ($text =~ /I will comply/i) {
        quest::whisper("Excellent. We would like to test a maximum of six at one time. "
                     . "Are you [$saylink_ready] to begin testing?");
    }
elsif ($text =~ /ready/i) {
    quest::whisper("Excellent. I will now send you down to the testing bay. "
                 . "The endurance trigger has been activated. "
                 . "Assistant Kelrig will appear once testing commences.");

    # --- Spawn the Endurance Trigger Controller ---
    quest::depop(206081);
    quest::spawn2(206081, 0, 0, -206.45, -758.42, 4.14, 382.25);

# --- Move player within their current instance ---
my $instance_id = $client->GetInstanceID();
if ($instance_id > 0) {
    quest::MovePCInstance("poinnovation", $instance_id, -289, -760, 2, 0);
} else {
    quest::whisper("Instance could not be verified — teleporting failed.");
    quest::debug("Researcher Kaeon: Failed MovePCInstance, instance_id = 0 for client.");
}

    # --- Manage quest global flag ---
    quest::delglobal("poiend");
    quest::setglobal("poiend", 1, 3, "F");

    quest::debug("Researcher Kaeon: Spawned Endurance Trigger (206081) at (-206.45, -758.42, 4.14, 382.25) "
               . "and moved player to instance (-289, -760, 2, 0).");
}
}

sub EVENT_ITEM {
    plugin::return_items(\%itemcount);
}