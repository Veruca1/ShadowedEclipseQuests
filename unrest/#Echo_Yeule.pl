sub EVENT_SPAWN {
    quest::settimer("summon_pet", 1);
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        # Summon the pet directly
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2(63026, 0, 0, $x, $y, $z, $h); # Summons minion with NPC ID 63026
        quest::stoptimer("summon_pet");
    }
    elsif ($timer eq "spectral_shroud") {
        quest::modifynpcstat("AC", 100); # Resets AC to normal
        quest::modifynpcstat("regen", 10); # Resets regen to normal
        quest::shout("The spectral shroud fades...");
        quest::stoptimer("spectral_shroud");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(75);
    }
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::setnexthpevent(50);
        summon_minions();
        quest::shout("Skeletal minions, arise and protect your master!");
    }
    elsif ($hpevent == 50) {
        quest::setnexthpevent(25);
        summon_minions();
        quest::shout("You cannot defeat my undead horde!");
    }
    elsif ($hpevent == 25) {
        summon_minions();
        quest::shout("My power grows as my life fades!");
    }
}

sub summon_minions {
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    quest::spawn2(63026, 0, 0, $x, $y, $z, $h); # Summons a minion with NPC ID 63026
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::modifynpcstat("AC", 200); # Increases AC temporarily
        quest::modifynpcstat("regen", 50); # Increases HP regen temporarily
        quest::shout("The power of the spectres shield me!");
        quest::settimer("spectral_shroud", 10); # Adjust duration as needed
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("You fools! You will never make it to Abyssal Dreadlord Xyron, nevermind Chronomancer Zarrin...");
}