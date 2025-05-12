sub EVENT_SPAWN {
    # Initialize combat state
    $npc->SetEntityVariable("combat_state", 0);
}

sub EVENT_TIMER {
    if ($timer eq "charm_timer") {
        my $combat_state = $npc->GetEntityVariable("combat_state");
        
        # Only charm during combat
        if ($combat_state == 1) {
            my @player_list = $entity_list->GetClientList();
            my @valid_players;
            
            # Filter out bots from the player list
            foreach my $player (@player_list) {
                if (!$player->IsBot()) {
                    push @valid_players, $player;
                }
            }
            
            # Choose a random valid player
            my $random_player = $valid_players[rand @valid_players];
            
            if ($random_player) {
                # Remove all buffs from the player
                $random_player->BuffFadeAll();
                
                # Attempt to charm the player without resistance
                $npc->CastSpell(40674, $random_player->GetID(), 10, 0); # Charm spell (750), unresisted, level 10
                
                # Shout message upon successful charm
                $npc->Shout("Submit to my command!");
            }
        }
        
        quest::stoptimer("charm_timer");
        quest::settimer("charm_timer", 30); # Reset timer for charm every 30 seconds
    }
}

sub EVENT_COMBAT {
    my $combat_state = $combat_state = 1;  # Set combat state to 1 when in combat
    
    if ($combat_state == 1) {
        $npc->Shout("Prepare to face the dissonance of my melodies!");
        $npc->ModifyNPCStat("ac", 200);  # Increases AC temporarily
        $npc->ModifyNPCStat("max_hp", 11000);  # Increases HP temporarily
        
        # Cast Syvelian's Anti-Magic Aria (726) on each player
        cast_syvelians_anti_magic_aria();
        
        # Optional: Add more buffs or effects for combat
    }
    elsif ($combat_state == 0) {
        $npc->Shout("My song shall echo through the halls of Unrest!");
        $npc->ModifyNPCStat("ac", 150);  # Resets AC back to original value
        $npc->ModifyNPCStat("max_hp", 9100);  # Resets HP back to original value
        
        # Optional: Reset other stats or effects after combat
    }
    
    # Update combat state in entity variables
    $npc->SetEntityVariable("combat_state", $combat_state);
}

sub cast_syvelians_anti_magic_aria {
    my @player_list = $entity_list->GetClientList();
    foreach my $player (@player_list) {
        if (!$player->IsBot()) {
            # Attempt to cast Syvelian's Anti-Magic Aria (726) without resistance
            $npc->SpellFinished(726, $player, 1);  # 1 indicates unresisted
            
            # Shout message upon successful debuff
            $npc->Shout("Let me remove those buffs for you!");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("My melody... silenced...");  # Death shout
    # Optional: Add more actions upon death if needed
}