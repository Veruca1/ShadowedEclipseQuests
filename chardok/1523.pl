my $spawned_80 = 0;
my $spawned_10 = 0;
my $spawned_75 = 0;
my $spawned_50 = 0;
my $spawned_25 = 0;

sub EVENT_AGGRO {
    # Uncomment if you want an aggro message
    # $client->Message(14, "You dare disturb the royal halls!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start a repeating timer to check health every second
        quest::settimer("check_hp", 1);
    } else {
        # Stop the timer and reset spawn flags when combat ends
        quest::stoptimer("check_hp");
        $spawned_80 = 0;
        $spawned_10 = 0;
        $spawned_75 = 0;
        $spawned_50 = 0;
        $spawned_25 = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_hp") {
        my $hp_ratio = $npc->GetHPRatio();

        # Spawn at 80% health if not already spawned
        if ($hp_ratio <= 80 && $spawned_80 == 0 && !npc_spawn_check(1521)) {
            quest::spawn2(1521, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading());
            $spawned_80 = 1;
        }

        # Spawn at 10% health if not already spawned
        if ($hp_ratio <= 10 && $spawned_10 == 0 && !npc_spawn_check(1521)) {
            quest::spawn2(1521, 0, 0, $npc->GetX() - 5, $npc->GetY() - 5, $npc->GetZ(), $npc->GetHeading());
            $spawned_10 = 1;
        }

        # Spawn at 75% health
        if ($hp_ratio <= 75 && $spawned_75 == 0 && !npc_spawn_check(103080)) {
            quest::spawn2(103080, 0, 0, -318.08, -610.35, -142.48, 84.50);
            $spawned_75 = 1;
        }

        # Spawn at 50% health
        if ($hp_ratio <= 50 && $spawned_50 == 0 && !npc_spawn_check(103055)) {
            quest::spawn2(103055, 0, 0, -311.64, -508.10, -143.94, 155.50);
            $spawned_50 = 1;
        }

        # Spawn at 25% health
        if ($hp_ratio <= 25 && $spawned_25 == 0 && !npc_spawn_check(103056)) {
            quest::spawn2(103056, 0, 0, -353.68, -560.25, -136.32, 131.00);
            $spawned_25 = 1;
        }

        # Make the NPC immune if health is below 15%
        if ($hp_ratio <= 15) {
            $npc->SetSpecialAbility(46, 1); # Ranged immunity
            quest::stoptimer("check_hp"); # Stop further checks to prevent re-triggering
        }
    }
}

sub npc_spawn_check {
    my $npc_id = shift;
    my @npcs = $entity_list->GetNPCList();
    foreach my $npc (@npcs) {
        if ($npc->GetNPCTypeID() == $npc_id) {
            return 1; # Found an NPC with the given ID
        }
    }
    return 0; # No NPC with the given ID found
}

sub EVENT_DEATH_COMPLETE {
    # Uncomment if you want to spawn something on death
    # quest::spawn2(1444, 0, 0, -370.09, -610.22, -131.25, 85.25);
}
