sub EVENT_SPAWN {
    quest::start(39); # Grid ID 39
    $npc->SetAppearance(1); # Make NPC invisible on spawn
    quest::settimer("invisible_check", 6); # Check invisibility every 6 seconds
    quest::setnexthpevent(70); # Set the first HP event
    $npc->ModifyNPCStat("max_hp", 20000); # Set max HP to 20,000
    $npc->SetHP(20000); # Set current HP to 20,000(heals mob to max HP)
}

sub EVENT_TIMER {
    if ($timer eq "invisible_check") {
        if ($npc->IsInvisible()) {
            $npc->SetAppearance(0); # Make NPC visible
        }
        quest::stoptimer("invisible_check");
    }
}

sub EVENT_WAYPOINT_ARRIVE {
    # Optional: Add actions upon arriving at a waypoint
    if ($wp == 2) {
        quest::emote("arrives at another part of her domain.");
    }
    elsif ($wp == 5) {
        quest::emote("whispers softly as she moves forward.");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        $npc->SetAppearance(1); # Make NPC invisible during combat
        $npc->Shout("Pitiful mortals! I am a herald of hate and the dark lord Chronomancer Zarrin! Witness the power of the Plane of Hate!");
        $npc->ModifyNPCStat("ac", 300);  # Increases AC temporarily
        #$npc->ModifyNPCStat("regen_rate", 40);  # Temporarily increases regeneration
        $npc->ModifyNPCStat("attack_speed", 50);  # Temporarily increases attack speed
    }
    elsif ($combat_state == 0) {
        $npc->SetAppearance(0); # Make NPC visible after combat
        $npc->Shout("The echoes of hate... they fade away...");
        $npc->ModifyNPCStat("ac", 150);  # Resets AC back to original value
      #  $npc->ModifyNPCStat("regen_rate", 10);  # Resets regeneration back to original value
        $npc->ModifyNPCStat("attack_speed", 100);  # Resets attack speed back to original value
    }
}

sub EVENT_HP {
    if ($hpevent == 70) {
        quest::setnexthpevent(40);
        $npc->Shout("Feel the wrath of the Plane of Hate!");
        $npc->ModifyNPCStat("ac", 300);  # Increases AC
        #$npc->ModifyNPCStat("regen_rate", 40);  # Increases regeneration
        $npc->ModifyNPCStat("attack_speed", 50);  # Increases attack speed
    }
    elsif ($hpevent == 40) {
        quest::setnexthpevent(10);
        $npc->Shout("Hate shall consume you!");
        $npc->ModifyNPCStat("ac", 350);  # Further increases AC
       # $npc->ModifyNPCStat("regen_rate", 50);  # Further increases regeneration
        $npc->ModifyNPCStat("attack_speed", 40);  # Further increases attack speed
    }
    elsif ($hpevent == 10) {
        $npc->ModifyNPCStat("ac", 400);  # Further increases AC
      #  $npc->ModifyNPCStat("regen_rate", 60);  # Further increases regeneration
        $npc->ModifyNPCStat("attack_speed", 30);  # Further increases attack speed
        $npc->ModifyNPCStat("runspeed", 0);  # Prevents fleeing
    }
}

sub EVENT_KILLED_CLIENT {
    quest::we(15, "Man Down!");
}

sub EVENT_DEATH_COMPLETE {
    quest::emote("screams as the forces of hate consume her...");
}