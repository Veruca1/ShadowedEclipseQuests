sub EVENT_SPAWN {
    # Automatically sets the next HP event to 20%
    quest::setnexthpevent(20);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("drain_cooldown", 1); # Start the initial cooldown timer
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");       # Stop life drain
        quest::stoptimer("drain_cooldown");   # Stop cooldown timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "drain_cooldown") {
        quest::settimer("life_drain", 1);     # Start life drain every second
        quest::stoptimer("drain_cooldown");   # Stop cooldown timer
        quest::settimer("drain_duration", 10); # Life drain lasts for 10 seconds

        # Notify players
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The Rockin' Raven swoops in with a squawk, draining your energy with every beat of its wings!");
        }
    } 
    elsif ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around the NPC

        # Drain 500 HP per second from players within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 500, 0, 1, false); # Damage without hate list modification
            }
        }
    } 
    elsif ($timer eq "drain_duration") {
        quest::stoptimer("life_drain");       # Stop the life drain timer
        quest::settimer("drain_cooldown", 30); # Start the cooldown timer for 30 seconds
        quest::stoptimer("drain_duration");  # Stop the drain duration timer

        # Notify players after draining ends
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "With a triumphant caw, the Rockin' Raven pauses its draining rhythm. But beware—it's only catching its breath!");
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 20) {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $npc_heading = $npc->GetHeading();

        # Spawn 10 Blood Ravens (NPC ID 207030) around the current location
        for (my $i = 0; $i < 10; $i++) {
            quest::spawn2(207030, 0, 0, $npc_x + int(rand(10)) - 5, $npc_y + int(rand(10)) - 5, $npc_z, $npc_heading);
        }

        # Prevent further HP event triggers
        quest::setnexthpevent(0);
    }
}
