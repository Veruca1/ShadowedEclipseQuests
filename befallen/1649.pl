sub EVENT_SPAWN {    
    # Automatically sets the next HP event to 60%
    quest::setnexthpevent(60);  # Set the next HP event to 60%
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # NPC is in combat
        # Start a timer to cast spell every 20 seconds
        quest::settimer("cast_spell", 20);
    } else {  # NPC is out of combat
        # Stop the timer when NPC is not in combat
        quest::stoptimer("cast_spell");
    }
}

sub EVENT_HP {
    # Handle HP event at 60%
    if ($hpevent == 60) {
        # Shout message with glitchy effect at 60% HP
        quest::shout("I... c-c-cannn f-feeeel it... m-m-meow-many d-d-distracccctttionsss... i-iinnc-comminggg!");

        # Spawn 5 NPCs (ID: 1650) at the current NPC's location
        for (my $i = 0; $i < 5; $i++) {
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();
            quest::spawn2(1650, 0, 0, $x, $y, $z, $h);
        }

        # Set the next HP event to 30%
        quest::setnexthpevent(30);
    }
    # Handle HP event at 30%
    elsif ($hpevent == 30) {
        # Make the NPC immune to all attacks for 25 seconds
        $npc->SetInvul(1);  # Make NPC invulnerable

        # Schedule an event to remove invulnerability after 25 seconds
        quest::settimer("remove_invul", 25);
        
        # Schedule the next HP event
        quest::setnexthpevent(10);
    }
    # Handle HP event at 10%
    elsif ($hpevent == 10) {
        # Shout message with glitchy effect, preparing for mini-NPCs
        quest::shout("Ohhh, hhhha-ha-ha... *error*... M30w-mmmoreee l-little dissttracctions... *glitch*... pprrrepareee fo0rrrrr yourr... *crackle*... fffutillee *error* att-tttt-ttttempts... ha-ha-HA!");

        # Spawn 5 NPCs (ID: 1650) at the current NPC's location
        for (my $i = 0; $i < 5; $i++) {
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();
            quest::spawn2(1650, 0, 0, $x, $y, $z, $h);
        }
    }
}

sub EVENT_TIMER {
    # Handle invulnerability removal after 25 seconds
    if ($timer eq "remove_invul") {
        quest::stoptimer("remove_invul");
        $npc->SetInvul(0);  # Remove invulnerability
    }
    # Handle casting spell every 20 seconds
    elsif ($timer eq "cast_spell") {
        # Cast spell 40597 on the NPC
        $npc->CastSpell(40597, $npc->GetID());
    }
}

sub EVENT_DEATH_COMPLETE {
    # Deletes the key on death (if any)
    quest::delete_data($hp_key);
    
    # Shout message on death with humor about cats
    quest::shout("Nooooo... I... I thought I was the one to rule... like... like a cat... *glitchy meow*... Guess not, h3h... maybe next ttttime...");

    # Send signal to NPC 1427 (ID 10) to start the port timer (signal value = 1)
    quest::signalwith(1427, 1, 0);  # Using signalwith with a delay of 0 (immediate execution)
}
