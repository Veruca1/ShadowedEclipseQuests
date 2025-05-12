my $marked_client;
my $marked_client_id;
my $last_hate = 0;

sub EVENT_SPAWN {
    quest::signalwith(1911, 899);
    if ($marked_client_id) {
        # Reapply the mark to the client if they were previously marked
        my $client = $entity_list->GetClientByID($marked_client_id);
        if ($client) {
            #quest::shout("DEBUG: Reapplying mark to player " . $client->GetCleanName());
            $npc->CastSpell(40706, $marked_client_id);  # Reapply the frost mark to the player
            $client->Message(15, "You feel a strange frost mark chill your body...");
            
            # Also mark the bots of the client
            my @all_bots = $entity_list->GetBotList();
            foreach my $bot (@all_bots) {
                next unless $bot && $bot->IsBot();
                my $owner = $bot->GetOwner();
                if ($owner && $owner->IsClient() && $owner->GetID() == $client->GetID()) {
                    #quest::shout("DEBUG: Reapplying mark to bot " . $bot->GetCleanName());
                    $npc->CastSpell(40706, $bot->GetID());  # Mark the bot with frost mark
                    #$bot->Message(15, "You feel a strange frost mark chill your body...");
                }
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1 && !$marked_client) {
        #quest::shout("DEBUG: Combat started, scanning hate list.");
        my @hate_list = $npc->GetHateList();
        my @eligible_players;

        foreach my $entry (@hate_list) {
            my $ent = $entry->GetEnt();
            next unless $ent && $ent->IsClient();

            my $client = $ent->CastToClient();
            if (!$client->IsBot()) {
                push(@eligible_players, $client);
                #quest::shout("DEBUG: Eligible player found: " . $client->GetCleanName() . " (ID: " . $client->GetID() . ")");
            }
        }

        if (@eligible_players) {
            $marked_client = $eligible_players[int(rand(@eligible_players))];
            $marked_client_id = $marked_client->GetID();  # Store the ID of the marked player
            #quest::shout("DEBUG: Marking player " . $marked_client->GetCleanName() . " (Entity ID: $marked_client_id)");
            $npc->CastSpell(40706, $marked_client_id);  # Marking the player with the frost mark spell
            $marked_client->Message(15, "You feel a strange frost mark chill your body...");

            # Now mark all of the bots owned by the marked player
            my @all_bots = $entity_list->GetBotList();
            foreach my $bot (@all_bots) {
                next unless $bot && $bot->IsBot();
                my $owner = $bot->GetOwner();
                if ($owner && $owner->IsClient() && $owner->GetID() == $marked_client->GetID()) {
                    #quest::shout("DEBUG: Marking bot " . $bot->GetCleanName() . " (ID: " . $bot->GetID() . ")");
                    $npc->CastSpell(40706, $bot->GetID());  # Mark the bot with frost mark
                    #$bot->Message(15, "You feel a strange frost mark chill your body...");
                }
            }

            $last_hate = $npc->GetHateAmount($marked_client);
            quest::settimer("check_marked_attacker", 1);
        } else {
            #quest::shout("DEBUG: No eligible players found to mark.");
        }
    } elsif ($combat_state == 0) {
        #quest::shout("DEBUG: Combat ended. Saving marked player ID.");
        quest::stoptimer("check_marked_attacker");

        # Track the marked player's ID when combat ends
        $marked_client_id = $marked_client ? $marked_client->GetID() : undef;
        $marked_client = undef;  # Reset the client but keep the ID for re-marking
        $last_hate = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_marked_attacker" && $marked_client) {
        my $current_hate = $npc->GetHateAmount($marked_client);
        
        # Apply damage to the marked player if their hate increases
        if ($current_hate > $last_hate) {
            quest::shout("The mark sears " . $marked_client->GetCleanName() . " with pain as they attack!");
            $marked_client->Damage($npc, 10000, 0, 0, true);  # 10k damage to the player
        }

        # Now apply the same damage to the bots of the marked player
        my @all_bots = $entity_list->GetBotList();
        foreach my $bot (@all_bots) {
            next unless $bot && $bot->IsBot();
            my $owner = $bot->GetOwner();
            if ($owner && $owner->IsClient() && $owner->GetID() == $marked_client->GetID()) {
                quest::shout("The mark sears " . $bot->GetCleanName() . " with pain as they attack!");
                $bot->Damage($npc, 10000, 0, 0, true);  # 10k damage to the bot
            }
        }

        $last_hate = $current_hate;
    }
}

sub EVENT_DAMAGE_TAKEN {
    my ($attacker, $damage) = @_;

    # If attacker is a bot and belongs to the marked client, block the damage
    if ($attacker && $attacker->IsBot() && $marked_client) {
        my $owner = $attacker->GetOwner();
        if ($owner && $owner->IsClient() && $owner->GetID() == $marked_client->GetID()) {
            quest::shout("DEBUG: Blocked all damage from bot of marked player: " . $attacker->GetCleanName());
            return 0;  # Block the damage for the bot
        }
    }

    return $damage;  # Allow the damage if it's not blocked
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(1595, 0, 0, -1166.82, 1861.11, 169.18, 387.75);
    quest::spawn2(1594, 0, 0, -1175.27, 1800.26, 170.36, 388.50);
    quest::spawn2(1595, 0, 0, -1172.91, 1740.11, 167.41, 389.75);
    
}
