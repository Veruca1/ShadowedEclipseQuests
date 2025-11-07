my $spell_id_close = 27993; # pushback
my $spell_id_mid = 23644; # pull toward - Tidepull
my $spell_id_far = 12309; # stun - Stunning Strike
my $spell_radius_close = 20; # Close range
my $spell_radius_mid = 35; # Mid range
my $spell_radius_far = 135; # Far range
my $overall_timer = 3600; # 1 hour in seconds

sub EVENT_SPAWN {
    quest::gmsay("The Temporal Vision of Veeshan has awakened! Prepare yourselves, mortals.", 14, 1, 0, 0);
    $npc->SetSpecialAbility(54, 1); # immune to assassinate
    $npc->SetSpecialAbility(55, 1); # immune to headshot
    $npc->SetSpecialAbility(14, 1); # immune to charm
    quest::settimer("OverallTimer", $overall_timer); # Set the overall timer to 1 hour
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(90);
    } else {
        # Reset health when combat ends
        $npc->SetHP($npc->GetMaxHP()); # Reset health to max
        quest::stoptimer("CheckDistance"); # Stop the distance check timer when combat ends
    }
}

sub EVENT_HP {
    if ($hpevent == 90) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(80);
    } elsif ($hpevent == 80) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(70);
    } elsif ($hpevent == 70) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(60);
    } elsif ($hpevent == 60) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        quest::settimer("CheckDistance", 50); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(30);
    } elsif ($hpevent == 30) {
        quest::settimer("CheckDistance", 40); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(20);
    } elsif ($hpevent == 20) {
        quest::settimer("CheckDistance", 15); # Adjusted to 15 seconds
        quest::setnexthpevent(10);
    }
}

sub EVENT_TIMER {
    if ($timer eq "CheckDistance") {
        my @players = $entity_list->GetClientList(); # Get all players in the zone
        my $aggro_target = $npc->GetTarget(); # Get the NPC's aggro target

        foreach my $player (@players) {
            my $distance = $npc->CalculateDistance($player->GetX(), $player->GetY(), $player->GetZ());

            # Check if the player is the NPC's aggro target
            if ($player == $aggro_target) {
                # Focus on the aggro target and cast spells on them
                if ($distance <= $spell_radius_close) {
                    $npc->SpellFinished($spell_id_close, $player, 0, -10000); # Cast the spell on the player
                } elsif ($distance >= $spell_radius_mid && $distance <= $spell_radius_far) {
                    $npc->SpellFinished($spell_id_mid, $player, 0, -10000); # Cast the spell on the player
                } elsif ($distance >= $spell_radius_far && $distance <= 250) {
                    $npc->SpellFinished($spell_id_far, $player, 0, -10000); # Cast the spell on the player
                }
            }
        }

        # Proceed only if aggro target is a client
        if ($aggro_target && $aggro_target->IsClient()) {
            my $character_id = $aggro_target->CastToClient()->CharacterID();
            my @bots = $entity_list->GetBotListByCharacterID($character_id);

            foreach my $bot (@bots) {
                my $bot_distance = $npc->CalculateDistance($bot->GetX(), $bot->GetY(), $bot->GetZ());
                
                # Exclude bots that are not part of the aggro
                if ($bot_distance <= $spell_radius_close && $bot != $aggro_target) {
                    $npc->SpellFinished(31222, $bot, 0, -10000); # 31222 7k hit bot
                    if ($bot->GetPetID() > 0) {
                        my $bot_pet = $entity_list->GetNPCByID($bot->GetPetID());
                        $npc->SpellFinished(12309, $bot, 0, -10000); # Stunning Pets
                        $npc->SpellFinished(3238, $bot, 0, -10000); # Kill Summoned
                    }
                } elsif ($bot_distance >= $spell_radius_mid && $bot_distance <= $spell_radius_far) {
                    $npc->SpellFinished($spell_id_mid, $bot, 0, -10000); # Cast the spell on the bot
                } elsif ($bot_distance >= $spell_radius_far && $bot_distance <= 250) {
                    $npc->SpellFinished($spell_id_far, $bot, 0, -10000); # Cast the spell on the bot
                }
            }
        }
    } elsif ($timer eq "OverallTimer") {
        # Depop the NPC after 1 hour (if it's not dead yet)
        quest::depop();
    }
}



sub EVENT_DEATH {
    quest::signalwith(1427, 39, 0);
    quest::stoptimer("CheckDistance"); # Stop the distance check timer on death
    quest::stoptimer("OverallTimer"); # Stop the overall timer on death
}