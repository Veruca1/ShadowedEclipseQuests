sub EVENT_SIGNAL {
    my $npcid = $npc->GetID();

    if ($signal == 1) {
        quest::shout("So... you’ve come. The mortal who walks Nyseria’s whispers like a tightrope.");
        quest::settimer("shout2_$npcid", 7);
    }
    elsif ($signal == 500) {
        if (!quest::isnpcspawned(1938)) {
            quest::spawn2(1938, 0, 0, 338.67, -337.53, -59.20, 448.25);
        }
    }
    elsif ($signal == 600) {
        if (!quest::isnpcspawned(1939)) {
            quest::spawn2(1939, 0, 0, 1260.49, 873.12, -61.22, 111.75);
        }
    }
    elsif ($signal == 700) {
        if (!quest::isnpcspawned(1940)) {
            quest::spawn2(1940, 0, 0, 2685.94, -1016.83, -52.28, 383.75);
        }
    }    
}

sub EVENT_TIMER {
    my $npcid = $npc->GetID();

    if ($timer eq "shout2_$npcid") {
        quest::shout("She speaks of you with something dangerously close to admiration.");
        quest::stoptimer("shout2_$npcid");
        quest::settimer("shout3_$npcid", 7);
    }
    elsif ($timer eq "shout3_$npcid") {
        quest::shout("But I am not so easily swayed. I’ve seen champions rise—only to drown in their own ambition.");
        quest::stoptimer("shout3_$npcid");
        quest::settimer("shout4_$npcid", 7);
    }
    elsif ($timer eq "shout4_$npcid") {
        quest::shout("Still, I am bound to her will… and she wishes for you to be tested.");
        quest::stoptimer("shout4_$npcid");
        quest::settimer("shout5_$npcid", 7);
    }
    elsif ($timer eq "shout5_$npcid") {
        quest::shout("Come then, child of defiance. Let us not waste what little time the moons grant us.");
        quest::stoptimer("shout5_$npcid");

        if (!quest::isnpcspawned(1938)) {
            quest::spawn2(1938, 0, 0, 338.67, -337.53, -59.20, 448.25);
        }
        if (!quest::isnpcspawned(1939)) {
            quest::spawn2(1939, 0, 0, 1260.49, 873.12, -61.22, 111.75);
        }
        if (!quest::isnpcspawned(1940)) {
            quest::spawn2(1940, 0, 0, 2685.94, -1016.83, -52.28, 383.75);
        }
    }
} 