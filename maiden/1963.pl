my $debuff_id = 40732;

sub EVENT_SPAWN {
    return unless defined $npc;

    $npc->SetInvul(1);                         # Start invulnerable
    quest::settimer("check_debuff", 5);        # Recheck debuff every 5 seconds
}

sub EVENT_CAST_ON {
    return unless defined $spell_id;
    return unless $spell_id == $debuff_id;
    return unless defined $npc;

    # Temporarily make the skeleton vulnerable
    $npc->SetInvul(0);
    quest::settimer("reenable_invul", 2);      # Back to invul after 2 seconds
}

sub EVENT_TIMER {
    return unless defined $npc;

    if ($timer eq "check_debuff") {
        # Do nothing — just keep rechecking every 5 seconds
        # This timer exists in case you want to attach future logic or debugging
    }
    elsif ($timer eq "reenable_invul") {
        $npc->SetInvul(1);                     # Return to invulnerable state
        quest::stoptimer("reenable_invul");
    }
}