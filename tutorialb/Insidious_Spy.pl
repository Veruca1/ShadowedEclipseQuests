# NPC: Insidious_Spy
# Veruca

sub EVENT_COMBAT{
   quest::emote("looks at you with disbelief, sparks begin to crackle!");
}

sub EVENT_DEATH_COMPLETE{
  quest::shout("You may have bested me, but our agents are everywhere, be warned!.");
 }

# EOF zone: Tutorialb