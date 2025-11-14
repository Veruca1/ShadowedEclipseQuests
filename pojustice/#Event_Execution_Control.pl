##Event_Execution_Control.pl
#Trial of Execution
#Modified from Wiz's version by Kilelen

#########################################################################################################################################
#   
#   Modified by greenbean 03/23/2010
#   
#   Notes:
#   Group is teleported to trial area
#   A maximum of 6 players are put on 'allow' list
#   Those on list may return to trial area as long as 1 person remains in area (ex. LD or death)
#   Anyone not on 'allow' list is ejected
#   Wave 1 begins after 30s Prep Time
#   Wave 2 begins 170s after wave 1 started
#   Wave 3 begins 165s after wave 2 started
#   Wave 4 begins 160s after wave 3 started
#   Killing faster results in more time to rest between waves
#   Time until Executioner kills prisoner:
#   wave1: 34s
#   wave2: 33s
#   wave3: 32s
#   wave4: 30s
#   Boss spawns on stage immediately after killing the final mob of wave 4
#   When trial is over, players have 15m to leave the trial area or be ejected
#   After killing the boss the trial locks for 20m after the last person leaves trial area. (max 35m wait depending when players exit)
#   On failure the trial is available immediately after the last person leaves trial area.
#   When area is clear players corpses move to graveyard (optional) and mob corpses are deleted.
#
##########################################################################################################################################

my $allow_entry = 0;   
my @trial_group = ();       #who is currently in the trial
my @allowed = ();       #who is allowed back in trial (for LD, death, etc)
my $spawn_ex = 1;
my $wave = 1;
my $move_client_corpses = 1;    #Set to 0 to not move client corpses out of trial area when clear
my $proximity_check_delay = 30; #handle proximity check speed - faster only during trial
my $mob_count = 0;      #keep track of trial mobs to handle resetting executioner
my @mob_ids = ();      #for deleting mob corpses on exit
my @trial_mobs = ("priest of doom", "Herald of Destruction", "a dark nemesis", "a fierce nemesis");

sub EVENT_SPAWN {
   $x = $npc->GetX();
   $y = $npc->GetY();
   $npc->ChangeSize(1, 1);
   quest::settimer("proximity_check",$proximity_check_delay);
   quest::settimer("clear_corpses", 60);
}

sub EVENT_SIGNAL {

   if ($signal == 1) {
      quest::stoptimer("clear_corpses");
      quest::stoptimer("trial_eject");
      $proximity_check_delay = 1; #speed up during trial
      quest::settimer("proximity_check",$proximity_check_delay);
      #Allow new members to join trial
      $allow_entry = 1;
      quest::settimer("trial_lock", 6);
      $wave = 1;
      $spawn_ex = 1;
      #Set wave timers
      quest::settimer("execution_wave1", 30);                
      quest::settimer("execution_wave2", 200);   
      quest::settimer("execution_wave3", 365);   
      quest::settimer("execution_wave4", 525);                   
      #Spawn the prisoner
      quest::spawn2(201424, 0, 0, 165, -1156, 80, 122); # NPC: a_sentenced_prisoner
   }
   
   elsif ($signal == 2) {
      #It's over, one way or another.
      $mob_check = undef;
      #Timer to eject everyone after 15 minutes
      quest::settimer("trial_eject", 900);
      quest::stoptimer("execution_wave1");
      quest::stoptimer("execution_wave2");
      quest::stoptimer("execution_wave3");
      quest::stoptimer("execution_wave4");
      #Despawn executioner
      quest::signalwith(201439, 5, 5); # NPC: An_Executioner
      #Despawn prisoner
      quest::signalwith(201424, 0, 5); # NPC: a_sentenced_prisoner
      #Depawn trial trash
      quest::signalwith(201427, 0, 5); # NPC: a_dark_nemesis
      quest::signalwith(201428, 0, 5); # NPC: a_dark_nemesis
      quest::signalwith(201429, 0, 5); # NPC: a_fierce_nemesis
      quest::signalwith(201430, 0, 5); # NPC: a_fierce_nemesis
      quest::signalwith(201431, 0, 5); # NPC: priest_of_doom
      quest::signalwith(201432, 0, 5); # NPC: herald_of_destruction
      #Despawn the boss if he's up
      quest::signalwith(201433, 0, 5); # NPC: Prime_Executioner_Vathoch
   }
   elsif ($signal == 3) {
      #fail message
      foreach $player (@trial_group) {
         $c = $entity_list->GetClientByName($player);
         $c->Message(0, "The prisoners cry is cut off as his body crumples to the ground. You have failed.");
      }
      quest::ze(15, "An unnatural silence falls around you. The justice of the Tribunal has been pronounced once again. The defendants have been found...lacking.");
      #Signal self that it's over
      quest::signalwith(201425, 2, 5); # NPC: #Event_Execution_Control
   }
}

