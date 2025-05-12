sub EVENT_SPAWN {
    # Cast Stronger Damage Shield immediately on spawn
    $ownerid = $npc->GetOwnerID();  # Set the owner ID when the pet spawns
    $npc->CastSpell(412, $npc->GetID());  # Cast Stronger Damage Shield on itself
    $npc->SetMana($npc->GetMaxMana());  # Ensure the pet has full mana after casting

    # Start the periodic check for Stronger Damage Shield
    quest::settimer("check_stronger_shield", 60);  # Check every 60 seconds

    # Start the health check immediately upon spawn (even outside of combat)
    quest::settimer("check_player_hp", 3);  # Check every 3 seconds
}

sub EVENT_TIMER {
    if ($timer eq "check_stronger_shield") {
        # Check if Stronger Damage Shield is active
        my $shield_active = $npc->HasSpellEffect(412);
        if (!$shield_active) {
            $npc->CastSpell(412, $npc->GetID());  # Recast Stronger Damage Shield on itself
            $npc->SetMana($npc->GetMaxMana());  # Restore mana to full after casting
        }
   elsif ($timer eq "check_player_hp") {
        if ($ownerid) {
            my $owner = $entity_list->GetMobByID($ownerid);
            if ($owner && $owner->IsClient()) {
                my $should_heal = 0;

                my $client = $owner->CastToClient();
                my $group = $client->GetGroup();
                if ($group) {
                    for (my $i = 0; $i < $group->GroupCount(); $i++) {
                        my $member = $group->GetMember($i);
                        if ($member && $member->GetHPRatio() < 50) {
                            $should_heal = 1;
                            last;
                        }
                    }
                } elsif ($owner->GetHPRatio() < 50) {
                    $should_heal = 1;
                }

                if ($should_heal) {
                    $npc->CastSpell(36857, $owner->GetID());  # Cast group heal centered on owner
                    $npc->SetMana($npc->GetMaxMana());
                    $npc->Say("Group healing now!");
                }
            }
        }
    }
}
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # No need to stop health check since it's continuous now
    }
}
