sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged
        my $target = $npc->GetTarget();
        if ($target) {
            $npc->CastSpell(40773, $target->GetID());  # Spell: Breath of the Shissar II
        }
        quest::depop_withtimer();
    }
}