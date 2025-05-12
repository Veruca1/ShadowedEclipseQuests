my $spell_cast_80 = 0;
my $spell_cast_50 = 0;
my $spell_cast_30 = 0;
my $spell_cast_10 = 0;

sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178);

    # Apply buffs to NPC 44133 itself
    foreach my $spell_id (@buffs) {
        $npc->SpellFinished($spell_id, $npc);
    }
    
    # Set a timer to check health and engagement
    quest::settimer("check_health", 1);
    quest::settimer("check_engagement", 600); # 600 seconds = 10 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Entering combat
        # Reset the engagement timer when combat starts
        quest::stoptimer("check_engagement");
    } elsif ($combat_state == 0) { # Leaving combat
        # Restart the engagement timer when combat ends
        quest::settimer("check_engagement", 600); # 10 minutes
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_engagement") {
        # Check if NPC has been engaged
        if ($npc->GetHateTop() == undef) {
            # If no target (not engaged), depop the NPC
            quest::depop();
        }
    }

    if ($timer eq "check_health") {
        # Check NPC's health and cast appropriate spell
        my $health = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $health_percent = ($health / $max_hp) * 100;

        # Cast spells and perform actions based on health percentage thresholds
        if ($health_percent <= 10 && $spell_cast_10 == 0) {
            # Shout and cast Phantom Slash at 10% health
            quest::shout("Is this the real life? Is this just fantasy? Caught in a phantom's strike, escape from reality!");
            $npc->CastSpell(13979, $npc->GetID());
            $spell_cast_10 = 1;
        } elsif ($health_percent <= 30 && $spell_cast_30 == 0) {
            # Spawn Freddy's Wraith Groupies at 30% health
            quest::shout("Scaramouche, Scaramouche, will you do the Fandango? Hear my wraiths, they’re coming for you!");
            for (1..3) {
                quest::spawn2(1675, 0, 0, $x + (rand(10) - 5), $y + (rand(10) - 5), $z, $h);
            }
            $spell_cast_30 = 1;
        } elsif ($health_percent <= 50 && $spell_cast_50 == 0) {
            # Shout and cast Wraith's Howl at 50% health
            quest::shout("Scaramouche, Scaramouche, will you do the Fandango? The wraiths are here!");
            $npc->CastSpell(8603, $npc->GetID());
            $spell_cast_50 = 1;
        } elsif ($health_percent <= 80 && $spell_cast_80 == 0) {
            # Shout and cast Ghoulish Dance at 80% health
            quest::shout("Thunderbolt and lightning, very, very frightening me! (Galileo!) I’m gonna make you dance with the ghouls!");
            $npc->CastSpell(6049, $npc->GetID());
            $spell_cast_80 = 1;
        }
    }
}
