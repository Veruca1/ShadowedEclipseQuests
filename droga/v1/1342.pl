# High Priest of Droga (ID: 1342) script

sub EVENT_SPAWN {
    # Shout when High Priest of Droga spawns
    quest::shout("The ceremony must not be interrupted! Droga shall rise and lead our armies to victory!!");
}

sub EVENT_DEATH_COMPLETE {
    # Signal NPC 1343 with a signal value of 2
    quest::signalwith(1343, 2, 2);  # Send signal value of 2
    
    # Shout message on death
    quest::shout("The ceremony... Droga shall wither without my guidance... but may he yet crush... our enemies..");
}
