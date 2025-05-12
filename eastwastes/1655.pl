sub EVENT_SPAWN {
    # Announce server-wide message upon spawn
    quest::we(14, "Frostbane has sent me to destroy you all! You are lucky I'm not him. For the Coven!!!");

    # Set a timer to periodically check for buffs
    quest::settimer("check_buffs", 10); # Check every 10 seconds
    
    # Start a depop timer
    quest::settimer("depop_check", 1800); # 1800 seconds = 30 minutes
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Only cast the buff if the NPC is not already buffed and not in combat
        if (!$npc->FindBuff(27376) && !$npc->IsEngaged()) {
            $npc->CastSpell(27376, $npc->GetID());
        }
        # Restart the timer
        quest::settimer("check_buffs", 10);
    }
    elsif ($timer eq "spawn_adds") {
        # Get NPC's current location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn 10 adds in a circle around the NPC
        for my $i (0..9) {
            my $angle = $i * (2 * 3.14159 / 10); # Divide 360 degrees into 10 parts
            my $add_x = $x + 10 * cos($angle);
            my $add_y = $y + 10 * sin($angle);
            quest::spawn2(1647, 0, 0, $add_x, $add_y, $z, $h);
        }
    }
    elsif ($timer eq "depop_check") {
        # Depop the NPC if it is not in combat
        if (!$npc->IsEngaged()) {
            quest::signalwith(1407, 1);
	    quest::depop();	    
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat
        quest::settimer("spawn_adds", 25); # Spawn adds every 25 seconds
        
        # Reset the depop timer when combat starts
        quest::settimer("depop_check", 1800);
    }
    elsif ($combat_state == 0) {
        # NPC has left combat
        quest::stoptimer("spawn_adds");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Signal NPC ID 1407 (or any other handler) that this NPC has died
    quest::signalwith(1407, 1);
}
