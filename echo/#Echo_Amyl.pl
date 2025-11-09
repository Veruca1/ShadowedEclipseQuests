sub EVENT_SPAWN {
    $npc->SetHP(2750000); 
    quest::settimer("special_ability", 15);  # Timer for special ability every 15 seconds
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When combat starts
        quest::shout("You dare challenge me? Prepare to face my wrath!");
        $npc->ModifyNPCStat("ac", 30000);  # Increase AC to make #Echo_Amyl tougher to hit
    } elsif ($combat_state == 0) {  # When combat ends
        quest::stoptimer("special_ability");  # Stop special ability timer when combat ends
        quest::settimer("special_ability", 15);  # Reset the timer when combat ends
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("You... may have defeated me, but the Oracle will consume you all!");
    quest::stoptimer("special_ability");  # Stop special ability timer on death
    quest::stoptimer("enrage");  # Stop enrage timer on death
}

sub EVENT_TIMER {
    if ($npc->IsEngaged()) {  # Check if the NPC is in combat
        my $random = int(rand(3));  # Randomly choose a number from 0 to 2

        if ($timer eq "special_ability") {
            if ($random == 0) {
                quest::shout("Witness the power of darkness!");
                $npc->CastSpell(40639, $npc->GetID(), 10, 0);  # Changed spell ID to 1621
            } elsif ($random == 1) {
                quest::shout("Feel the chill of despair!");
                $npc->CastSpell(42169, $npc->GetID(), 10, 0);  # Example spell ID 1647
            } else {
                quest::shout("You cannot escape my wrath!");
                $npc->ModifyNPCStat("max_hp", 4000000);  # Temporary increase in hit points
                quest::settimer("enrage", 30);  # Enrage timer for increased damage after 60 seconds
            }
        }

        if ($timer eq "enrage") {
            quest::shout("I will crush you!");
            $npc->ModifyNPCStat("damage_taken", 200);  # Increase damage taken by #Echo_Amyl
        }
    }
}

sub EVENT_HP {
    my $current_hp = $npc->GetHPRatio();
    if ($current_hp <= 20 && !defined $npc->GetSpecialAbility(648)) {  # When HP drops to 20% and special ability hasn't been used
        quest::shout("Now you face true darkness!");
        $npc->CastSpell(9414, $npc->GetID(), 10, 0);  # Example spell ID 648
    }
}