sub EVENT_SPAWN {
    $npc->SetHP(21000);  # Set NPC's hit points to 21000
    $npc->ModifyNPCStat("max_hp", 21000);  # Ensure the max HP is set to 21000
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
    quest::signalwith(77027, 8, 2);  # Notify NPC with ID 77027 with a 2-second delay when NPC Echo_Bikini_Kill dies
    quest::stoptimer("special_ability");  # Stop special ability timer on death
    quest::stoptimer("monk_ability");  # Stop monk ability timer on death

    # Get the x, y, z coordinates of where the named NPC died
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $killer_id = $entity_list->GetMobByID($killer_id);  # Get the entity that killed the named NPC

    # Number of NPCs to spawn (between 6 and 8)
    my $num_npcs = quest::ChooseRandom(6, 7, 8);

    for (my $i = 0; $i < $num_npcs; $i++) {
        # Generate random offset within 60 units
        my $offset_x = quest::ChooseRandom(-60..60);
        my $offset_y = quest::ChooseRandom(-60..60);
        my $spawn_x = $x + $offset_x;
        my $spawn_y = $y + $offset_y;
        my $spawn_z = $z;

        # Spawn the NPC (ID 1246 is the Avenging Echo)
        my $new_npc = quest::spawn2(1246, 0, 0, $spawn_x, $spawn_y, $spawn_z, 0);

        # Make the new NPC attack the killer
        my $npc = $entity_list->GetMobByID($new_npc);
        if ($npc && $killer_id) {
            $npc->AddToHateList($killer_id, 1);
        }
    }
}

sub EVENT_TIMER {
    if ($npc->IsEngaged()) {  # Check if the NPC is in combat
        my $random = int(rand(3));  # Randomly choose a number from 0 to 2

        if ($timer eq "special_ability") {
            quest::shout("Special ability timer fired!");  # Debug message to ensure timer is working
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
            quest::shout("Monk ability timer fired!");  # Debug message to ensure timer is working
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
