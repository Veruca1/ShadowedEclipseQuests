#BEGIN File: ssratemple\#Emperor_Ssraeshza_.pl (Real)

my $engaged;

sub EVENT_SPAWN {
  $engaged = 0;
  quest::settimer("EmpDepop", 1800);
}

sub EVENT_TIMER {
  if ($timer eq "EmpDepop") {
    quest::stoptimer("EmpDepop");
    #quest::signalwith(162260,3,0); #EmpCycle
    quest::depop();
  }
}

sub EVENT_COMBAT {
  if (($combat_state == 1) && ($engaged == 0)) {
    quest::settimer("EmpDepop", 2400);
    $engaged = 1;
  }
}
  
sub EVENT_DEATH_COMPLETE {
    quest::emote("'s corpse says 'How...did...ugh...'");

    # Spawn 162189 if not already up
    if (!$entity_list->GetMobByNpcTypeID(162189)) {
        quest::spawn2(162189, 0, 0, 877, -326, 408, 385);
    }

    # Spawn supporting wraiths
    quest::spawn2(162210, 0, 0, 953, -293, 404, 385);
    quest::spawn2(162210, 0, 0, 953, -356, 404, 385);
    quest::spawn2(162210, 0, 0, 773, -360, 403, 128);
    quest::spawn2(162210, 0, 0, 770, -289, 403, 128);
}

sub EVENT_SLAY {
  quest::say("Your god has found you lacking.");
}

# EOF zone: ssratemple ID: 2190 NPC: #Emperor_Ssraeshza_ (Real)