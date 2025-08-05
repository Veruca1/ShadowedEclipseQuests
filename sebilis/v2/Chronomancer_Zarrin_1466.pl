sub EVENT_SPAWN {
    # List of spells to cast as buffs
    my @buffs = (21941, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each spell as a buff on spawn
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer for recasting the buffs
    quest::settimer("recast_buffs", 90);  # Adjust the timer as necessary

    # Set the first HP event trigger
    quest::setnexthpevent(70);

    # Set depop timer
    quest::settimer("depop_me", 3600);  # Depop after 60 minutes

    # Initial shout on spawn
    quest::shout("Well it has finally come down to this, it's been interesting seeing you rise to a fraction of what you were to become. But it all changes here!");

    # Ensure the NPC starts vulnerable and able to melee
    $npc->SetInvul(0);
    $npc->SetDisableMelee(0);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start the timer for casting spell 36932 every 50 seconds
        quest::settimer("cast_spell_36932", 50);
        # Spawn NPC 1436 every 60 seconds during combat
        quest::settimer("spawn_npc_1436", 60);
    }
    elsif ($combat_state == 0) {
        # Stop casting spell 36932 and spawning NPC when combat ends
        quest::stoptimer("cast_spell_36932");
        quest::stoptimer("spawn_npc_1436");
        $npc->SetInvul(0);
        $npc->SetDisableMelee(0);
        quest::setnexthpevent(70);
        $npc->SetHP($npc->GetMaxHP());
        my @depop_list = (1468..1471);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell_36932") {
        # Cast spell 36932 on the NPC itself every 50 seconds during combat
        quest::castspell(36932, $npc->GetID());
    }
    elsif ($timer eq "spawn_npc_1436") {
        # Spawn NPC ID 1436 at the NPC's location
        quest::spawn2(1436, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1436, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
    elsif ($timer eq "defeat_minions") {
        quest::shout("This is the end mortal!");
        # Grab everyone on the hate list and cast Zarrin's Heat (36912) on them
        my @hatelist = $npc->GetHateList();
        foreach my $n (@hatelist) {
            next unless defined $n;
            next unless $n->GetEnt();
            next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());
            $npc->SpellFinished(36912, $n->GetEnt()->CastToMob()); # Zarrin's Heat spell ID 36912
        }
        # Depop all elementals
        my @depop_list = (1468..1471);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
        # Stop the timer
        quest::stoptimer("defeat_minions");
    }
    elsif ($timer eq "depop_me") {
        quest::depop(1466);  # Updated to 1466
        # Depop all elementals
        my @depop_list = (1468..1471, 502004);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
        quest::stopalltimers();
    }
}

sub EVENT_HP {
    # First HP check at 70%
    if ($hpevent == 70) {
        quest::setnexthpevent(40);
        # Signals minion spawn
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 2);
        quest::settimer("defeat_minions", 40);
        quest::shout("Here is a review of your history lesson!");
        $npc->SetInvul(0);
        $npc->SetDisableMelee(1);
    }
    # Second HP check at 40%
    elsif ($hpevent == 40) {
        $npc->SetInvul(0);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::setnexthpevent(15);
        quest::signalwith(502004, 1, 2);
        quest::settimer("defeat_minions", 40);
        quest::shout("You've been paying attention, impressive");
    }
    # Third HP check at 15%
    elsif ($hpevent == 15) {
        $npc->SetInvul(0);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 2);
        quest::settimer("defeat_minions", 40);
        quest::shout("Enough of this, destroy him!");
    }
}

sub EVENT_AGGRO {
    # Get a list of all clients (players) in the NPC's proximity
    my @clients = $entity_list->GetClientList();

    # Loop through each player and cast spell 36905
    foreach my $client (@clients) {
        quest::castspell(36905, $client->GetID());
    }
}

sub EVENT_SIGNAL {
    my $earth_check = $entity_list->GetMobByNpcTypeID(1468);
    my $water_check = $entity_list->GetMobByNpcTypeID(1470);
    my $fire_check = $entity_list->GetMobByNpcTypeID(1471);
    my $air_check = $entity_list->GetMobByNpcTypeID(1469);

    if ($signal == 101 && !$earth_check && !$water_check && !$fire_check && !$air_check) {
        quest::stoptimer("defeat_minions");
        $npc->SetInvul(0);
        $npc->SetDisableMelee(0);
        quest::modifynpcstat("runspeed", 1.5);   
    } else {
        quest::stoptimer("defeat_minions");
        quest::settimer("defeat_minions", 40);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("This cannot be!!!! You may think you have won, but I left you a little parting gift if you can find it!");
    
    quest::stopalltimers();
}
