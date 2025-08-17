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
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();

    # Item 382: Firiona's Filled Satchel – Bot Limit Expansion
    if (plugin::check_handin(\%itemcount, 382 => 1)) {
        my @members = $group ? map { $group->GetMember($_) } (0 .. $group->GroupCount() - 1)
                     : $raid  ? map { $raid->GetMember($_) }  (0 .. $raid->RaidCount() - 1)
                     : ($client);

        foreach my $member (@members) {
            next unless $member && $member->GetIP() == $clicker_ip;

            my $char_id = $member->CharacterID();
            my $bot_limit_flag = "$char_id-bot_spawn_limit";

            $member->Message(14, "Thanks for your service, Savior! That was no easy feat. As promised, here is your extra companion.");

            if (quest::get_data($bot_limit_flag) == 3) {
                $member->SetBotSpawnLimit(4);
                quest::we("Help me congratulate " . $member->GetName() . "! They have upgraded their bot spawn limit to 4!");
            } else {
                $member->SetBotSpawnLimit(4);
                quest::we(14, "Help me congratulate " . $member->GetName() . "! They have upgraded their bot spawn limit to 4!");
            }

            quest::set_data($bot_limit_flag, 4);
            $member->SummonItem(384);
        }
    }

    # Item 262: Access to Sebilis (ZoneID 89)
    elsif (plugin::check_handin(\%itemcount, 262 => 1)) {
        my $flagged = 0;
        my @members = $group ? map { $group->GetMember($_) } (0 .. $group->GroupCount() - 1)
                     : $raid  ? map { $raid->GetMember($_) }  (0 .. $raid->RaidCount() - 1)
                     : ($client);

        foreach my $member (@members) {
            next unless $member && $member->GetIP() == $clicker_ip;
            $member->SetZoneFlag(89);
            $member->Message(14, "You have earned access to Sebilis!");
            $flagged = 1;
        }

        if ($flagged) {
            quest::we(14, "$name and party members on the same IP have earned access to Sebilis!");
        } else {
            $client->SetZoneFlag(89);
            quest::we(14, "$name has earned access to Sebilis!");
        }

        quest::whisper("Hello again adventurer. Thank you again for saving me in Karnors...");
        quest::whisper("Please select your destination by clicking the option below: " . quest::saylink("Sebilis", 1) . ".");
    }

    # Item 383: Savior of Kunark – Multiple Zone Flags
    elsif (plugin::check_handin(\%itemcount, 383 => 1)) {
        quest::whisper("This absolutely astonishing! I had feared we all may be doomed...");
        quest::enabletitle(402);
        quest::assigntask(27);
        quest::whisper("Let's get you another companion as it has been a while...");

        my @flags = (74, 101, 39, 407, 18, 72, 59, 64, 66, 71);
        my $flagged = 0;
        my @members = $group ? map { $group->GetMember($_) } (0 .. $group->GroupCount() - 1)
                     : $raid  ? map { $raid->GetMember($_) }  (0 .. $raid->RaidCount() - 1)
                     : ($client);

        foreach my $member (@members) {
            next unless $member && $member->GetIP() == $clicker_ip;

            foreach my $zoneid (@flags) {
                $member->SetZoneFlag($zoneid);
            }

            $flagged = 1;
        }

        if ($flagged) {
            quest::we(14, "$name and party members on the same IP have earned multiple zone accesses!");
        } else {
            foreach my $zoneid (@flags) {
                $client->SetZoneFlag($zoneid);
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::castspell(21387, $npc->GetID());
        quest::settimer("recast_spell", 90);
    } elsif ($combat_state == 0) {
        quest::stoptimer("recast_spell");
    }
}

sub EVENT_TIMER {
    if ($timer eq "recast_spell") {
        quest::castspell(21387, $npc->GetID());
    }

    if ($timer eq "recast_buffs") {
        my @buffs = (167, 2177, 161, 649, 2178, 21387);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}