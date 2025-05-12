my $immune_flip = 0;

sub EVENT_SPAWN {
    plugin::boss_scaling($npc, undef);
    $npc->AddNimbusEffect(511);

    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178, 21387);  # Added 21387 to the buffs

    # Apply each buff from the list
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());  # Cast each spell on the NPC itself
    }

    # Start a timer for recasting buffs
    quest::settimer("recast_buffs", 90);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("immune_flip", 20);
    } else {
        quest::stoptimer("immune_flip");
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
    }
}
