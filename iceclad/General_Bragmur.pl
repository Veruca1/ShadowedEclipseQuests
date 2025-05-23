# NPC: General Bragmur
# NPC ID: 110033
# Zone: Iceclad Ocean
# Quest: Blessed Coldain Prayer Shawl (8th shawl)
# items: 510

sub EVENT_SAY {
  if($text=~/hail/i) {
    quest::say("Please keep yer voice down I am busy here. If you do not mind I would ask that ya kindly leave.");
  }
}

sub EVENT_ITEM {
# Approved Issue Kit
  if(plugin::check_handin(\%itemcount, 510 => 1)) {
    quest::summonitem(510); # Ensures item 510 is returned to the player.
    quest::emote("begins to put the armor on, 'Finally the Dain has gotten word of my arrival here. I await his final orders before proceeding.'");
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    quest::spawn2(110118,0,0,$x,$y,$z,$h); # NPC: General_Bragmur_
    quest::depop_withtimer();
    return; # Exit the script after valid hand-in to avoid unintended behavior.
  }


  
  plugin::return_items(\%itemcount);
}
