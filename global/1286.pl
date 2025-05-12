sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::whisper("The Omni Device offers you teleport and blessing options:");
        quest::whisper(quest::saylink("Tutorial Mines", 1) . ".");
        quest::whisper(quest::saylink("Befallen", 1) . ".");
        quest::whisper(quest::saylink("Greater Faydark", 1) . ".");
        quest::whisper(quest::saylink("Unrest", 1) . ".");
        quest::whisper(quest::saylink("Najena", 1) . ".");
        quest::whisper(quest::saylink("Plane of Hate", 1) . ".");
        quest::whisper(quest::saylink("The Arena", 1) . ".");
        quest::whisper(quest::saylink("The Wave Arena", 1) . ".");
        quest::whisper(quest::saylink("The Dreadlands", 1) . "."); # Added Dreadlands
        quest::whisper(quest::saylink("Trakanon", 1) . "."); # Added Trakanon's Teeth
        quest::whisper(quest::saylink("Blessing", 1) . "."); # Added blessing option
    }
    elsif ($text =~ /blessing/i) {
        quest::whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");
        
        # Define the spell IDs to cast
        my @spells = (32165, 61, 60, 63, 64, 138, 174, 278, 457, 161, 160, 152, 153, 5862, 171);

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
    elsif ($text eq "Tutorial Mines") {
        quest::movepc(189, 18.00, -136.32, 16.66);  
    }
    elsif ($text eq "Befallen") {
        quest::movepc(36, 26.32, -77.27, 2.50);    
    }
    elsif ($text eq "Greater Faydark") {
        quest::movepc(54, -2180.19, -2175.46, 0.70);
    }
    elsif ($text eq "Unrest") {
        quest::movepc(63, 52.00, -38.00, 4.06);    
    }
    elsif ($text eq "Najena") {
        quest::movepc(44, 849.56, -20.86, 4.06);   
    }
    elsif ($text eq "Plane of Hate") {
        quest::movepc(186, -374.54, 673.74, 4.06); 
    }
    elsif ($text eq "The Arena") {
        quest::movepc(77, 144.42, -976.89, 50.85);
    }
    elsif ($text eq "The Wave Arena") {
        quest::movepc(492, -15.21, -50.81, -9.87); 
    }
    elsif ($text eq "The Dreadlands") { 
        quest::whisper("Very well! I will transport you to The Dreadlands."); 
        quest::movepc(86, 9495.46, 781.36, 1065.00); # Dreadlands coordinates
    }
    elsif ($text =~ /Trakanon/i) {
        quest::whisper("Very well! I will transport you to Trakanon's Teeth.");
        quest::movepc(95, -4814.08, -1549.92, -470.83); # Trakanon's Teeth coordinates
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
    quest::settimer("depop", 10);  
}
