my $spell_id_close = 27993; # pushback
my $spell_id_mid = 23644; # pull toward - Tidepull
my $spell_id_far = 12309; # stun - Stunning Strike
my $spell_radius_close = 20; # Close range
my $spell_radius_mid = 35; # Mid range
my $spell_radius_far = 135; # Far range

sub EVENT_SPAWN {
    $npc->SetSpecialAbility(54, 1); # immune to assassinate
    $npc->SetSpecialAbility(55, 1); # immune to headshot
    $npc->SetSpecialAbility(14, 1); # immune to charm
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(90);
    }
    # Removed the health reset on combat end
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
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
        quest::setnexthpevent(30);
    } elsif ($hpevent == 30) {
        quest::settimer("CheckDistance", 60); # Adjusted to 60 seconds (1 minute)
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

        if ($aggro_target && $aggro_target->IsClient()) {
            # Ensure the aggro target is a client
            my $client_aggro_target = $aggro_target->CastToClient();
            my $distance = $npc->CalculateDistance($client_aggro_target->GetX(), $client_aggro_target->GetY(), $client_aggro_target->GetZ());

            # Cast spells on the aggro target based on distance
            if ($distance <= $spell_radius_close) {
                $npc->SpellFinished($spell_id_close, $client_aggro_target, 0, -10000);
            } elsif ($distance >= $spell_radius_mid && $distance <= $spell_radius_far) {
                $npc->SpellFinished($spell_id_mid, $client_aggro_target, 0, -10000);
            } elsif ($distance >= $spell_radius_far && $distance <= 250) {
                $npc->SpellFinished($spell_id_far, $client_aggro_target, 0, -10000);
            }

            # Handle bots for the aggro target
            my @bots = $entity_list->GetBotListByCharacterID($client_aggro_target->CharacterID());
            foreach my $bot (@bots) {
                my $bot_distance = $npc->CalculateDistance($bot->GetX(), $bot->GetY(), $bot->GetZ());
                if ($bot_distance <= $spell_radius_close && $bot != $aggro_target) {
                    $npc->SpellFinished(31222, $bot, 0, -10000); # 7k hit bot
                    if ($bot->GetPetID() > 0) {
                        my $bot_pet = $entity_list->GetNPCByID($bot->GetPetID());
                        $npc->SpellFinished(12309, $bot_pet, 0, -10000); # Stunning Pets
                        $npc->SpellFinished(3238, $bot_pet, 0, -10000); # Kill Summoned
                    }
                } elsif ($bot_distance >= $spell_radius_mid && $bot_distance <= $spell_radius_far) {
                    $npc->SpellFinished($spell_id_mid, $bot, 0, -10000);
                } elsif ($bot_distance >= $spell_radius_far && $bot_distance <= 250) {
                    $npc->SpellFinished($spell_id_far, $bot, 0, -10000);
                }
            }
        }
    }
}


sub EVENT_DEATH {
    quest::stoptimer("CheckDistance");
}
