# File-scoped flags
my $event_75_triggered = 0;
my $event_50_triggered = 0;
my $event_25_triggered = 0;

sub EVENT_SPAWN {
    quest::settimer("summon_pet", 1);
    reset_event_flags();
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1934, 0, 0, $x, $y, $z, $h);
        quest::stoptimer("summon_pet");
    }
    elsif ($timer eq "spectral_shroud") {
        quest::modifynpcstat("AC", 25000);
        quest::modifynpcstat("regen", 900);
        quest::shout("The spectral shroud fades...");
        quest::stoptimer("spectral_shroud");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(75);
    } else {
        reset_event_flags();  # Player wiped or boss leashed
    }
}

sub EVENT_HP {
    if ($hpevent == 75 && !$event_75_triggered) {
        $event_75_triggered = 1;
        quest::setnexthpevent(50);
        summon_minions();
        quest::shout("Skeletal minions, arise and protect your master!");
    }
    elsif ($hpevent == 50 && !$event_50_triggered) {
        $event_50_triggered = 1;
        quest::setnexthpevent(25);
        summon_minions();
        quest::shout("You cannot defeat my undead horde!");
    }
    elsif ($hpevent == 25 && !$event_25_triggered) {
        $event_25_triggered = 1;
        summon_minions();
        quest::shout("My power grows as my life fades!");
    }
}

sub summon_minions {
    my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(1934, 0, 0, $x, $y, $z, $h);  # Replace with correct ID if needed
}

sub reset_event_flags {
    $event_75_triggered = 0;
    $event_50_triggered = 0;
    $event_25_triggered = 0;
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::modifynpcstat("AC", 30000);
        quest::modifynpcstat("regen", 2000);
        quest::shout("The power of the spectres shield me!");
        quest::settimer("spectral_shroud", 10);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("You fools! You will never make it to the Lunaar Oracle, nevermind The Coven...");
}