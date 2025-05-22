sub EVENT_SPAWN { 
    quest::settimer("depop_check", 5);  # Check every 5 seconds
    $no_combat_ticks = 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Reset timer when leaving combat
        $no_combat_ticks = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        if ($npc->GetCombatState() == 0) {
            $no_combat_ticks += 5;
            if ($no_combat_ticks >= 30) {
                quest::depop();
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    quest::setglobal("explosion_x", $x, 5, "F");
    quest::setglobal("explosion_y", $y, 5, "F");
    quest::setglobal("explosion_z", $z, 5, "F");

    quest::signalwith(1461, 10);
}