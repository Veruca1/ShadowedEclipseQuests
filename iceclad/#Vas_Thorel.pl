sub EVENT_SAY {
  if ($text=~/hail/i) {
    quest::whisper("Do not pester me right now unless you have something for me to inspect.");
  }
}

sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 509 => 1)) { # Check if item 509 is handed in
    quest::whisper("I have heard of the item of which Nelet speaks. It is in the possession of a very powerful frost giant however. Give this to General Bragmur to the north, he should be able to help you out. Once you get the final piece, combine them in your locker kit, and hand to me for inspection. I will want your collection if it is pristine. As a reward, I can offer you a key to that wretched tower to the north east.");
    #quest::summonitem(509); # Return item 509 to the player
    quest::summonitem(510); # Give item 510 to the player
  } elsif (plugin::check_handin(\%itemcount, 511 => 1)) { # Check if item 511 is handed in
    quest::whisper("Show this key to Masurt at the docks.");
    quest::summonitem(512); # Give item 512 to the player
  } else {
    plugin::return_items(\%itemcount); # Return any unhandled items
  }
}
