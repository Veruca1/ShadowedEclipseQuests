sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178, 21387);  # Added 21387 to the buffs

    # Apply each buff from the list
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());  # Cast each spell on the NPC itself
    }

    # Optionally, start a timer for recasting the buff if needed
    quest::settimer("recast_buffs", 90);  # Adjust the timer as necessary
}

sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        quest::whisper("Hello again adventurer. Thank you again for saving me in Karnors. I have since learned about the time manipulation this Chronomancer Zarrin has been up to. We have discovered, with the help of Al`Kabor here, that the Chronomancer has been hiding in an alternate version of Sebilis. Please investigate and report back with findings of anything unusual.");

        quest::whisper("Please select your destination by clicking the option below: " . quest::saylink("Sebilis", 1) . ".");
        quest::whisper("If you need assistance for your journey, click here for a " . quest::saylink("Blessing", 1) . ".");
    }
    elsif ($text =~ /Sebilis/i) {
        if ($client->HasZoneFlag(102)) {
            quest::whisper("Very well! I will transport you to Sebilis.");
            quest::movepc(89, 0.00, 250.00, 44.75, 258.50);
        } else {
            quest::whisper("I'm afraid you are not yet attuned to access that version of Sebilis. Seek out the trials that will prove your readiness.");
        }
    }
    
    elsif ($text =~ /Blessing/i) {
        quest::whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");

        # Define the spell IDs to cast
        my @spells = (2895, 2570, 1447, 1669, 1598, 2517);

        # Cast spells on the player
        foreach my $spell (@spells) {
            $client->SpellFinished($spell, $client);
        }

        # Cast spells on the player's pet
        my $pet_id = $client->GetPetID();
        if ($pet_id) {
            my $pet = $entity_list->GetMobByID($pet_id);
            foreach my $spell (@spells) {
                $client->SpellFinished($spell, $pet);
            }
        }

        # Cast spells on the entire group
        if ($client->IsGrouped()) {
            my $buffgroup = $client->GetGroup();  # Retrieve the group object
            if ($buffgroup) {
                # Loop through group members and apply spells
                for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
                    my $groupmember = $buffgroup->GetMember($count);
                    if ($groupmember) {
                        # Cast spells on each group member
                        foreach my $spell (@spells) {
                            $client->SpellFinished($spell, $groupmember);
                        }

                        # Cast spells on each group member's pet
                        my $groupmember_pet_id = $groupmember->GetPetID();
                        if ($groupmember_pet_id) {
                            my $groupmember_pet = $entity_list->GetMobByID($groupmember_pet_id);
                            foreach my $spell (@spells) {
                                if ($groupmember_pet) {
                                    $client->SpellFinished($spell, $groupmember_pet);
                                }
                            }
                        }
                    }
                }
            } else {
                quest::whisper("Error retrieving group information.");
            }
        }

        # Cast spells on the player's bots and their pets
        my @npc_list = $entity_list->GetNPCList();  # Retrieve all NPCs in the zone
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                foreach my $spell (@spells) {
                    $client->SpellFinished($spell, $npc);
                }

                # Cast spells on the bot's pet if it has one
                my $bot_pet_id = $npc->GetPetID();
                if ($bot_pet_id) {
                    my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
                    foreach my $spell (@spells) {
                        if ($bot_pet) {
                            $client->SpellFinished($spell, $bot_pet);
                        }
                    }
                }
            }
        }
    }
}


sub EVENT_ITEM {
    # Check if the player hands in item 382 (Firiona's Filled Satchel)
    if (plugin::check_handin(\%itemcount, 382 => 1)) {
        my $char_id = $client->CharacterID(); 
        my $bot_limit_flag = "$char_id-bot_spawn_limit"; # New flag for bot spawn limits
        
        quest::message(14, "Thanks for your service, Savior! That was no easy feat. As promised, here is your extra companion.");
        
        # Check the current bot spawn limit
        if (quest::get_data($bot_limit_flag) == 3) {
            # If the player previously had a limit of 3, increase to 4
            $client->SetBotSpawnLimit(4);
            quest::we("Help me congratulate $name! They have upgraded their bot spawn limit to 4!");
        } else {
            # If this is their first limit increase, set it to 4
            $client->SetBotSpawnLimit(4);
            quest::we(14, "Help me congratulate $name! They have upgraded their bot spawn limit to 4!");
        }
        
        # Set or update the new limit flag
        quest::set_data($bot_limit_flag, 4); 

	# Give the player item 384
        quest::summonitem(384); # Add item 384 to the player's inventory
        
    }
    # If the player hands in item 262
    elsif (plugin::check_handin(\%itemcount, 262 => 1)) {
        # Grant access to Sebilis by setting the zone flag
        quest::set_zone_flag(89);   # Set zone flag for Sebilis
        
        # Announce to the whole zone that the player has been granted access to Sebilis
        quest::we(14, $name . " has earned access to Sebilis!");
        
        # Respond to the player after hand-in
        quest::whisper("Hello again adventurer. Thank you again for saving me in Karnors. I have since learned about the time manipulation this Chronomancer Zarrin has been up to. We have discovered, with the help of Al`Kabor here, that the Chronomancer has been hiding in an alternate version of Sebilis. Please investigate and report back with findings of anything unusual.");
        
        # Offering a teleport option
        quest::whisper("Please select your destination by clicking the option below: " . quest::saylink("Sebilis", 1) . ".");
    }

    # If the player hands in item 383
    elsif (plugin::check_handin(\%itemcount, 383 => 1)) {
        quest::whisper("This absolutely astonishing! I had feared we all may be doomed. Praise Tunare you are victorious, you shall be dubbed Savior of Kunark!");
        quest::whisper("The letter you have there only bears the news that even though we are finally victorious, it seems we have perhaps only just begun the fight against the Shadowed Eclipse.");

        # Grant the title "Savior of Kunark"
        quest::enabletitle(402);

        # Assign quest/task ID 27
        quest::assigntask(27);

        # Additional message after assigning the task
        quest::whisper("Let's get you another companion as it has been a while. It should help you with what's to come.");

        # Grant access to multiple zones
        quest::set_zone_flag(74);    # kerraridge
        quest::set_zone_flag(101);   # warrens
        quest::set_zone_flag(39);    # hole
        quest::set_zone_flag(407);   # highpasshold
        quest::set_zone_flag(18);    # paw
        quest::set_zone_flag(72);    # fearplane
        quest::set_zone_flag(59);    # mistmoore
        quest::set_zone_flag(64);    # kedge
        quest::set_zone_flag(66);    # gukbottom
        quest::set_zone_flag(71);    # airplane
    }

    # No need to return the item; it is consumed
}


sub EVENT_COMBAT {
    # Start casting the spell when engaged in combat
    if ($combat_state == 1) {
        quest::castspell(21387, $npc->GetID());  # Cast spell on self
        quest::settimer("recast_spell", 90);  # Set timer for recasting (90 seconds)
    } elsif ($combat_state == 0) {
        quest::stoptimer("recast_spell");  # Stop the timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "recast_spell") {
        quest::castspell(21387, $npc->GetID());  # Recast spell on self
    }

    if ($timer eq "recast_buffs") {
        # Reapply all buffs periodically
        my @buffs = (167, 2177, 161, 649, 2178, 21387);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}
