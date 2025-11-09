sub EVENT_SPAWN {
    # Cast Aura of Insight (spell ID 8926) on the bard itself
  #  plugin::pet_spawn_scaling($npc, $entity_list);
    $npc->CastSpell(8926, $npc->GetID());

    # Get the NPC's group
    my $group = $entity_list->GetGroupByMob($npc);
    if ($group) {
        # Cast Aura of Insight (spell ID 8939) on everyone in the group (including bots)
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            if ($member && $member->IsClient()) {
                # Cast the aura on each player
                quest::castspell(8939, $member->GetID());
            }
            elsif ($member && $member->IsBot()) {
                # Cast the aura on each bot as well
                quest::castspell(8939, $member->GetID());
            }
        }
    }
}

sub EVENT_SAY {

    # ===========================================================
    # Added section: /hail dialogue explanation
    # ===========================================================
    if ($text =~ /hail/i) {
        quest::whisper(
            "I am your Rockin Raven of the Void, the song between the stars... " .
            "You may guide my melodies through your words — " .
            "use /say 'insight' if you wish me to channel the Aura of Insight, " .
            "/say 'zealot' if you desire the Aura of the Zealot’s burning fervor, " .
            "or /say 'offensive' if you would have me unleash the songs of the void in battle. " .
            "Remember, my memory fades with each crossing between realms — you may need to repeat your command after zoning."
        );
        return;
    }
    # ===========================================================

    if ($text =~ /insight/i) {
        # Cast Aura of Insight (spell ID 8926) on the bard itself
        $npc->CastSpell(8926, $npc->GetID());

        # Cast Aura of Insight (spell ID 8939) on the player
        quest::castspell(8939, $client->GetID());

        # Cast Aura of Insight on the player's group members (including bots)
        if ($client->IsGrouped()) {
            my $group = $client->GetGroup();  
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $groupmember = $group->GetMember($i);
                if ($groupmember) {
                    # Cast the aura on each group member
                    quest::castspell(8939, $groupmember->GetID());

                    # Cast on their pet if they have one
                    my $pet_id = $groupmember->GetPetID();
                    if ($pet_id) {
                        my $pet = $entity_list->GetMobByID($pet_id);
                        if ($pet) {
                            quest::castspell(8939, $pet->GetID());
                        }
                    }
                }
            }
        }

        # Cast Aura of Insight on the player's bots and their pets
        my @npc_list = $entity_list->GetNPCList();  
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                # Cast the aura on each bot
                quest::castspell(8939, $npc->GetID());

                # Cast on their pet if they have one
                my $bot_pet_id = $npc->GetPetID();
                if ($bot_pet_id) {
                    my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
                    if ($bot_pet) {
                        quest::castspell(8939, $bot_pet->GetID());
                    }
                }
            }
        }
    }
    elsif ($text =~ /zealot/i) {
        # Cast Aura of the Zealot (spell ID 8928) on the bard itself
        $npc->CastSpell(8928, $npc->GetID());

        # Cast Aura of the Zealot (spell ID 8940) on the player
        quest::castspell(8940, $client->GetID());

        # Cast Aura of the Zealot on the player's group members (including bots)
        if ($client->IsGrouped()) {
            my $group = $client->GetGroup();  
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $groupmember = $group->GetMember($i);
                if ($groupmember) {
                    # Cast the aura on each group member
                    quest::castspell(8940, $groupmember->GetID());

                    # Cast on their pet if they have one
                    my $pet_id = $groupmember->GetPetID();
                    if ($pet_id) {
                        my $pet = $entity_list->GetMobByID($pet_id);
                        if ($pet) {
                            quest::castspell(8940, $pet->GetID());
                        }
                    }
                }
            }
        }

        # Cast Aura of the Zealot on the player's bots and their pets
        my @npc_list = $entity_list->GetNPCList();  
        foreach my $npc (@npc_list) {
            if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
                # Cast the aura on each bot
                quest::castspell(8940, $npc->GetID());

                # Cast on their pet if they have one
                my $bot_pet_id = $npc->GetPetID();
                if ($bot_pet_id) {
                    my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
                    if ($bot_pet) {
                        quest::castspell(8940, $bot_pet->GetID());
                    }
                }
            }
        }
    }
    elsif ($text =~ /offensive/i) {
        quest::whisper("Switching to offensive mode!");
        quest::settimer("bard_offensive", 1); # Start a fast song rotation
        $npc->SetEntityVariable("mode", "offensive");
        $npc->SetEntityVariable("song_index", 0); # Start at the first song
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::whisper("Engaging in combat! The void hums with dissonant power!");
    } else {
        quest::whisper("The echoes fade... but the void remembers.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "bard_offensive") {
        my $mode = $npc->GetEntityVariable("mode");

        if ($mode eq "offensive") {
            # Offensive song rotation
            my @songs = (5388, 6666, 5384, 5376, 3368); # Offensive song spell IDs
            my $index = $npc->GetEntityVariable("song_index");
            
            # Cast the current song in the rotation
            my $target = $npc->GetHateTop(); # Get the current top hate target
            if ($target) {
                $npc->CastSpell($songs[$index], $target->GetID());
            }
            
            # Update the index for the next song
            $index = ($index + 1) % scalar(@songs); # Loop back to the start if at the end
            $npc->SetEntityVariable("song_index", $index);
        }
    }
}