sub EVENT_TIMER {
    if ($timer eq "proximity_check") {
        quest::stoptimer("proximity_check");

        # Handle active mobs in trial
        if (defined $mob_check) {
            my $found = 0;
            my @moblist = $entity_list->GetMobList();
            foreach $tempmob (@moblist) {
                my $mobname = $tempmob->GetCleanName();
                if (grep(/^$mobname$/, @trial_mobs)) {
                    $found++;
                    my $mob_id = $tempmob->GetID();
                    push(@mob_ids, $mob_id) unless grep(/^$mob_id$/, @mob_ids);
                }
            }

            # When no mobs remain, move to next wave or spawn boss
            if (!$found) {
                $spawn_ex = 1;
                $wave++;
                if ($wave < 5) {
                    quest::signalwith(201439, 5, 0); # Next wave
                    $mob_check = undef;
                } else {
                    quest::signalwith(201439, 5, 0);
                    quest::spawn2(201433, 0, 0, 196, -1156, 80.1, 0); # Boss
                    $mob_check = undef;
                    $boss = 1;
                }
            } elsif ($found < $mob_count) {
                $mob_count = $found;
                quest::signalwith(201439, 0, 0);
            }
        }

        # Track boss spawn
        elsif (defined $boss) {
            my @moblist = $entity_list->GetMobList();
            foreach $tempmob (@moblist) {
                if ($tempmob->GetCleanName() eq "Prime Executioner Vathoch") {
                    push(@mob_ids, $tempmob->GetID());
                    $boss = undef;
                }
            }
        }

        # Remove players that left the zone
        my $removed = 0;
        foreach my $player (@trial_group) {
            my $ent = $entity_list->GetClientByName($player);
            if (!$ent) {
                @trial_group = grep { $_ ne $player } @trial_group;
                $removed++;
            }
        }

        # Update player list (everyone in zone is allowed)
        my @clientlist = $entity_list->GetClientList();
        foreach my $ent (@clientlist) {
            my $ClientName = $ent->GetName();
            push(@allowed, $ClientName) unless grep { $_ eq $ClientName } @allowed;
            push(@trial_group, $ClientName) unless grep { $_ eq $ClientName } @trial_group;
        }

        # If all players leave, cleanup
        if ($removed && scalar(@trial_group) == 0) {
            my $found = 0;
            my @moblist = $entity_list->GetMobList();
            foreach my $tempmob (@moblist) {
                if ($tempmob->GetCleanName() eq "Prime Executioner Vathoch") {
                    $found++;
                    last;
                }
            }

            if ($found) {
                quest::ze(15, "An unnatural silence falls around you. The justice of the Tribunal has been pronounced once again. The defendants have been found...lacking.");
            }

            quest::signalwith(201425, 2, 5);
            quest::signalwith(201078, 0, 5);
            quest::stoptimer("trial_eject");
            quest::signalwith(201075, 11, 2);
            @allowed = ();
            quest::settimer("clear_corpses", 60);
            HandleCorpses();
            $proximity_check_delay = 30;
        }

        quest::settimer("proximity_check", $proximity_check_delay);
    }

    # Execution waves
    elsif ($timer =~ /execution_wave\d/) {
        quest::stoptimer($timer);
        SpawnExecutionMobs();
        if (!defined $mob_check) {
            $mob_check = 1;
            $mob_count = 4;
        }
    }

    # Eject after completion (optional)
    elsif ($timer eq "trial_eject") {
        quest::stoptimer("trial_eject");
        quest::stoptimer("proximity_check");
        foreach my $player (@trial_group) {
            my $c = $entity_list->GetClientByName($player);
            if ($c) {
                my $inst_id = $c->GetInstanceID();
                $c->MovePCInstance(201, $inst_id, 456, 825, 9, 2);
                $c->Message(15, "A mysterious force translocates you.");
            }
        }
        @allowed = ();
        @trial_group = ();
        quest::signalwith(201078, 0, 5);
        $proximity_check_delay = 30;
        quest::settimer("proximity_check", $proximity_check_delay);
    }

    # Cleanup
    elsif ($timer eq "clear_corpses") {
        quest::stoptimer("clear_corpses");
        HandleCorpses();
        quest::settimer("clear_corpses", 60);
    }
}

