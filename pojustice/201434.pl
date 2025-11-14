# Tribunal - Trial of Flame
# NPC ID: 201434
# Emu-ready / DZ-compatible

sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $prepared = quest::saylink("prepared", 1);
		quest::emote(" fixes you with a dark, piercing gaze. 'What do you want, mortal? Are you $prepared?'");
	}

	elsif ($text=~/prepared/i) {
		my $begin = quest::saylink("begin the trial of flame", 1);
		quest::say("Very well. When you are ready, you may $begin. You must endure the heat of the fire and be sure not to let its creatures reach the center. We shall judge the mark of your success.");
	}

	elsif ($text=~/begin the trial of flame/i) {
		quest::say("Then begin.");
		
		# Move player to DZ instance of flame trial
		my $inst_id = $client->GetInstanceID();
		$client->MovePCInstance(201, $inst_id, 937, -703, 53, 300); # Trial chamber

		# Spawn controller (manages the event)
		quest::spawn2(201417, 0, 0, 880, -729, 55, 0); # NPC: #Event_Burning_Control

		# Signal controller to begin
		quest::signalwith(201417, 1, 0);

		# Set retry timer
		quest::settimer(701, 30);
	}
	elsif ($text=~/what evidence of Mavuin/i) {
		if(plugin::check_hasitem($client, 31842)) {
			quest::setglobal("pop_poj_execution", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31796)) {
			quest::setglobal("pop_poj_flame", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31960)) {
			quest::setglobal("pop_poj_lashing", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31845)) {
			quest::setglobal("pop_poj_stoning", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31844)) {
			quest::setglobal("pop_poj_torture", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31846)) {
			quest::setglobal("pop_poj_hanging", 1, 5, "F");
			$client->Message(15,"You receive a character flag!");
		}
	}
	elsif($text=~/i seek knowledge/i) {
		if (plugin::check_hasitem($client, 31842) && plugin::check_hasitem($client, 31796) && plugin::check_hasitem($client, 31960) &&
			plugin::check_hasitem($client, 31845) && plugin::check_hasitem($client, 31844) && plugin::check_hasitem($client, 31846)) {
			if (!plugin::check_hasitem($client, 31599)) {
				quest::summonitem(31599); # Item: The Mark of Justice
			}
		} else {
			quest::say("You have done well, mortal, but there are more trials yet for you to complete.");
		}
	}
}

sub EVENT_TIMER {
	if ($timer eq "701") {
		quest::stoptimer("701");
		quest::settimer("700", 1200); # 20 mins lockout timer (if you want it)
	}
	elsif ($timer eq "700") {
		quest::stoptimer("700");
		quest::signalwith(201434, 0, 5); # reset signal to Tribunal
	}
}

sub EVENT_SIGNAL {
	if ($signal == 0) {
		quest::shout("The Trial of Flame is now available.");
		quest::stoptimer("700");
	}
	elsif ($signal == 2) {
		# failure, signal controller to despawn and clean up
		quest::signalwith(201417, 2, 5);
	}
}

sub EVENT_ITEM {
	if (plugin::check_handin(\%itemcount, 31842 => 1)) {
		quest::setglobal("pop_poj_execution", 1, 5, "F");
		quest::summonitem(31842);
	}
	elsif (plugin::check_handin(\%itemcount, 31796 => 1)) {
		quest::setglobal("pop_poj_flame", 1, 5, "F");
		quest::summonitem(31796);
	}
	elsif (plugin::check_handin(\%itemcount, 31960 => 1)) {
		quest::setglobal("pop_poj_lashing", 1, 5, "F");
		quest::summonitem(31960);
	}
	elsif (plugin::check_handin(\%itemcount, 31845 => 1)) {
		quest::setglobal("pop_poj_stoning", 1, 5, "F");
		quest::summonitem(31845);
	}
	elsif (plugin::check_handin(\%itemcount, 31844 => 1)) {
		quest::setglobal("pop_poj_torture", 1, 5, "F");
		quest::summonitem(31844);
	}
	elsif (plugin::check_handin(\%itemcount, 31846 => 1)) {
		quest::setglobal("pop_poj_hanging", 1, 5, "F");
		quest::summonitem(31846);
	}

	plugin::return_items(\%itemcount);
}