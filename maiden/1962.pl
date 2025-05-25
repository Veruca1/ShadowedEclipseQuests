sub EVENT_SPAWN {
    $npc->SetInvul(1);
}

sub EVENT_CAST_ON {
    my $debuff_id = 40732;

    if (defined $spell_id && $spell_id == $debuff_id) {
        # Temporarily disable invul so the spell can land
        $npc->SetInvul(0);

        # Start a short timer to re-enable invul quickly
        quest::settimer("reenable_invul", 1);  # Adjust timer as needed
    }
}

sub EVENT_TIMER {
    if (defined $timer && $timer eq "reenable_invul") {
        $npc->SetInvul(1);
        quest::stoptimer("reenable_invul");
    }
}

sub EVENT_SPELL_EFFECT {
    my $debuff_id = 40732;

    if (defined $spell_id && $spell_id == $debuff_id) {
        $npc->SetInvul(1);

        if (defined $npc && defined $npc->GetID) {
            quest::set_data("wmu_has_debuff_" . $npc->GetID(), 1);

            # ✅ CALL THE PLUGIN HERE
            plugin::wmu_check_all_debuffed();
        }

        $npc->Emote("shudders as the magic breaks through its defenses.") if defined $npc;
    }
}

sub EVENT_SPELL_EFFECT_FADE {
    my $debuff_id = 40732;

    if (defined $spell_id && $spell_id == $debuff_id) {
        if (defined $npc && defined $npc->GetID) {
            quest::set_data("wmu_has_debuff_" . $npc->GetID(), 0);

            # ✅ CALL THE PLUGIN HERE
            plugin::wmu_check_all_debuffed();
        }
    }
}

sub check_all_debuffed {
    my $entity_list = plugin::val('entity_list');
    return unless defined $entity_list;

    my $npc_list = $entity_list->GetNPCList();
    return unless defined $npc_list && ref($npc_list) eq 'ARRAY';

    return unless defined $npc && defined $npc->GetNPCTypeID;
    my $npc_type_id = $npc->GetNPCTypeID();
    my $count_checked = 0;

    foreach my $mob (@{$npc_list}) {
        next unless defined $mob;
        next unless $mob->IsNPC();
        next unless defined $mob->GetNPCTypeID;
        next unless $mob->GetNPCTypeID() == $npc_type_id;

        $count_checked++;
        my $mob_id = $mob->GetID();
        next unless defined $mob_id;

        my $has_debuff = quest::get_data("wmu_has_debuff_" . $mob_id) || 0;

        return if !$has_debuff;  # Stop checking if any NPC missing debuff
    }

    # All NPCs of this type have the debuff
    quest::shout("All enemies are debuffed!") if defined $npc;
}