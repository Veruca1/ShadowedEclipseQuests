sub EVENT_SIGNAL {
    my $npcid = $npc->GetID();

    if ($signal == 1) {
        quest::shout("So... you’ve come. The mortal who walks Nyseria’s whispers like a tightrope.");
        quest::settimer("shout2_$npcid", 7);
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
    }
}