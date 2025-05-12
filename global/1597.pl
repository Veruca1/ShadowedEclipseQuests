sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::whisper("The Arcane Waystone of the Combine offers teleport and blessing options:");
        quest::whisper(quest::saylink("FoB", 1) . ", " .
            quest::saylink("FM", 1) . ", " .
            quest::saylink("WW", 1) . ", " .
            quest::saylink("OT", 1) . ", " .
            quest::saylink("EJ", 1) . ", " .
            quest::saylink("LOIO", 1) . ", " .
            quest::saylink("Trakanon", 1) . ", " .
            quest::saylink("FV", 1) . ", " .
            quest::saylink("Karnor", 1) . ", or " .
            quest::saylink("Iceclad", 1) . ".");
        quest::whisper(quest::saylink("Blessing", 1) . "."); # Added blessing option
    }
    elsif ($text =~ /blessing/i) {
        quest::whisper("Let the Combine's wisdom guide you on your journey!");

        # New blessing spells
        my @spells = (32165, 1669, 2517, 1598, 2570, 2895, 1447, 1432, 1580, 2519, 3576);

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
            my $buffgroup = $client->GetGroup();
            if ($buffgroup) {
                for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
                    my $groupmember = $buffgroup->GetMember($count);
                    if ($groupmember) {
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
        my @npc_list = $entity_list->GetNPCList();
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                foreach my $spell (@spells) {
                    $client->SpellFinished($spell, $npc);
                }

                # Cast spells on the bot's pet
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
    elsif ($text =~ /FoB/i) {
        quest::whisper("Very well! I will transport you to The Field of Bone.");
        quest::movepc(78, 1617.00, -1684.00, -49.25); # Field of Bone coordinates
    }
    elsif ($text =~ /FM/i) {
        quest::whisper("Very well! I will transport you to The Frontier Mountains.");
        quest::movepc(92, -3991.94, -601.07, 96.00, 182.25); # Frontier Mountains coordinates
    }
    elsif ($text =~ /WW/i) {
        quest::whisper("Very well! I will transport you to Warsliks Woods.");
        quest::movepc(79, -468.00, -1324.02, 198.99, 0.00); # Warsliks Woods coordinates
    }
    elsif ($text =~ /OT/i) {
        quest::whisper("Very well! I will transport you to The Overthere.");
        quest::movepc(93, 1922.24, 3153.48, -49.03, 353.50); # The Overthere coordinates
    }
    elsif ($text =~ /EJ/i) {
        quest::whisper("Very well! I will transport you to The Emerald Jungle.");
        quest::movepc(94, 4648.00, -1223.00, 2.00, 0.00); # Emerald Jungle coordinates
    }
    elsif ($text =~ /LOIO/i) {
        quest::whisper("Very well! I will transport you to The Lake of Ill Omen.");
        quest::movepc(85, 1158.31, -301.09, 79.08, 390.00); # Lake of Ill Omen coordinates
    }
    elsif ($text =~ /Trakanon/i) {
        quest::whisper("Very well! I will transport you to Trakanon's Teeth.");
        quest::movepc(95, -4814.08, -1549.92, -470.83); # Trakanon's Teeth coordinates
    }
    elsif ($text =~ /FV/i) {
        quest::whisper("Very well! I will transport you to Firiona Vie.");
        quest::movepc(84, 1266.72, -2573.69, -14.66, 298); # Firiona Vie coordinates
    }
    elsif ($text =~ /Karnor/i) {
        quest::whisper("Very well! I will transport you to Karnor's Castle.");
        quest::movepc(102, 296.70, 13.71, 3.13, 387.50); # Karnor's Castle coordinates
    }
    elsif ($text =~ /Iceclad/i) {
        quest::whisper("Very well! I will transport you to Iceclad Ocean.");
        quest::movepc(110, -5432.00, -2796.00, -20.00, 120.00); # Iceclad Ocean coordinates
    }
    else {
        quest::whisper("Invalid selection. Please try again.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop();
    }
}

sub EVENT_SPAWN {
    quest::settimer("depop", 10); # Set a 10-second timer to depop
}
