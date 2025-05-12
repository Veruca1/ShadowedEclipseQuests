sub EVENT_SPAWN {
    # Set a timer to check buffs and cast spell 27376 when needed
    quest::settimer("check_buffs", 1);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast spell 27376 on the NPC itself if it doesn't already have it
        $npc->CastSpell(27376, $npc->GetID()) if !$npc->FindBuff(27376);
    }
}