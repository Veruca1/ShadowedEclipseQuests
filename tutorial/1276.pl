sub EVENT_SPAWN {
    # Cast Inferno Shield immediately on spawn
    $npc->CastSpell(479, $npc->GetID());  # Cast Inferno Shield on itself
    $npc->SetMana($npc->GetMaxMana());  # Ensure the pet has full mana after casting

    # Start the periodic check for Inferno Shield
    quest::settimer("check_inferno_shield", 60);  # Check every 60 seconds
}

sub EVENT_TIMER {
    if ($timer eq "check_inferno_shield") {
        # Check if Inferno Shield is active
        my $shield_active = $npc->HasSpellEffect(479);
        if (!$shield_active) {
            $npc->CastSpell(479, $npc->GetID());  # Recast Inferno Shield on itself
            $npc->SetMana($npc->GetMaxMana());  # Restore mana to full after casting
        }
    } elsif ($timer eq "check_player_hp") {
        if ($ownerid) {
            my $owner = $entity_list->GetMobByID($ownerid);  # Get the pet's owner
            if ($owner) {
                my $owner_hp = $owner->GetHPRatio();  # Get owner's HP percentage
                if ($owner_hp < 40) {  # If HP drops below 40%
                    $npc->CastSpell(135, $owner->GetID());  # Cast heal on the owner
                    $npc->SetMana($npc->GetMaxMana());  # Restore mana to full after casting
                }
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Entering combat
        quest::settimer("check_player_hp", 3);  # Check every 3 seconds
    } elsif ($combat_state == 0) {  # Exiting combat
        quest::stoptimer("check_player_hp");
    }
}
