sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast the spell only if the buff is not already present
        $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
    }
}
