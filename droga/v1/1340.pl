sub EVENT_SPAWN {
    quest::settimer("BloodBath", 75);         # First cast of Blood Bath in 75 seconds
    quest::settimer("AxeWhirl", 150);         # First cast of Axe Whirl after 150 seconds
    quest::settimer("BloodSplash", 60);       # Blood Splash casts every 60 seconds
    quest::settimer("GolemSpawn", 90);        # Golem spawns every 90 seconds
    quest::shout("After I defeat you, all of Kunark will be next!!");
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Droga exits combat, cancel all timers
        quest::stoptimer("BloodBath");
        quest::stoptimer("AxeWhirl");
        quest::stoptimer("BloodSplash");
        quest::stoptimer("GolemSpawn");
        quest::emote("Incarnate Droga stands down, awaiting the next challenger.");
        $npc->WipeHateList();
    } else {
        # Entering combat, start timers
        quest::settimer("BloodBath", 75);
        quest::settimer("AxeWhirl", 150);
        quest::settimer("BloodSplash", 60);
        quest::settimer("GolemSpawn", 90);
    }
}

sub EVENT_TIMER {
    if ($timer eq "BloodBath") {
        if ($npc->IsEngaged()) {
            quest::shout("Incarnate Droga releases a vicious wave of blood magic!");
            my $target = $npc->GetTarget();
            if ($target) {
                $npc->CastSpell(36866, $target->GetID());  # Blood Bath
            } else {
                #quest::shout("Blood Bath failed: No valid target.");
            }
        }
        quest::settimer("BloodBath", 75);  # Rotate back to Blood Bath
    }
    elsif ($timer eq "AxeWhirl") {
        if ($npc->IsEngaged()) {
            quest::shout("Incarnate Droga spins his mighty axe furiously!");
            my $target = $npc->GetTarget();
            if ($target) {
                $npc->CastSpell(36865, $target->GetID());  # Axe Whirl
            } else {
                #quest::shout("Axe Whirl failed: No valid target.");
            }
        }
        quest::settimer("AxeWhirl", 150);  # Rotate back to Axe Whirl
    }
    elsif ($timer eq "BloodSplash") {
        if ($npc->IsEngaged()) {
            my $target = $npc->GetHateRandom();
            if ($target) {
                quest::shout("Droga's splash of blood wounds you, " . $target->GetName() . "!");
                $npc->CastSpell(36867, $target->GetID());  # Blood Splash
            } else {
                #quest::shout("Blood Splash failed: No valid target.");
            }
        }
    }
    elsif ($timer eq "GolemSpawn") {
        if ($npc->IsEngaged()) {
            quest::spawn2(1339, 0, 0, $x, $y, $z, $h);  # Spawns golem at Droga's location
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Incarnate Droga has been defeated! The power in this place wanes...");
    quest::stoptimer("BloodBath");
    quest::stoptimer("AxeWhirl");
    quest::stoptimer("BloodSplash");
    quest::stoptimer("GolemSpawn");
}
