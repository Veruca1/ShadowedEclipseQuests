sub EVENT_SPAWN {

    
    quest::settimer("breath",180);
    quest::settimer("tyranthrax",1);


}

sub EVENT_SAY {
if ($text=~/hail/i) {
    quest::debug("quest file is active");
}
}


sub EVENT_TIMER {
    $tyranthrax = $entity_list->GetMobByNpcTypeID(86176);
    $npc->SetAppearance(3);
    if ($timer eq "breath") {
        quest::emote("a strange gasp of air comes from the bones as if it is alive?");
    }
    elsif ($timer eq "tyranthrax") {
        if ($kerafyrm) {
      quest::stoptimer("tyranthrax");
      quest::stoptimer("breath");
      quest::depop_withtimer();
        }
    }
}