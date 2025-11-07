# ===========================================================
# Harbinger_Thryxia.pl
# Sebilis Custom Encounter
# - Spawns guardian adds at HP thresholds
# - Guardians attack random or top hate targets
# - Increases attack power at specific HP stages
# ===========================================================

sub EVENT_SPAWN {
    quest::setnexthpevent(90);
}

sub EVENT_AGGRO {
    quest::shout("I will seer you as I tear through you!");
    quest::settimer("burn", 30);
}

sub EVENT_HP {
    my @guardians;
    my @hates;

    # Collect random hate targets if any
    for my $i (1..8) {
        my $target = $npc->GetHateRandom();
        push(@hates, $target) if defined $target;
    }

    # === Spawn Guardians at 90%, 50%, 30% ===
    if ($hpevent == 90 || $hpevent == 50 || $hpevent == 30) {
        quest::shout("Burn them!");

        # Define guardian counts per HP stage
        my @guardian_ids;
        if ($hpevent == 90) {
            @guardian_ids = (1467) x 6;
        } elsif ($hpevent == 50) {
            @guardian_ids = (1467) x 3;
        } elsif ($hpevent == 30) {
            @guardian_ids = (1467) x 8;
        }

        # Spawn guardians and assign hate
        for my $i (0 .. $#guardian_ids) {
            my $guardian_id = $guardian_ids[$i];
            my $guardian = quest::spawn2($guardian_id, 0, 0, $x, $y, $z, 0);
            my $guardian_npc = $entity_list->GetMobID($guardian);
            next unless $guardian_npc;

            my $target = $hates[$i % @hates];
            if (defined $target) {
                $guardian_npc->CastToNPC()->AddToHateList($target, 0, 1000);
            } else {
                my $top = $npc->GetHateTop();
                $guardian_npc->CastToNPC()->AddToHateList($top, 0, 1000) if $top;
            }

            push(@guardians, $guardian_npc);
        }

        # Schedule next HP event
        quest::setnexthpevent(
            $hpevent == 90 ? 70 :
            $hpevent == 50 ? 30 :
            51
        );
    }

    # === Power Increases ===
    if ($hpevent == 70 || $hpevent == 51) {
        my $mod_min_hit = ($hpevent == 70) ? 800  : 1400;
        my $mod_max_hit = ($hpevent == 70) ? 900  : 1600;

        quest::modifynpcstat("min_hit", $mod_min_hit);
        quest::modifynpcstat("max_hit", $mod_max_hit);

        # Cast special spell at certain stages
        my $target = $npc->GetHateTop();
        if ($target) {
            $npc->CastSpell(36907, $target->GetID());  # Fire spell on main target
        }

        # Move to next event
        quest::setnexthpevent(50) if $hpevent == 51;
    }
}

sub EVENT_TIMER {
    if ($timer eq "burn") {
        my $hate = $npc->GetHateRandom();
        if ($hate) {
            $npc->SpellFinished(36908, $hate->CastToMob()); # Fire burst
        } else {
            quest::shout("I sense no one to attack!");
        }
        quest::shout("You don't stand a chance!");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Sends signal 5 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 5, 2);
}