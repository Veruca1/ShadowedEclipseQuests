sub EVENT_SAY {
  if ($text=~/hail/i) {
    quest::say("Outlander, hail. Share the fire. I have little but if you are in need then take what I have. If you need nothing then take nothing. Balix my name is. Shaman to the tribe of Snowfangs.");
  }
  if ($text=~/shaman/i) {
    quest::say("Yes, shaman. I listen to the land to tell my tribe what the winds and waters will bring. Good or bad. Little good and much bad these days. That is why I sit here listening.");
  }
  if ($text=~/listening/i) {
    quest::say("I am on spirit quest. No food do I take. All day I listen only. I wait until the land tells me how to help my tribe. Maybe nothing will happen but I cannot fail to try. Hard is this. Many dangerous creatures are near but none come close so far.");
  }
  if ($text=~/dangerous creatures/i) {
    quest::emote("growls under his breath.");
    quest::say("Most dangerous is the Shadow Guardians. Evil spirits of the land. It was made from long dead wolf spirits when the tower spread its dark magics through the islands. It preys on the Snowfang. We have tried to hunt it but always it is too strong.");
  }
}

sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 30012 => 1)) { # Check if item 30012 is handed in
    quest::whisper("This looks to be a means of summoning a great and foul creature. I have done so, look towards the tower!");
    quest::spawn2(1616, 0, 0, 3033.50, 2249.27, 141.33, 23.75); # Spawn NPC 1616 at specified location and heading
  } elsif (plugin::check_handin(\%itemcount, 507 => 1)) { # Check if item 507 is handed in
    quest::say("Thank you, outlander. I have something for you in return.");
    quest::assigntask(30); # Assign task 30
    quest::summonitem(507); # Return item 507 to the player
  } elsif (plugin::check_handin(\%itemcount, 508 => 1)) { # Check if item 508 is handed in
    quest::whisper("You have a strange collection of rewards there. Perhaps show the bottle to Nelet Durzit over on the next island south west, near the wreckage of the Greysong.");
    quest::summonitem(508); # Return item 508 to the player
  } else {
    plugin::return_items(\%itemcount); # Return any unhandled items
  }
}
