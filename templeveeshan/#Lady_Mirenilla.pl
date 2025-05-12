my $immune_flip = 0;

sub EVENT_SPAWN {
    plugin::boss_scaling($npc, undef);
    $npc->AddNimbusEffect(511);

    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178, 21387);

    # Apply each buff to the NPC
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer for recasting buffs
    quest::settimer("recast_buffs", 90);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("immune_flip", 20);
        quest::settimer("help", 5);
        HelpMe();
    } else {
        quest::stoptimer("immune_flip");
        quest::stoptimer("help");
        $npc->SetSpecialAbility(19, 0); # Melee Immune off
        $npc->SetSpecialAbility(20, 0); # Magic Immune off
    }
}

sub EVENT_TIMER {
    if ($timer eq "immune_flip") {
        if ($immune_flip == 0) {
            $npc->SetSpecialAbility(19, 1); # Melee Immune on
            $npc->SetSpecialAbility(20, 0); # Magic Immune off
            $immune_flip = 1;
        } else {
            $npc->SetSpecialAbility(19, 0); # Melee Immune off
            $npc->SetSpecialAbility(20, 1); # Magic Immune on
            $immune_flip = 0;
        }
    } elsif ($timer eq "recast_buffs") {
        my @buffs = (167, 2177, 161, 649, 2178, 21387);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    } elsif ($timer eq "help") {
        HelpMe();
    }
}

sub HelpMe {
    my $aaryonar = $entity_list->GetMobByNpcTypeID(124010);

    if ($aaryonar) {
        my $npc_target = $aaryonar->CastToNPC();
        $npc_target->MoveTo($npc->GetX(), $npc->GetY(), $npc->GetZ(), 0, 0);
    }
}
