sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Entered combat
        quest::shout("I'm gonna serve exactly what you are!");  # Shouts when entering combat
        quest::settimer("cast_spell", 120);  # Set a timer for every 120 seconds (2 minutes)

        my $target = $npc->GetHateTop();  # Get the top hate target
        if ($target) {
            # Array of random shout options
            my @shouts = (
                "Is anyone else hot?", 
                "Whew, it's hot here!", 
                "Woo, you coming home with me?"
            );
            
            my $random_shout = $shouts[int(rand(scalar(@shouts)))];  # Pick a random shout
            quest::shout($random_shout);  # Shout the random phrase
            $npc->CastSpell(36900, $target->GetID());  # Cast spell 36900 on the top hate target
        }
    }
    elsif ($combat_state == 0) {  # Exited combat
        quest::stoptimer("cast_spell");  # Stop the timer when the NPC exits combat
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell") {
        my $target = $npc->GetHateTop();  # Get the top hate target
        if ($target) {
            # Array of random shout options
            my @shouts = (
                "Is anyone else hot?", 
                "Whew, it's hot here!", 
                "Woo, you coming home with me?"
            );
            
            my $random_shout = $shouts[int(rand(scalar(@shouts)))];  # Pick a random shout
            quest::shout($random_shout);  # Shout the random phrase
            $npc->CastSpell(36900, $target->GetID());  # Cast spell 36900 on the top hate target
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("I'll call the cab");  # Custom death shout
    quest::stoptimer("cast_spell");  # Stop the timer when the NPC dies
}
