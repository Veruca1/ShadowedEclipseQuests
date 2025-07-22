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
        # Check if NPC has been out of combat
        if ($npc->GetHateList()->IsEmpty()) {
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
            # Shout and cast Right Hook (40278) at 10% health
            quest::shout("Right Hook!");
            $npc->CastSpell(40278, $npc->GetID());
            $spell_cast_10 = 1;
        } elsif ($health_percent <= 30 && $spell_cast_30 == 0) {
            # Spawn 3 Glass Groupies (NPC ID: 1673) at 30% health
            quest::shout("The Glass Groupies have arrived!");
            for (1..3) {
                quest::spawn2(1673, 0, 0, $x + (rand(10) - 5), $y + (rand(10) - 5), $z, $h);
            }
            $spell_cast_30 = 1;
        } elsif ($health_percent <= 50 && $spell_cast_50 == 0) {
            # Shout and cast Upper Cut (12693) at 50% health
            quest::shout("Upper Cut!");
            $npc->CastSpell(12693, $npc->GetID());
            $spell_cast_50 = 1;
        } elsif ($health_percent <= 80 && $spell_cast_80 == 0) {
            # Shout and cast Gut Punch (12802) at 80% health
            quest::shout("Body Blow!");
            $npc->CastSpell(12802, $npc->GetID());
            $spell_cast_80 = 1;
        }
    }
}