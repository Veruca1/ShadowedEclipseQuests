sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-snape_event";  # The flag for this NPC
    my $cooldown_key = "$char_id-snape_event_cooldown";  # A unique cooldown key
    my $cooldown_time = 240;  # 4-minute cooldown in seconds (240 seconds)

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("Oh, it's you! You're back. I hope you've had time to reflect on everything that's happened. Don't worry, I know how much it means to you.");
                
                # Spawn NPC 1826 at the specified location after the hail
                quest::spawn2(1826, 0, 0, -467.30, 253.77, 8.81, 316.75);
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait just a little longer. The memory of Dumbledore is precious, and we need to give it time. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            plugin::Whisper("You must complete the hand-in first. Dumbledore would want us to be patient, wouldn't he?");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID

    # Memory of Dumbledore Logic
    my $dumbledore_item = 740;             # Item ID for Memory of Dumbledore
    my $snape_flag = "$char_id-snape_event";  # Flag for the Dumbledore event
    my $cooldown_key = "$char_id-snape_event_cooldown";  # Cooldown flag

    if (plugin::check_handin(\%itemcount, $dumbledore_item => 1)) {
        if (!quest::get_data($snape_flag)) {
            quest::set_data($snape_flag, 1);

            plugin::Whisper("You've done it! You really found Dumbledore's memory. I can't believe it. You know, he was always so much more than we ever knew. Well done, truly.");

            # Spawn NPC 1826 at the specified location
            quest::spawn2(1826, 0, 0, -467.30, 253.77, 8.81, 316.75);

            # Set a cooldown timer for 4 minutes (240 seconds)
            quest::set_data($cooldown_key, time());
        } else {
            plugin::Whisper("You've already uncovered Dumbledore's memory. There's nothing more to be done here.");
        }
        return;
    }

    # Felix Fortuna Logic
    my $felix_item = 767;                 # Item ID for Felix Fortuna
    my $felix_reward = 768;               # Item ID for Felix Fortuna reward
    my $felix_flag = "$char_id-felix_fortuna2";  # Flag for Felix Fortuna (updated)

    if (plugin::check_handin(\%itemcount, $felix_item => 1)) {
        if (quest::get_data($felix_flag)) {
            plugin::Whisper("You have already obtained the power of Felix Fortuna. No need to try again.");
        } else {
            quest::summonitem($felix_reward);  # Give item 768
            plugin::Whisper("Well done! The power of Felix Fortuna is now yours.");
        }
        return;
    }

    if (plugin::check_handin(\%itemcount, $felix_reward => 1)) {
        if (quest::get_data($felix_flag)) {
            plugin::Whisper("You have already been flagged and cannot complete this step again.");
        } else {
            quest::set_data($felix_flag, 1);  # Flag the player
            plugin::Whisper("You have been marked as one who has wielded Felix Fortuna. Best of luck!");
        }
        return;
    }

    # New Felix Fortuna of the Arcane Draft III Logic
    my $arcane_draft = 784;  # Item ID for Felix Fortuna of the Arcane Draft III
    my $arcane_reward = 785; # Item ID for Felix Fortuna of the Arcane III
    my $arcane_flag = "$char_id-arcane_felix_flag"; # Flag for Arcane Felix Fortuna

    if (plugin::check_handin(\%itemcount, $arcane_draft => 1)) {
        if (quest::get_data($arcane_flag)) {
            plugin::Whisper("You have already received Felix Fortuna of the Arcane III and cannot do this again.");
        } else {
            quest::summonitem($arcane_reward);  # Give item 785
            quest::set_data($arcane_flag, 1);  # Flag the player to prevent redoing
            plugin::Whisper("You have received Felix Fortuna of the Arcane III. This power is now yours.");
        }
        return;
    }

    # Return items if none matched
    plugin::return_items(\%itemcount);
    plugin::Whisper("I have no use for this, $name.");
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1824") {
        # Spawn NPC 1824 after 30 seconds
        quest::spawn2(1824, 0, 0, -399.73, 452.69, 26.62, 261.75);
        # Stop the timer after spawning NPC
        quest::stoptimer("spawn_npc_1824");
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Signal 1: Start a timer to spawn NPC 1824 after 30 seconds
        quest::settimer("spawn_npc_1824", 30);
    }
    elsif ($signal == 2) {
        # Signal 2: Depop NPCs 1828 and 1829
        quest::depop(1828);
        quest::depop(1829);
    }
}
