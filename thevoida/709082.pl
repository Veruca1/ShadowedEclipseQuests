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
        quest::say("If you need assistance for your journey, click here for a " . quest::saylink("Blessing", 1) . ".");
    }
    elsif ($text =~ /Blessing/i) {
        plugin::Whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");
        my @spells = (2895, 2570, 1447, 1669, 1598, 2517);

        foreach my $spell (@spells) {
            $client->SpellFinished($spell, $client);
        }

        my $pet_id = $client->GetPetID();
        if ($pet_id) {
            my $pet = $entity_list->GetMobByID($pet_id);
            foreach my $spell (@spells) {
                $client->SpellFinished($spell, $pet);
            }
        }

        if ($client->IsGrouped()) {
            my $buffgroup = $client->GetGroup();
            if ($buffgroup) {
                for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
                    my $groupmember = $buffgroup->GetMember($count);
                    if ($groupmember) {
                        foreach my $spell (@spells) {
                            $client->SpellFinished($spell, $groupmember);
                        }

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
                plugin::Whisper("Error retrieving group information.");
            }
        }

        my @npc_list = $entity_list->GetNPCList();
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                foreach my $spell (@spells) {
                    $client->SpellFinished($spell, $npc);
                }

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
