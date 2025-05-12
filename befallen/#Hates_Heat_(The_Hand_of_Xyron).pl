sub EVENT_SPAWN {
    # sets first event
    quest::setnexthpevent(70);
    # set depop timer
    quest::settimer("depop_me", 1800);
    $npc->SetInvul(0);
    $npc->SetDisableMelee(0);
    # casts spell 17852 on self with no cast time
    quest::selfcast(17852);
}

sub EVENT_HP {
    # First HP check at 70%
    if ($hpevent == 70) {
        quest::setnexthpevent(40);
        # signals with mob to spawn elementals
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("Hahaha think you can stop me? I will suck the life out of the elements and destroy you all!");
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
    }
    # Second HP check at 40%
    elsif ($hpevent == 40) {
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::setnexthpevent(15);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("You are stronger than I thought! Arghhhhhh!");
    }
    # Third HP check at 15%
    elsif ($hpevent == 15) {
        $npc->SetInvul(1);
        $npc->SetDisableMelee(1);
        quest::modifynpcstat("runspeed", 0);
        quest::signalwith(502004, 1, 0);
        quest::settimer("defeat_minions", 40);
        quest::shout("No, hate..must..prevail...one last time!");
    }
}

sub EVENT_TIMER {
    if ($timer eq "defeat_minions") {
        quest::shout("Arrrrggghh Feel the heat of hate consume you!");
        # grabs everyone on the hate list and nukes them
        my @hatelist = $npc->GetHateList();
        foreach my $n (@hatelist) {
            next unless defined $n;
            next unless $n->GetEnt();
            next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());
            $npc->SpellFinished(25554, $n->GetEnt()->CastToMob());
        }
        # depops all elementals
        my @depop_list = (502000..502003);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
        # stops all timers
        quest::stoptimer("defeat_minions");
    }
    elsif ($timer eq "depop_me") {
        quest::depop(36126);
        # depops all elementals
        my @depop_list = (502000..502004);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
        quest::stopalltimers();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Add combat entry logic if needed
    }
    elsif ($combat_state == 0) {
        $npc->SetInvul(0);
        $npc->SetDisableMelee(0);
        quest::setnexthpevent(70);
        $npc->SetHP($npc->GetMaxHP());
        my @depop_list = (502000..502003);
        foreach my $npc_id (@depop_list) {
            quest::depop($npc_id); 
        }
    }
}

sub EVENT_SIGNAL {
    my $earth_check = $entity_list->GetMobByNpcTypeID(502000);
    my $water_check = $entity_list->GetMobByNpcTypeID(502002);
    my $fire_check = $entity_list->GetMobByNpcTypeID(502003);
    my $air_check = $entity_list->GetMobByNpcTypeID(502001);

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
    quest::shout("I shall return!");
    quest::depop(502004);
    quest::stopalltimers();
}