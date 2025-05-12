sub EVENT_SAY {
  if ($text=~/hail/i) {
    quest::say("Don't bother me, I'm uh, I'm thinking");
  }
  if ($text=~/I like the tin man/i) {
    quest::say("Yeah");
  }
}

sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 508 => 1)) { # Check if item 508 is handed in
    quest::whisper("Thank you for showing me your rewards thus far. I heard rumors of something similar, but I first need you to help me rid this area of some of the nearby creatures.");
    quest::assigntask(31); # Assign task 31 to the player
    quest::summonitem(508); # Return item 508 to the player
  }
  elsif (plugin::check_handin(\%itemcount, 509 => 1)) { # Check if item 509 is handed in
    quest::whisper("Thank you so much for your help. Now, about that other item, rumor has it that it can be found somewhere in Iceclad but it is too deadly to even attempt. You may want to ask Vas Thorel to the south, he is a collector of strange items. Tell him I sent ye, show him the certificate.");
    quest::summonitem(509); # Return item 509 to the player
  }
  else {
    plugin::return_items(\%itemcount); # Return any unhandled items
  }
}
