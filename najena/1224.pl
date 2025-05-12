sub EVENT_SPAWN {
    # Initialize the first HP event
    quest::setnexthpevent(85);  # Set HP event for 85% health
}

sub EVENT_AGGRO {
    # Shout when engaged in combat
    quest::shout("Ahhhhh, fresh meat for my children!");
}

sub EVENT_HP {
    my $current_hp = $npc->GetHP();
    my $max_hp = $npc->GetMaxHP();
    my $hp_percentage = ($current_hp / $max_hp) * 100;

    if ($hp_percentage <= 85 && $hpevent == 85) {
        # At 85% health
        quest::shout("Devour them my children!");
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h); # Spawn 3 NPC ID 1217
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::setnexthpevent(55);  # Set next HP event for 55%
    }
    elsif ($hp_percentage <= 55 && $hpevent == 55) {
        # At 55% health
        quest::shout("Devour them my children!");
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h); # Spawn 4 NPC ID 1217
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::setnexthpevent(25);  # Set next HP event for 25%
    }
    elsif ($hp_percentage <= 25 && $hpevent == 25) {
        # At 25% health
        quest::shout("Devour them my children!");
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h); # Spawn 6 NPC ID 1217
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1217, 0, 0, $x, $y, $z, $h);
        quest::setnexthpevent(0);  # End the HP event
    }
}

sub EVENT_DEATH_COMPLETE {
    # Shout on death
    quest::shout("The powers of the hate plane will be your undoing!");
}
