sub EVENT_SPAWN {
     # Send a signal to NPC 1352 with signal ID 30 after a 2-second delay
    quest::signalwith(1352, 30, 2);
    quest::setnexthpevent(75);  # Start first phase at 75% health
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::modifynpcstat("mana_regen", 200);  # Boost mana regen to enhance spellcasting frequency
        quest::castspell(36891, $userid);  # Cast "Time Ripple" (ID 36891)
        quest::setnexthpevent(50);  # Next phase at 50% health
    } elsif ($hpevent == 50) {
        quest::modifynpcstat("AC", 300);  # Increase AC as defense
        quest::castspell(36892, $userid);  # Cast "Time Shock" (ID 36892)
        quest::spawn2(1393, 0, 0, $x + 10, $y + 10, $z, $h);  # Summon a magical helper NPC to assist her
        quest::setnexthpevent(25);  # Next phase at 25%
    } elsif ($hpevent == 25) {
        quest::modifynpcstat("max_hit", 900);  # Increase spell damage output
        quest::castspell(36893, 0);  # Cast "GREAT SCOTT!" (ID 36893) - the final blast
        quest::setnexthpevent(10);  # Final phase at 10%
    } elsif ($hpevent == 10) {
        quest::modifynpcstat("attack_delay", 8);  # Cast faster for final phase
        quest::spawn2(1393, 0, 0, $x - 10, $y - 10, $z, $h);  # Summon another magical helper NPC for the final phase
    }
}
