# Tribunal - Trial of Execution
# NPC ID: 201078 (or specific to your setup)
# Updated for emu / solo instance use

my $execution = undef;

sub EVENT_SPAWN {
    # Despawn and respawn the controller every time Tribunal spawns
    quest::depopall(201425);
    quest::spawn2(201425, 0, 0, 194, -1120, 72, 0); # #Event_Execution_Control
}

sub EVENT_SAY {
    if ($text=~/Hail/i) {
        my $prepared_link = quest::saylink("prepared", 1);
        quest::emote(" fixes you with a dark, piercing gaze. 'What do you want, mortal? Are you $prepared_link?'");
    }

    elsif ($text=~/prepared/i) {
        my $begin_link = quest::saylink("begin the trial of execution", 1);
        quest::say("Very well. When you are ready, you may $begin_link. The victim will perish should the hooded executioner reach him. Its life will end only when all of the nemeses which accompany it also perish. We shall judge the mark of your success.");
    }

    elsif ($text=~/begin the trial of execution/i) {
        my $inst_id = $client->GetInstanceID();

        if (!defined $execution) {
            quest::say("Then begin.");

            # Move player to trial room in their instance
            $client->MovePCInstance(201, $inst_id, 254, -1053, 73, 300);

            # Signal to start the execution trial event
            quest::signalwith(201425, 1, 0);

            quest::settimer(701, 30); # 30s prep before lock
            $execution = 1;
        } else {
            quest::say("Then begin again.");
            $client->MovePCInstance(201, $inst_id, 254, -1053, 73, 300);
        }
    }

    elsif ($text=~/what evidence of Mavuin/i) {
        if (plugin::check_hasitem($client, 31842)) {
            $client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea.");
            quest::setglobal("pop_poj_tribunal", 1, 5, "F");
            quest::setglobal("pop_poj_execution", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
        elsif (plugin::check_hasitem($client, 31796)) {
            quest::setglobal("pop_poj_flame", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
        elsif (plugin::check_hasitem($client, 31960)) {
            quest::setglobal("pop_poj_lashing", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
        elsif (plugin::check_hasitem($client, 31845)) {
            quest::setglobal("pop_poj_stoning", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
        elsif (plugin::check_hasitem($client, 31844)) {
            quest::setglobal("pop_poj_torture", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
        elsif (plugin::check_hasitem($client, 31846)) {
            quest::setglobal("pop_poj_hanging", 1, 5, "F");
            $client->Message(15, "You receive a character flag!");
        }
    }

    elsif ($text=~/i seek knowledge/i) {
        if (plugin::check_hasitem($client, 31842) && plugin::check_hasitem($client, 31796) && plugin::check_hasitem($client, 31960) && plugin::check_hasitem($client, 31845) && plugin::check_hasitem($client, 31844) && plugin::check_hasitem($client, 31846)) {
            if (!plugin::check_hasitem($client, 31599)) {
                quest::summonitem(31599); # Mark of Justice
            }
        } else {
            quest::say("You have done well, mortal, but there are more trials yet for you to complete.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "701") {
        quest::stoptimer("701");
        $execution = 6; # Prevent re-entry spam
        quest::settimer("700", 1200); # Reset in 20 mins
    }
    elsif ($timer eq "700") {
        $execution = undef;
        quest::stoptimer("700");
        quest::signalwith(201078, 0, 5); # Reset signal
    }
}

sub EVENT_SIGNAL {
    if ($signal == 0) {
        quest::shout("The Trial of Execution is now available.");
        $execution = undef;
        quest::stoptimer("701");
        quest::stoptimer("700");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 31842 => 1)) {
        quest::setglobal("pop_poj_execution", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31842);
    } elsif (plugin::check_handin(\%itemcount, 31796 => 1)) {
        quest::setglobal("pop_poj_flame", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31796);
    } elsif (plugin::check_handin(\%itemcount, 31960 => 1)) {
        quest::setglobal("pop_poj_lashing", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31960);
    } elsif (plugin::check_handin(\%itemcount, 31845 => 1)) {
        quest::setglobal("pop_poj_stoning", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31845);
    } elsif (plugin::check_handin(\%itemcount, 31844 => 1)) {
        quest::setglobal("pop_poj_torture", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31844);
    } elsif (plugin::check_handin(\%itemcount, 31846 => 1)) {
        quest::setglobal("pop_poj_hanging", 1, 5, "F");
        $client->Message(15, "You receive a character flag!");
        quest::summonitem(31846);
    }

    plugin::return_items(\%itemcount);
}