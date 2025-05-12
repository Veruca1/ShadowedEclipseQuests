sub EVENT_SPAWN {
    # Move the NPC to the specified location immediately upon spawning
    $npc->MoveTo(-2.15, -250.29, -5.50, 0.00, 1);
    
    # Schedule shout and camera effect after the NPC has moved
    quest::settimer("shout_and_effect", 1);
    quest::settimer("depop_me", 1800);
    
    # Make sure the NPC is not invulnerable
    $npc->SetInvul(0);
    $npc->SetDisableMelee(0);
    
    # Casts spell 17852 on self with no cast time
    quest::selfcast(17852);
}

sub EVENT_TIMER {
    if ($timer eq "shout_and_effect") {
        quest::shout("We meet again mortal! I said I'd be back. Hahahahaha!");
        $npc->CameraEffect(3000, 6);  # Screen shake effect
        quest::stoptimer("shout_and_effect");
    }
    elsif ($timer eq "depop_me") {
        quest::depop(36126);
        quest::stopalltimers();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Reset HP when out of combat
        $npc->SetHP($npc->GetMaxHP());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Graaaahhhhh!!!!!!  Here's a parting gift from Master Xyron!");
    quest::spawn2(1237, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());  # Spawns NPC ID 1237 at the current location of the dying NPC
    quest::depop(502004);
    quest::stopalltimers();
}