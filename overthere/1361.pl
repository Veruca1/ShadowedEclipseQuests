sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::shout("You dare face Emperor Rile? Prepare to be crushed beneath my blade and my fallen fleet!");
        quest::settimer("spell_rotation", 90);  # Timer for rotating spells every 90 seconds
        quest::settimer("marine_spawn", 80);    # Timer for summoning undead marines every 80 seconds
    } else { # Combat disengaged
        quest::stoptimer("spell_rotation");
        quest::stoptimer("marine_spawn");
        quest::shout("You flee from the wrath of Rile. Wise, but futile!");
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_rotation") {
        if (!$npc->IsEngaged()) {
            quest::stoptimer("spell_rotation");
            return;
        }
        
        # Cast rotating spells
        my $spell_id;
        if ($spell_rotation_toggle == 0) {
            $spell_id = 36873; # Wounds of the Empire (Sword of Sebilis)
            quest::shout("My blade will carve a new empire from your bones!");
            $spell_rotation_toggle = 1;
        } else {
            $spell_id = 36874; # Curse of the Drowned
            quest::shout("The spirits of my fallen fleet will drag you to the depths!");
            $spell_rotation_toggle = 0;
        }
        
        $npc->CastSpell($spell_id, $npc->GetHateTop()->GetID());
    }
    elsif ($timer eq "marine_spawn") {
        if ($npc->IsEngaged()) {
            quest::shout("My marines, arise and destroy them!");
            
            # Summon 3 to 4 undead marines
            my $num_marines = int(rand(2)) + 3; # Randomly choose between 3 and 4
            for (my $i = 0; $i < $num_marines; $i++) {
                quest::spawn2(1384, 0, 0, $x + int(rand(20)) - 10, $y + int(rand(20)) - 10, $z, $h); # Spawns around Rile
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The tides of fate... were too strong... for even me...");
    # Cleanup if necessary
    quest::stoptimer("spell_rotation");
    quest::stoptimer("marine_spawn");
}
