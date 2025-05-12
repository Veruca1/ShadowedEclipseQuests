sub EVENT_SPAWN {
    $npc->SetHP(10000);  # Set NPC's hit points to 10000
    quest::settimer("special_ability", 15);  # Timer for special ability every 15 seconds
    quest::settimer("monk_ability", 30);  # Timer for monk ability every 30 seconds
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When combat starts
        quest::shout("Hahahaha, what is this?!");
        $npc->ModifyNPCStat("ac", 350);  # Increase AC to make #Echo_Bikini_Kill tougher to hit
        $npc->CastSpell(4513, $npc->GetID(), 10, 0);  # Cast Hundred Fists Discipline at the start of combat
    } elsif ($combat_state == 0) {  # When combat ends
        quest::stoptimer("special_ability");  # Stop special ability timer when combat ends
        quest::stoptimer("monk_ability");  # Stop monk ability timer when combat ends
        quest::settimer("special_ability", 15);  # Reset the special ability timer when combat ends
        quest::settimer("monk_ability", 30);  # Reset the monk ability timer when combat ends
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("I cannot believe this, no matter, Xyron has a little surprise for you!");
    quest::stoptimer("special_ability");  # Stop special ability timer on death
    quest::stoptimer("monk_ability");  # Stop monk ability timer on death
}

sub EVENT_TIMER {
    if ($npc->IsEngaged()) {  # Check if the NPC is in combat
        my $random = int(rand(3));  # Randomly choose a number from 0 to 2

        if ($timer eq "special_ability") {
           
            if ($random == 0) {
                quest::shout("Oh look, I just got faster!");
                $npc->CastSpell(4513, $npc->GetID(), 10, 0);  # Cast Hundred Fists Discipline
            } elsif ($random == 1) {
                quest::shout("Turn the other cheek? HaHAAAHhhah foolish advice!");
                $npc->CastSpell(4509, $npc->GetID(), 10, 0);  # Cast Whirlwind Discipline
            } else {
                quest::shout("I will devour you whole!");
                $npc->ModifyNPCStat("max_hp", 12000);  # Temporary increase in hit points
                quest::settimer("enrage", 60);  # Enrage timer for increased damage after 60 seconds
            }
        }

        if ($timer eq "monk_ability") {
            
            if ($npc->GetHPRatio() <= 50) {  # Use monk ability if HP is below 50%
                quest::shout("Witness the true power of a monk!");
                $npc->CastSpell(4511, $npc->GetID(), 10, 0);  # Cast Thunderkick Discipline
                quest::settimer("monk_ability", 45);  # Reset timer for monk ability every 45 seconds
            } else {
                quest::settimer("monk_ability", 30);  # Reset timer for monk ability every 30 seconds
            }
        }
    }
}

sub EVENT_HP {
    if ($npc->IsEngaged() && $npc->GetHPRatio() <= 20) {  # When HP drops to 20% and in combat
        quest::shout("Now you will see my true power!");
        $npc->CastSpell(466, $npc->GetID(), 10, 0);  # Cast Lightning Shock spell ID 466
    }
}