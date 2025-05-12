sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178, 21387);  # Buff list including 21387

    # Apply each buff from the list to the NPC itself
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }
}

sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        # Define the spell IDs to cast for the buffs
        my @spells = (356, 36880);  # Shield of Thorns and Holy Battle Hymn

        # Cast the spells on the player
        foreach my $spell (@spells) {
            $client->SpellFinished($spell, $client);  # Apply the buff to the player
        }

        # Cast spells on the player's pet (if they have one)
        my $pet_id = $client->GetPetID();
        if ($pet_id) {
            my $pet = $entity_list->GetMobByID($pet_id);
            foreach my $spell (@spells) {
                $client->SpellFinished($spell, $pet);  # Apply the buff to the pet
            }
        }

        # Cast spells on the entire group (if they are in a group)
        if ($client->IsGrouped()) {
            my $buffgroup = $client->GetGroup();  # Retrieve the group object
            if ($buffgroup) {
                for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
                    my $groupmember = $buffgroup->GetMember($count);
                    if ($groupmember) {
                        # Apply the buff to each group member
                        foreach my $spell (@spells) {
                            $client->SpellFinished($spell, $groupmember);
                        }

                        # Cast spells on each group member's pet (if they have one)
                        my $groupmember_pet_id = $groupmember->GetPetID();
                        if ($groupmember_pet_id) {
                            my $groupmember_pet = $entity_list->GetMobByID($groupmember_pet_id);
                            foreach my $spell (@spells) {
                                if ($groupmember_pet) {
                                    $client->SpellFinished($spell, $groupmember_pet);  # Apply the buff to the pet
                                }
                            }
                        }
                    }
                }
            }
        }

        # Cast spells on the player's bots and their pets (if any)
        my @npc_list = $entity_list->GetNPCList();  # Retrieve all NPCs in the zone
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                foreach my $spell (@spells) {
                    $client->SpellFinished($spell, $npc);  # Apply the buff to the bot
                }

                # Cast spells on the bot's pet (if it has one)
                my $bot_pet_id = $npc->GetPetID();
                if ($bot_pet_id) {
                    my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
                    foreach my $spell (@spells) {
                        if ($bot_pet) {
                            $client->SpellFinished($spell, $bot_pet);  # Apply the buff to the bot's pet
                        }
                    }
                }
            }
        }

        # Spawn additional NPCs before sending the message and depop
        quest::spawn2(1705, 0, 0, -110.28, 880.18, 11.30, 22.25);  # Location 1
        quest::spawn2(1705, 0, 0, -65.64, 880.72, 9.89, 7.00);    # Location 2
        quest::spawn2(1705, 0, 0, -5.28, 869.47, 7.63, 7.00);     # Location 3

        # Send the message to all clients in the zone
        my @clients = $entity_list->GetClientList();  # Get all clients in the zone
        foreach my $client (@clients) {
            if ($client) {
                # Send a green message (Message ID 14 is green)
                $client->Message(14, "Ahead and to the slight left, you notice 3 figures on the ground.");
            }
        }

        # Set a timer to depop the NPC after 5 seconds
        quest::settimer("depop", 5);
    }
}

sub EVENT_TIMER {
    # Check which timer has fired
    if ($timer eq "depop") {
        quest::stoptimer("depop");  # Stop the timer to avoid unnecessary calls
        quest::depop();            # Depop the NPC
    }
}
