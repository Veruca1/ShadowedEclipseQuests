sub EVENT_CLICKDOOR {
    if (($doorid == 1 || $doorid == 2 || $doorid == 3 || $doorid == 232) && !defined $qglobals{dragon_not_ready}) {
        # Activate the corresponding globe
        if ($doorid == 1) { quest::setglobal("door_one", 1, 3, "S300"); }
        if ($doorid == 2) { quest::setglobal("door_two", 1, 3, "S300"); }
        if ($doorid == 3) { quest::setglobal("door_three", 1, 3, "S300"); }
        if ($doorid == 232) { quest::setglobal("door_four", 1, 3, "S300"); }

        $client->Message(4, "The globe begins to spin faster and faster...");

        # Check if all globes are activated
        if (defined $qglobals{door_one} && defined $qglobals{door_two} &&
            defined $qglobals{door_three} && defined $qglobals{door_four}) {

            # Spawn the NPC
            quest::spawn2(123456, 0, 0, 100, 200, 50, 0); # Replace with actual NPC ID and coordinates

            # Clear the globe globals
            quest::delglobal("door_one");
            quest::delglobal("door_two");
            quest::delglobal("door_three");
            quest::delglobal("door_four");

            # Set the cooldown timer
            quest::setglobal("dragon_not_ready", 1, 3, "M10"); # Cooldown for 10 minutes
        }
    } 
    elsif (defined $qglobals{dragon_not_ready}) {
        $client->Message(4, "The globe does not seem to do anything.");
    }
}
