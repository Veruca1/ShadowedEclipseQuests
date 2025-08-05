sub EVENT_SPAWN {
    quest::setnexthpevent(90);    
}

sub EVENT_AGGRO {
    quest::shout("I will seer you as I tear through you!");
    quest::settimer(1, 30);
}

sub EVENT_HP {
    my @guardians;
    my @hates;
    
    # Assign random hate targets
    for my $i (1..8) {
        push(@hates, $npc->GetHateRandom());
    }

    if ($hpevent == 90 || $hpevent == 50 || $hpevent == 30) {
        quest::shout("Burn them!");

        # Spawn guardians based on the HP event
        my @guardian_ids;
        if ($hpevent == 90 || $hpevent == 30) {
            @guardian_ids = (1467, 1467, 1467, 1467, 1467, 1467);
            push(@guardian_ids, 1467, 1467) if $hpevent == 30;
        } elsif ($hpevent == 50) {
            @guardian_ids = (1467, 1467, 1467);
        }

        # Spawn and make the guardians attack
        for my $i (0..$#guardian_ids) {
            my $guardian = quest::spawn2($guardian_ids[$i], 0, 0, $x, $y, $z, 0);
            my $guardian_npc = $entity_list->GetMobID($guardian)->CastToNPC();
            if ($guardian_npc) {
                $guardian_npc->AddToHateList($hates[$i % @hates], 1);
                push(@guardians, $guardian_npc);
            }
        }

        # Set the next HP event
        quest::setnexthpevent($hpevent == 90 ? 70 : ($hpevent == 50 ? 30 : 51));
    }

    if ($hpevent == 70 || $hpevent == 51) {
        my $mod_min_hit = ($hpevent == 70) ? 800 : 1400;  # Increased min/max hit values
        my $mod_max_hit = ($hpevent == 70) ? 900 : 1600;  # Adjusted for higher damage

        quest::modifynpcstat("min_hit", $mod_min_hit);
        quest::modifynpcstat("max_hit", $mod_max_hit);

        if ($hpevent == 70 || $hpevent == 30) {
            $npc->CastSpell(36907, $mobid, 10, -1);  # Cast spell at 70% or 30%
        }

        quest::setnexthpevent(50) if $hpevent == 51;
    }
}

sub EVENT_TIMER {
    if ($timer == 1) {
        my $hate = $npc->GetHateRandom();
        if ($hate) {  # Check if hate is defined
            $npc->SpellFinished(36908, $hate->CastToMob()); # Only call CastToMob if $hate is defined
        } else {
            quest::shout("I sense no one to attack!");  # Optional debug message
        }
        quest::shout("You don't stand a chance!");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Sends signal 5 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 5, 2);
}
