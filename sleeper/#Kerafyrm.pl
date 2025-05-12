sub EVENT_SPAWN {
  quest::shout("Time to slay!");
  quest::setglobal("kerafyrm",1,7,"F");
  quest::spawn_condition(sleeper,2,1);
  quest::spawn_condition(sleeper,1,0);
  quest::forcedooropen(46);
  quest::settimer("depop",1);
}

sub EVENT_TIMER {
 if($timer eq "depop"){
  if($x == -675){
   quest::spawn2(128095,2,0,1014,-981,-125,0); # NPC: #Kerafyrm_
   quest::spawn2(1848,0,0,-1068.86, -2304.52, -990.15, 262.25);
   quest::spawn2(1849,0,0,-1069.52, -2516.21, -990.16, 3.00);
   quest::stoptimer("depop");   
   quest::depop();
  }
 }
}

sub EVENT_SLAY {
  quest::shout("Begone insect, I have much slaying yet to do!");
}

sub EVENT_NPC_SLAY {
  quest::shout("Begone insect, I have much slaying yet to do!");
}

sub EVENT_DEATH_COMPLETE { #nearly forgot about this hehe
  quest::setglobal("kerafyrm",3,7,"F"); 
  quest::stoptimer("depop");   
  quest::depop();
}