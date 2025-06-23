my $spawned_75 = 0;
my $spawned_25 = 0;

sub EVENT_AGGRO {
    #$client->Message(14, "");
}

sub EVENT_COMBAT {
    # Check if NPC has entered combat
    if ($combat_state == 1) {
        # Start a repeating timer to check health every second
        quest::settimer("check_hp", 1);
    } else {
        # Stop the timer when combat ends
        quest::stoptimer("check_hp");
        # Reset spawn flags when combat ends
        $spawned_75 = 0;
        $spawned_25 = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_hp") {
        my $hp_ratio = $npc->GetHPRatio();

        # Spawn 1 NPC at 75% health if not already spawned
        if ($hp_ratio <= 75 && $spawned_75 == 0) {
            quest::spawn2(1521, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading());
            $spawned_75 = 1;
        }

        # Spawn 2 NPCs at 25% health if not already spawned
        if ($hp_ratio <= 25 && $spawned_25 == 0) {
            quest::spawn2(1521, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading());
            quest::spawn2(1521, 0, 0, $npc->GetX() - 5, $npc->GetY() - 5, $npc->GetZ(), $npc->GetHeading());
            $spawned_25 = 1;
        }

        # Make the NPC immune if health is below 50%
        if ($hp_ratio <= 50) {
            $npc->SetSpecialAbility(46, 1); # Ranged immunity
            #$npc->SetSpecialAbility(20, 1); # Magic immunity
            quest::stoptimer("check_hp"); # Stop further checks to prevent re-triggering
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn NPC 1524 at the specified location upon death
    my $existing = $entity_list->GetNPCByNPCTypeID(1524);
    $existing->Depop(1) if $existing;

    quest::spawn2(1524, 0, 0, 623.18, -582.32, -134.09, 379.50);
}
