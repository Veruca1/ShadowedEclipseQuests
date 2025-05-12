# NPC ID: 1399
sub EVENT_SPAWN {
    quest::shout("The depths of Ill Omen Lake will not allow any more intruders! We will not let the likes of Garudon ruin Veksar again!");
    quest::setnexthpevent(50);  # Trigger next HP event at 50%
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Entering combat
    } elsif ($combat_state == 0) {  # Exiting combat
        quest::settimer("reset_hp_event", 30);
    }
}

sub EVENT_TIMER {
    if ($timer eq "reset_hp_event") {
        quest::setnexthpevent(50);
        quest::stoptimer("reset_hp_event");
    }
}

sub EVENT_HP {
    # HP check at 50%
    if ($hpevent == 50) {
        quest::shout("Minions of the lake, arise and assist me!");

        # Check for minions in the zone and aggro them to the current target
        my @minion_ids = (85047, 85048, 85053, 85057, 85058, 85068, 85206);
        my @minions = $entity_list->GetNPCList();
        my $top_hate_target = $npc->GetHateTop();

        if ($top_hate_target) {  # Ensure there is a valid target
            foreach my $minion (@minions) {
                if ($minion->GetNPCTypeID() ~~ @minion_ids) {
                    # Add the top hate target to the minion's hate list
                    $minion->AddToHateList($top_hate_target, 1);  # Reduced arguments to valid overload
                }
            }
        }
    }
}


sub EVENT_DEATH_COMPLETE {
    quest::shout("The depths have claimed me...");
}
