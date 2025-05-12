sub EVENT_COMBAT {
    if ($combat_state == 1) { # When Karatukus engages in combat
        quest::shout("Foolish invaders, you dare challenge the fury of nature itself!");
        quest::settimer("spell_rotation", 60); # Timer for rotating spells every 60 seconds
        quest::settimer("missile_spawn", 80);  # Timer for spawning Missile of Ik every 80 seconds
        $spell_rotation_toggle = 0; # Initialize spell toggle
    } else { # When combat ends
        quest::stoptimer("spell_rotation");
        quest::stoptimer("missile_spawn");
        quest::shout("Nature spares you... this time.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_rotation") {
        if (!$npc->IsEngaged()) {
            quest::stoptimer("spell_rotation");
            return;
        }
        my $spell_to_cast = ($spell_rotation_toggle == 0) ? 36871 : 36872;
        my $shout_message = ($spell_rotation_toggle == 0) ? 
            "The forest's roots will drain your strength!" : 
            "The ground trembles beneath your arrogance!";
        
        quest::shout($shout_message);
        $npc->CastSpell($spell_to_cast, $npc->GetHateTop()->GetID()); # Cast spell on top aggro player
        $spell_rotation_toggle = 1 - $spell_rotation_toggle; # Toggle between spells
    }
    elsif ($timer eq "missile_spawn") {
        if ($npc->IsEngaged()) {
            quest::shout("Feel the wrath of my ancient forces!");
            quest::spawn2(1383, 0, 0, $x, $y, $z, $h); # Spawn Missile of Ik at Karatukus's location
        }
    }
}
