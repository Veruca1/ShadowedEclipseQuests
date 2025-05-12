sub EVENT_SPAWN {
    my @item_list = (9556, 9557, 9558, 9600, 9601, 9602, 9603, 9604, 9605, 9607, 9608, 9609, 9610, 9611, 9612, 9613, 9614, 9615, 9616, 17656, 17657, 17658, 17659, 17660, 17661, 17662, 17663, 17664, 17665, 17666, 17667);
    quest::shout("Why have I been summoned here? I may only be Xyron's pet, but your journey ends here!");
    quest::setnexthpevent(90);

    # Shuffle the item list to ensure randomness without duplicates
    my @shuffled = sort { rand() <=> rand() } @item_list;

    # Always add 1 item
    $npc->AddItem($shuffled[0]);

    # 30% chance to add a second item
    if (int(rand(100)) < 30) {
        $npc->AddItem($shuffled[1]);

        # 25% chance to add a third item
        if (int(rand(100)) < 25) {
            $npc->AddItem($shuffled[2]);

            # 15% chance to add a fourth item
            if (int(rand(100)) < 15) {
                $npc->AddItem($shuffled[3]);
            }
        }
    }
}

sub EVENT_HP {
 

    if ($hpevent == 90) {
        my $CurSize = $npc->GetSize();
        quest::emote("winces in pains and his bones break");
        quest::setnexthpevent(70);
        $npc->ChangeSize($CurSize - 1);  
        #$npc->SpellFinished(9413, $client);
        ScreamAgony();
    }
    if ($hpevent == 70) {
        my $CurSize = $npc->GetSize();
        quest::setnexthpevent(50);
        quest::emote("winces in pains and his bones break");
        $npc->ChangeSize($CurSize - 1);  
       # $npc->SpellFinished(9413, $client);
       ScreamAgony();
    }
    if ($hpevent == 50) {
        my $CurSize = $npc->GetSize();
        quest::setnexthpevent(30);
        quest::emote("winces in pains and his bones break");
        $npc->ChangeSize($CurSize - 1);  
        #$npc->SpellFinished(9413, $client);
        ScreamAgony();
    }
    if ($hpevent == 30) {
        my $CurSize = $npc->GetSize();
        quest::emote("winces in pains and his bones break");
        $npc->ChangeSize($CurSize - 2);  
        #$npc->SpellFinished(9413, $client);
        ScreamAgony();
    }

}

sub EVENT_COMBAT {


    if ($combat_state == 1) {
        quest::settimer("bonesplinter", 25);
        
        
    }
    elsif ($combat_state == 0) {
        quest::setnexthpevent(90);
        $npc->SetHP($npc->GetMaxHP());
        quest::stoptimer("bonesplinter");
        $npc->ChangeSize(7);
    }
}



sub EVENT_TIMER {


    if ($timer eq "bonesplinter") {
        my @hatelist = $npc->GetHateList();
            foreach my $n (@hatelist) {
                next unless defined $n;
                next unless $n->GetEnt();
                next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());
                $npc->SpellFinished(9412, $n->GetEnt()->CastToMob());
            }
    }


}


sub EVENT_DEATH_COMPLETE {
    
    quest::stoptimer("bonesplinter");



}

sub ScreamAgony {
    my @hatelist = $npc->GetHateList();
    foreach my $n (@hatelist) {
        next unless defined $n;
        my $ent = $n->GetEnt();
        next unless $ent;
        next unless $ent->IsClient();
        my $client = $ent->CastToClient();
        $npc->SpellFinished(9413, $client);
    }
}