# Zone: Iceclad Ocean
# Short Name: iceclad
# Zone ID: 110
#
# NPC Name: Captain Nalot
# NPC ID: 110069
# Quest Status: Customized

sub EVENT_SAY {
  if ($text=~/hail/i) {
    quest::emote("squints at you through one eye, the other covered by a metallic eyepatch.");
    quest::say("Garrr. What `ave we here? Another beller yellied land blubber, eh? By the looks of ye, someones mudder didn't know when ta throw a bad fish back. HAR HAR!");
  }
  if ($text=~/bad fish/i) {
    quest::say("That means I'm callin ya ugly as a piece o' whale blubber but twice as bad smellin, ya son of a water treadin $race.");
  }
  if ($text=~/boat/i) {
    quest::say("'Arrrr. So we ain't got a boat right now. What's that got ta do with anythin'? Just cause we ain't got a boat, or a way to sail the waters, don't mean we ain't crusty and dangerous. Watch yerself, cause we're mean!");
  }
  if ($text=~/mean/i) {
    quest::say("Thats right! We're mean, nasty, devious 'n cruel. We'll knock ya down, bite yer knees, and steal yer money. Arrr. We won't always say please and thank you either!");
  }
}

sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 52340 => 1)) { # Lump of Alloy
    quest::emote("adjusts his eyepatch and squints at the lump. 'Arrr, this here is what I be needin'! Ye've done it, $name! The Polar Kraken's wrath be no match for ye!'");
    quest::say("Take this here tattered pirate's cape as a token of yer bravery. Now, hop on over to the next island and find Balix Misteyes. Show 'im this cape and he'll guide ye further!");
    quest::summonitem(507); # Old Tattered Pirate's Cape
    quest::exp(50000);
  } else {
    plugin::return_items(\%itemcount);
  }
}