sub HandleCorpses {
   if ($move_client_corpses) {
      #Move player corpses to graveyard
      @clist = $entity_list->GetCorpseList();
      foreach $ent (@clist) {
         if ($ent->IsPlayerCorpse()) {
            if ($ent->CalculateDistance(194, -1120, 72) < 120) {
               $ent->GMMove(58, -47, 2);
            }
         }
      }
   }
   
   #Delete npc corpses left in trial area
   foreach $id (@mob_ids) {
      $corpse_id = $entity_list->GetCorpseByID($id);
      if (defined $corpse_id) {
         if ($corpse_id->CalculateDistance(194, -1120, 72) < 120) {
            $corpse_id->Delete();
         }
      }
   }
   
   #Clear list
   @mob_ids = ();
}

sub SpawnExecutionMobs {
   #for our Loop
   my $count = 1;
   
   #Locations to spawn mobs at
   my @locX = qw(168 168 224 224);
   my @locY = qw(-1121 -1071 -1071 -1121);
   my @locZ = qw(73 73 73 73);
   my @locH = qw(180 180 180 180);
   
   #Only allow a max of 1 of each named per wave
   my $herald = 0;
   my $priest = 0;
   
   #Loop And spawn, baby.
   for ($count = 0; $count <= 3; $count++) {
      my $test = int(rand(99));
      
      if (($test >= 0) && ($test <=19)) {
         quest::spawn2(201427, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_dark_nemesis
      }
      
      elsif (($test >= 20) && ($test <=39)) {
         quest::spawn2(201429, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_fierce_nemesis
      }
      
      elsif (($test >= 40) && ($test <=64)) {
         quest::spawn2(201430, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_fierce_nemesis
      }
      
      elsif (($test >= 65) && ($test <=91)) {
         quest::spawn2(201428, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_dark_nemesis
      }
      
      elsif (($test >= 92) && ($test <=95)) {
         if (!$priest) {
            quest::spawn2(201431, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: priest_of_doom
            $priest = 1;
         }
         else {
            quest::spawn2(201428, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_dark_nemesis
         }
      }
      
      else {
         if (!$herald) {
            quest::spawn2(201432, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: herald_of_destruction
            $herald = 1;
         }
         else {
            quest::spawn2(201428, 0, 0, $locX[$count], $locY[$count], $locZ[$count], $locH[$count]); # NPC: a_dark_nemesis
         }
      }
      
      if ($spawn_ex == 1) {
         #Spawn An_Executioner (201439)
         quest::spawn2(201439,0,0,232,-1048,74,360); # NPC: An_Executioner
         #Signal Exe to set wave/speed
         quest::signalwith(201439, $wave, 100); # NPC: An_Executioner
         $spawn_ex = 0;
      }
   }
} 