sub EVENT_SPAWN {
    # Spawns NPC with ID 1427 at specified coordinates upon spawn of this NPC
    quest::spawn2(1427, 0, 0, -42.20, 1308.83, 446.05, 453);
    quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Combat started
        quest::settimer("cast_spell", 60); # Start timer for casting spell
    } elsif ($combat_state == 0) { # Combat ended
        quest::stoptimer("cast_spell"); # Stop timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell") {
        if ($npc->IsEngaged()) { # Ensure the NPC is still in combat
            my $target = $npc->GetHateTop(); # Get the primary aggro target
            if ($target) {
                quest::castspell(36959, $target->GetID()); # Cast spell on the target
            }
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 80) {
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::setnexthpevent(60);
    } elsif ($hpevent == 60) {
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::setnexthpevent(20);
    } elsif ($hpevent == 20) {
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
        quest::spawn2(1586, 0, 0, $x, $y, $z, $h); # NPC: 
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1427, 37, 0);
}
