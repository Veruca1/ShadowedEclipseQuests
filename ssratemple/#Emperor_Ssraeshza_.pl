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
  elsif ($timer eq "SpawnNoTargetEmp") {
    quest::stoptimer("SpawnNoTargetEmp");
    quest::spawn2(162189, 0, 0, 990.0, -325.0, 415.0, 384); # NoTarget Emperor
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
  quest::spawn2(162210,0,0,877, -326, 408,385); # NPC: A_shissar_wraith
  quest::spawn2(162210,0,0,953, -293, 404,385); # NPC: A_shissar_wraith
  quest::spawn2(162210,0,0,953, -356, 404,385); # NPC: A_shissar_wraith
  quest::spawn2(162210,0,0,773, -360, 403,128); # NPC: A_shissar_wraith
  quest::spawn2(162210,0,0,770, -289, 403,128); # NPC: A_shissar_wraith

  # Start a 10 minute timer to spawn 162065
  quest::settimer("SpawnNoTargetEmp", 600);
}

sub EVENT_SLAY {
  quest::say("Your god has found you lacking.");
}

# EOF zone: ssratemple ID: 2190 NPC: #Emperor_Ssraeshza_ (Real)