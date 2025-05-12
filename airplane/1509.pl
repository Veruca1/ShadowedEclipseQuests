sub EVENT_SPAWN {
    # Start a timer to check buffs every second
    quest::settimer("check_buffs", 1);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        # Check if spell 13378 is not active and apply it if necessary
        if (!$npc->FindBuff(13378)) {
            $npc->SpellFinished(13378, $npc);
        }
        
        # Check if spell 12933 is not active and apply it if necessary
        if (!$npc->FindBuff(12933)) {
            $npc->SpellFinished(12933, $npc);
        }
    } elsif ($timer eq "spawn_npcs") {
        # Only perform actions if the NPC is still in combat
        if ($npc->IsEngaged()) {
            # Spawn two NPCs with ID 1510 at the NPC's current location
            quest::spawn2(1510, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
            quest::spawn2(1510, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

            # Cast spell 36940 on all players within a certain range
            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                if ($client->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) <= 100) {
                    $npc->CastSpell(36940, $client->GetID());
                }
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # If the NPC enters combat, start the spawn timer
        quest::settimer("spawn_npcs", 80);
    } elsif ($combat_state == 0) {
        # If the NPC leaves combat, stop the spawn timer
        quest::stoptimer("spawn_npcs");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop all timers when the NPC dies to prevent unnecessary checks
    quest::stoptimer("check_buffs");
    quest::stoptimer("spawn_npcs");
}
