sub EVENT_SPAWN {
    if (defined $npc) {
        $npc->SetInvul(1);
        quest::settimer("check_debuff", 5);  # Check every 5 seconds
    }
}

sub EVENT_CAST_ON {
    my $debuff_id = 40732;

    # $spell_id might be undefined sometimes
    return unless defined $spell_id;
    return unless $spell_id == $debuff_id;

    # Defensive check for $npc object
    return unless defined $npc;

    my $npc_id = $npc->GetID();
    return unless defined $npc_id;

    my $had_debuff = quest::get_data("wmu_has_debuff_$npc_id") || 0;

    quest::set_data("wmu_has_debuff_$npc_id", 1);

    if (!$had_debuff) {
        quest::signalwith(1352, 1);  # Initial application
    } else {
        quest::signalwith(1352, 3);  # Reapplication after fade
    }

    $npc->SetInvul(0);
    quest::settimer("reenable_invul", 2);
}

sub EVENT_TIMER {
    return unless defined $npc;
    
    my $npc_id = $npc->GetID();
    
    # Check if the debuff (ID 40732) is still on the NPC
    if (!$npc->FindBuff(40732)) {  # If debuff is not found
        # If the debuff is gone, set the flag to 0
        quest::set_data("wmu_has_debuff_$npc_id", 0);
        quest::signalwith(1352, 2);  # Signal to make the boss invulnerable
    }
}