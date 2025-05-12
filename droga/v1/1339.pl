sub EVENT_SPAWN {
    quest::settimer("GolemExplode", 40);  # Set the timer for the explosion
    #quest::shout("Golem spawn: Timer for GolemExplode started.");
}

sub EVENT_TIMER {
    if ($timer eq "GolemExplode") {
        quest::shout("The golem explodes in a burst of deadly energy!");
        $npc->CastSpell(36868, $npc->GetID());  # Golem's Delight Explosion
        $npc->Depop(1);  # Depop the golem
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("GolemExplode");  # Stop the explosion timer if the golem dies
    #quest::shout("Golem death: Timer for GolemExplode stopped.");
    quest::signal(1340, 1);  # Signal Droga (ID 1340) to stop any remaining explosion timers
}
