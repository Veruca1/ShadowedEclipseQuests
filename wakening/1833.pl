my $shout_75 = 0;
my $shout_50 = 0;
my $shout_25 = 0;
my $depop_triggered = 0; # Ensures depop only happens once

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("nature_blast", 50); # Timer for Nature Blast before depop
        quest::settimer("life_drain", 35);   # Optional: for another timed ability
        quest::settimer("drain_message", 35);# Optional: message sync with life drain

        # HP Events for Shouts and Depop
        $shout_75 = 0;
        $shout_50 = 0;
        $shout_25 = 0;
        $depop_triggered = 0;
        quest::setnexthpevent(75);
    }
    elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("nature_blast");
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_HP {
    if ($hpevent == 75 && !$shout_75) {
        quest::shout("The Coven has shown me the true path. The Plane of Growth no longer serves the weak. It is time for a new order.");
        $shout_75 = 1;
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50 && !$shout_50) {
        quest::shout("The Mother of All has been deceived for too long. I am the one who will reshape this realm, and you will not stop me.");
        $shout_50 = 1;
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25 && !$shout_25) {
        quest::shout("The Arm will rise, and the Plane of Growth will serve the Coven. There is no turning back now. This is the will of Nyseria.");
        $shout_25 = 1;
        quest::setnexthpevent(15);
    }
    elsif ($hpevent == 15 && !$depop_triggered) {
        quest::shout("The world is already shifting. You cannot undo what has been set in motion. Farewell, mortals. You will understand in time.");
        quest::spawn2(1753, 0, 0, $x + 5, $y, $z, $h); # Left Bramble Thorn
        quest::spawn2(1753, 0, 0, $x - 5, $y, $z, $h); # Right Bramble Thorn
        quest::depop();
        $depop_triggered = 1;
    }
}

sub EVENT_TIMER {
    if ($timer eq "nature_blast") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50; # Effect range
        my $damage_amount = 20000;

        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
    }
}
