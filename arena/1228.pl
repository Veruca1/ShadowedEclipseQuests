sub EVENT_SPAWN {
    # Set NPC's max health to 30,000 and start with full health
    $npc->ModifyNPCStat("max_hp", 30000);
    $npc->SetHP(30000);

    # Variables to set hp and get flag to set hp
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    
    # Check if the 60% key exists; if it doesn't, set it to 60% hp event
    if (defined(quest::get_data($hp_key)) && quest::get_data($hp_key) == 1) {
        quest::setnexthpevent(30);
        # Adjust HP if spawned with reduced health
        my $new_hp = $npc->GetMaxHP() * 0.60;
        $npc->SetHP($new_hp);
    } else {
        quest::setnexthpevent(60);
    }
}

sub EVENT_HP {
    # Handle HP event at 60%
    if ($hpevent == 60) {
        my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
        quest::set_data($hp_key, 1);

        # Get current HP percentage
        my $current_hp = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $hp_percentage = $current_hp / $max_hp;

        # Depop current NPC and spawn at new location with the same HP percentage
        quest::depop();
        my $x = 239.61;
        my $y = -9.02;
        my $z = -5.50;
        my $h = 492.75;
        my $boss_id = 1228;
        my $new_npc = quest::spawn2($boss_id, 0, 0, $x, $y, $z, $h);
        my $new_npc_entity = $entity_list->GetNPCByID($new_npc);
        if ($new_npc_entity) {
            my $new_hp = $new_npc_entity->GetMaxHP() * $hp_percentage;
            $new_npc_entity->SetHP($new_hp);
            quest::setnexthpevent(30); # Set the next HP event to 30%
        }
    }
    # Handle HP event at 30%
    elsif ($hpevent == 30) {
        # Make the NPC immune to all attacks for 10 seconds
        $npc->SetInvul(1);  # Make NPC invulnerable

        # Schedule an event to remove invulnerability after 10 seconds
        quest::settimer("remove_invul", 10);
        
        # Schedule the next HP event
        quest::setnexthpevent(10);
    }
    # Handle HP event at 10%
    elsif ($hpevent == 10) {
        # Shout message with glitchy effect
        quest::shout("dddddettoyrsddeesstory thhhmmemmm yymmyyy Beaaaaeeeaaaarrrr!...");

        # Spawn the new NPC at 10% HP
        my $npc_id = 64001;  # Replace with actual NPC ID
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_invul") {
        quest::stoptimer("remove_invul");
        $npc->SetInvul(0);  # Remove invulnerability
    }
}

sub EVENT_DEATH_COMPLETE {
    # Deletes the key on death
    my $hp_key = $npc->GetNPCTypeID() . "-60-hp";
    quest::delete_data($hp_key);
    quest::signalwith(77027, 2, 2); # Notify NPC with ID 77027 with a 2-second delay when NPC 1228 dies
    
    # Shout message on death
    quest::shout("In the end... yyyXXxxxyronnnn iwwwiiiilll rrooDeSStttrrooYyYy YuooYouuu");
}
