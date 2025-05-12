sub EVENT_SPAWN {
    # Spawn the pet (NPC ID 1386) if it doesn't already exist
    if (!$npc->GetPet()) {
        quest::spawn2(1386, 0, 0, $x, $y, $z, $h);
    }
}

sub EVENT_AGGRO {
    # Set a timer for Temporal Flare to cast every 48 seconds during combat
    quest::settimer("temporal_flare", 48);

    # Set a timer for invulnerability and emote every 90 seconds during combat
    quest::settimer("shift_time", 90);
}

sub EVENT_COMBAT {
    # If combat ends, stop all combat-related timers
    if ($combat_state == 0) {
        quest::stoptimer("temporal_flare");
        quest::stoptimer("shift_time");
        quest::stoptimer("remove_invul");
        $npc->SetInvul(false);  # Ensure invulnerability is removed if combat ends during invul phase
    }
}

sub EVENT_TIMER {
    # Only proceed if the NPC is in combat (i.e., the combat state is true)
    if ($npc->IsEngaged()) {
        if ($timer eq "temporal_flare") {
            # Check if the NPC has a valid top hate target before casting
            my $target = $npc->GetHateTop();
            if ($target) {
                # Cast Temporal Flare (spell ID 36875) on the top hate target
                $npc->CastSpell(36875, $target->GetID());
            }
        }

        if ($timer eq "shift_time") {
            # Make the NPC invulnerable
            $npc->SetInvul(true);
            
            # Emote to players that the NPC has shifted out of time
            quest::emote("shifts out of time, becoming invulnerable.");

            # Set a temporary timer to remove invulnerability after 5 seconds
            quest::settimer("remove_invul", 5);
        }

        if ($timer eq "remove_invul") {
            # Remove invulnerability after 5 seconds
            $npc->SetInvul(false);
            
            # Emote that the NPC has returned to time
            quest::emote("shifts back into the flow of time.");
            
            # Stop the temporary timer
            quest::stoptimer("remove_invul");
        }
    } else {
        # If NPC is not in combat, stop all timers
        quest::stoptimer("temporal_flare");
        quest::stoptimer("shift_time");
        quest::stoptimer("remove_invul");
        $npc->SetInvul(false);  # Ensure invulnerability is removed if not in combat
    }
}

sub EVENT_DEATH {
    # Despawn the pet (NPC ID 1386)
    quest::depop(1386);

    # Optionally handle what happens when the NPC dies
    quest::say("I am defeated...");

    # Stop all timers when the NPC dies
    quest::stoptimer("temporal_flare");
    quest::stoptimer("shift_time");
    quest::stoptimer("remove_invul");
}
