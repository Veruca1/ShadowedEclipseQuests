sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 636 => 1)) { # Check if item 636 is handed in
    quest::enabletitle(403); # Enable the title "Newbie No More"
    quest::we(13, "$name has defeated the tutorial, and earned the title Newbie No More!"); # Announce title in orange
    quest::discordsend("titles", "$name has earned the title of Newbie No More!");

  }
  plugin::return_items(\%itemcount); # Return any unused items
}