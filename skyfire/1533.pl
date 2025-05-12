sub EVENT_SPAWN {
   quest::shout("You have spun the globes, and removed the veil, well here I am!");
   quest::settimer(2,900);
   }

sub EVENT_DEATH_COMPLETE {
   quest::shout("Good luck in there, you're going to need it, but it won't help!");
   }

sub EVENT_TIMER {
   if($timer == 2) {
     quest::stoptimer(2);
     quest::setglobal(dragon_not_ready,1,3,"H1");
     quest::depop();
     }
}