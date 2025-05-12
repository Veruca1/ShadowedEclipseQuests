# NPC: Insidious_Cloak
# Veruca

sub EVENT_COMBAT{
   quest::emote("looks at you with disbelief, he begins to sharpen his dagger!");
}

sub EVENT_DEATH_COMPLETE{
  quest::shout("You may have bested me, but one of our toughest agents awaits you, be warned!.");
 }

# EOF zone: befallen