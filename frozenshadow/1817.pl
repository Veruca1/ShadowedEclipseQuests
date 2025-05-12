# Declaring spawn locations at the top of the script
my @locations = (
    [-394, 832, 5.1, 511],
    [-414, 865, 5.1, 250],
    [-454, 833, 5.1, 511],
    [-474, 866, 5.1, 250],
    [-276, 863, 4.35, 250],
    [-246, 835, 5.1, 511],
    [-215, 866, 3.85, 250],
    [-183, 905, 3.85, 130],
    [-234, 875, 3.85, 250],
    [-253, 875, 3.85, 250],
    [-500.13, 916, 5.1, 360],
    [-499, 965, 5.1, 360],
    [-494, 973, 5.1, 360],
    [-455, 1040, 5.1, 360],
    [-454, 1027, 5.1, 360]
);

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # Check if the key has been shown before
        my $key_shown = quest::get_data("key_shown");

        if (!$key_shown) {
            quest::whisper("Blimey, you gave me a bit of a fright! Look, I dunno who you are, but if you've made it this far, you must know what you're doing. Still, I can’t just go handing out advice to any random person. Show me the key that got you up here, and then maybe we’ll talk.");
            quest::set_data("key_shown", 1);  # Mark that the key has been shown
        }
        else {
            # After showing key, just mention cooldown or READY option
            my $last_used = quest::get_data("ready_cooldown");
            my $current_time = time();

            if ($last_used && $current_time - $last_used < 600) {
                my $time_left = 600 - ($current_time - $last_used);  # Calculate remaining time
                my $minutes_left = int($time_left / 60);  # Calculate minutes
                my $seconds_left = $time_left % 60;  # Calculate seconds
                quest::whisper("Hold your horses! We just did this—let's not push our luck. Give it another $minutes_left minutes and $seconds_left seconds.");
            } else {
                # Correctly using quest::saylink for READY
                my $ready_link = quest::saylink("READY", 1);  # Use saylink for READY
                quest::whisper("Alright then, no turning back now! Keep your wand—er, I mean, weapon—ready. This is gonna get nasty. Just say $ready_link when you're ready.");
            }
        }
    }
    elsif ($text =~ /READY/i) {
        my $last_used = quest::get_data("ready_cooldown");
        my $current_time = time();

        if ($last_used && $current_time - $last_used < 600) {  # 600 seconds = 10 minutes
            my $time_left = 600 - ($current_time - $last_used);  # Calculate remaining time
            my $minutes_left = int($time_left / 60);  # Calculate minutes
            my $seconds_left = $time_left % 60;  # Calculate seconds
            quest::whisper("Hold your horses! We just did this—let's not push our luck. Give it another $minutes_left minutes and $seconds_left seconds.");
            return;
        }

        quest::set_data("ready_cooldown", $current_time);  # Set cooldown timestamp

        quest::whisper("Alright then, no turning back now! Keep your wand—er, I mean, weapon—ready. This is gonna get nasty.");

        # Depop any existing NPCs before spawning new ones
        quest::depopall(1814);
        quest::depopall(1815);

        # Wait 2 seconds before spawning new ones
        quest::settimer("spawn_npcs", 2);
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 20037 => 1)) {  # Bone Finger Key
        # Correctly using quest::saylink for READY here too
        my $ready_link = quest::saylink("READY", 1);  # Use saylink for READY
        quest::whisper("Right then, you’re legit. Listen, this place gives me the creeps, and I reckon you’re after a way forward. Here’s the deal—those ghastly creatures in the alcoves, yeah? They’re holding onto these weird, floaty memories. You’ll need to nick ten of ‘em. Once you’ve got ‘em all, you’ll need to shove ‘em into this Pensieve—nicked straight out of some dark wizard’s collection, I’d wager. Problem is, it’s in the claws of some nasty brute in that room up ahead on the right. And, er… you’re gonna have to figure out how to summon it yourself. Good luck with that.");

        quest::summonitem(20037);  # Return the Bone Finger Key
        quest::whisper("When you're ready to face what's ahead, just say $ready_link.");
    } 
    else {
        quest::whisper("What’s this? No offense, but I’ve got no use for it. Here, take it back.");
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npcs") {
        quest::stoptimer("spawn_npcs");
        spawn_random_npcs();
    }
}

sub spawn_random_npcs {
    # Loop through all the locations and spawn one NPC at each
    for my $loc (@locations) {
        # Randomly choose between NPC 1814 and NPC 1815
        my $npc_to_spawn = (rand() < 0.5) ? 1814 : 1815;
        
        # Spawn the selected NPC at the location
        quest::spawn2($npc_to_spawn, 0, 0, @$loc);
    }
}