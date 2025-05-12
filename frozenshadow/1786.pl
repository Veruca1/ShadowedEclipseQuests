sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
    quest::settimer("depop_timer", 40);  # Set the depop timer for 30 seconds
    $npc->Shout("Ah ha ha HAAA! Round two, darlings! Let’s see if you scream louder this time!...");
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast the spell only if the buff is not already present
        $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
    }
    
    if ($timer eq "depop_timer") {
        quest::stoptimer("depop_timer");
        # Bellatrix Lestrange's manic, unsettling laughter, in her style
        quest::depop();  # Depop after 30 seconds
	quest::spawn2(1787, 0, 0, $x, $y, $z, $h);
    }
}
