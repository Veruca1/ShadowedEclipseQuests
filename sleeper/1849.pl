sub EVENT_SIGNAL {
    if ($signal == 1) {
	quest::shout("I got this!");
        $npc->WipeHateList();
        $npc->SetNPCFactionID(623);        
        $npc->SetSpecialAbility(24, 0);
        $npc->SetSpecialAbility(25, 0);
        $npc->SetSpecialAbility(35, 0);        
        $npc->SetInvul(0);
    }
    elsif ($signal == 2) {
        $npc->WipeHateList();
        $npc->SetNPCFactionID(0);        
        $npc->SetSpecialAbility(24, 1);
        $npc->SetSpecialAbility(25, 1);
        $npc->SetSpecialAbility(35, 1);
        $npc->SetInvul(1);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 11);
}
