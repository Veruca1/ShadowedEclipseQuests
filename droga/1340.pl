sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Droga exits combat, cancel all timers and stop golem spawns
        quest::stoptimer("BloodBath");
        quest::stoptimer("AxeWhirl");
        quest::stoptimer("BloodSplash");
        quest::stoptimer("GolemSpawn");
        quest::emote("Incarnate Droga stands down, awaiting the next challenger.");
        $npc->WipeHateList();
    }
}

sub EVENT_SPAWN {
    quest::settimer("BloodBath", 75);         # First cast of Blood Bath in 75 seconds
    quest::settimer("AxeWhirl", 150);         # First cast of Axe Whirl after 150 seconds
    quest::settimer("BloodSplash", 60);       # Blood Splash casts every 60 seconds
    quest::settimer("GolemSpawn", 90);        # Golem spawns every 90 seconds
}

sub EVENT_TIMER {
    if ($timer eq "BloodBath") {
        quest::emote("Incarnate Droga releases a vicious wave of blood magic!");
        $npc->CastSpell(36866, $npc->GetTarget()->GetID());  # Blood Bath
        quest::settimer("AxeWhirl", 75);  # After 75 seconds, Axe Whirl will cast
    }
    elsif ($timer eq "AxeWhirl") {
        quest::emote("Incarnate Droga spins his mighty axe furiously!");
        $npc->CastSpell(36865, $npc->GetTarget()->GetID());  # Axe Whirl
        quest::settimer("BloodBath", 75);  # Rotate back to Blood Bath
    }
    elsif ($timer eq "BloodSplash") {
        my $target = $npc->GetHateRandom();
        if ($target) {
            quest::shout("Droga's splash of blood magic wounds " . $target->GetName() . "!");
            $npc->CastSpell(36867, $target->GetID());  # Blood Splash
        }
    }
    elsif ($timer eq "GolemSpawn") {
        my $golem = quest::spawn2(1339, 0, 0, $x, $y, $z, $h);  # Spawns golem at Droga's location
        quest::settimer("GolemExplode_$golem", 40);  # Start 40-second explosion timer
    }
    elsif ($timer =~ /GolemExplode_(\d+)/) {
        my $golem_id = $1;
        my $golem_npc = $entity_list->GetNPCByID($golem_id);
        if ($golem_npc) {
            quest::shout("The golem explodes in a burst of deadly energy!");
            $npc->CastSpell(36868, $golem_npc->GetID());  # Golem's Delight Explosion
            $golem_npc->Depop(1);  # Depops the golem
        }
    }
}

sub EVENT_SIGNAL {
    if ($signal =~ /GolemKilled_(\d+)/) {
        quest::stoptimer("GolemExplode_$1");  # Stops the explosion timer if golem is killed
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Incarnate Droga has been defeated! The power in this place wanes...");
    quest::stoptimer("BloodBath");
    quest::stoptimer("AxeWhirl");
    quest::stoptimer("BloodSplash");
    quest::stoptimer("GolemSpawn");
}
