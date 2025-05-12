sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178, 21387);  # Added 21387 to the buffs

    # Apply each buff from the list
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());  # Cast each spell on the NPC itself
    }

    # Start a timer for recasting the buffs
    quest::settimer("recast_buffs", 90);  # Timer fires every 90 seconds
}

sub EVENT_TIMER {
    # Check which timer has fired
    if ($timer eq "recast_buffs") {
        # Reapply buffs on the NPC
        my @buffs = (167, 2177, 161, 649, 2178, 21387);  # Buff list
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());  # Cast each spell on the NPC itself
        }
    }
}

sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        quest::whisper("It is good to see you again, hero! Since you are here, I take it you are [" . quest::saylink("READY", 1) . "] to proceed?");
        quest::whisper("If you need assistance for your journey, click here for a [" . quest::saylink("Blessing", 1) . "].");
    }
    elsif ($text =~ /READY/i) {
        quest::whisper("Go forth and bring down the Arm of the Coven!");
        quest::assigntask(33);
	quest::whisper("After you have finished, BRING ME BACK the 4 runes of the elements, hero. It is vital in order for you to venture into the Labyrinth.");
    }
    elsif ($text =~ /Blessing/i) {
        quest::whisper("Go forth and bring down the Arm of the Coven!");

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
    # Check if the correct items are handed in
    if (plugin::check_handin(\%itemcount, 575 => 1, 576 => 1, 577 => 1, 578 => 1)) {
        # Set the zone flag and send messages
        quest::set_zone_flag(112);
        quest::we(14, "$name has earned access to Velketor's Labyrinth.");
        $client->Message(14, "Excellent work hero. Please venture into this Labyrinth and investigate. It is rumored that Frostbane's grip in Velious tightens at this point.");
    }

    # Return unused items
    plugin::return_items(\%itemcount);
}
