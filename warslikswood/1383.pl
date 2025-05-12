sub EVENT_SPAWN {
    quest::settimer("explode", 5); # Set a 5-second timer before the missile explodes
}

sub EVENT_TIMER {
    if ($timer eq "explode") {
        quest::shout("Missile of Ik explodes with destructive force!");
        $npc->CastSpell(36868, 0); # Cast AoE spell (ID 36868) for the explosion
        quest::depop(); # Despawn the missile after the explosion
    }
}
