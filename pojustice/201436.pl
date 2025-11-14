# Trial of Hanging
# NPC ID 201436

sub EVENT_SAY
{
	if($text=~/Hail/i) {
		my $prepared_link = quest::saylink("prepared", 1);
		quest::emote(" fixes you with a dark, piercing gaze. 'What do you want, mortal? Are you $prepared_link?'");
	}

	elsif($text=~/prepared/i) {
		my $begin_link = quest::saylink("begin the trial of hanging", 1);
		quest::say("Very well. When you are ready, you may $begin_link. Act quickly to destroy the spirits of suffocation before their victims perish. We shall judge the mark of your success.");
	}

	elsif($text=~/begin the trial of hanging/i) {
		my $inst_id = $client->GetInstanceID();
		if (!defined $hanging) {
			quest::say("Then begin.");

			# 🔥 Spawn the trial controller (Event_Hanging_Control)
			quest::spawn2(201448, 0, 0, 500, -1045, 73.1, 0); # NPC: Event_Hanging_Control

			$client->MovePCInstance(201, $inst_id, 500, -1045, 73.1, 0);
			quest::settimer(301, 30);
			$hanging = 1;
		}
		else {
			if (($hanging > 0) && ($hanging < 6)) {
				quest::say("Then begin.");
				$client->MovePCInstance(201, $inst_id, 500, -1045, 73.1, 0);
				$hanging++;
			}
			else {
				quest::say("I'm sorry, the Trial of Hanging is currently unavailable to you.");
			}
		}
	}

	elsif($text=~/what evidence of Mavuin/i) {
		if(plugin::check_hasitem($client, 31842)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_execution", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31796)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_flame", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31960)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_lashing", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31845)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_stoning", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31844)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_torture", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31846)) {
			$client->Message(4, "You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_hanging", 1, 5, "F");
			$client->Message(4, "You receive a character flag!");
		}
	}
}

sub EVENT_TIMER
{
	if($timer == 300) {
		$hanging=undef;
		quest::stoptimer(300);
		quest::signalwith(201078,3,5); # NPC: The_Tribunal Execution Trial
	}
	
	elsif($timer == 301) {
		$hanging=6;
		quest::stoptimer(301);
		quest::settimer(300, 1200);
	}
}

sub EVENT_SIGNAL
{
	if ($signal == 0) {
		# Reset or timer expired
		quest::shout("The Trial of Hanging is now available.");
		$hanging = undef;
		quest::signal(201433); # signal the 'ready' agent
		quest::stoptimer(300);
	}
	elsif ($signal == 1) {
		# Trial completed successfully
		quest::shout("Justice has been served. You have succeeded in the Trial of Hanging.");
		quest::settimer(300, 1800); # 30-minute cooldown
	}
	elsif ($signal == 2) {
		# Trial failed
		quest::shout("The Trial of Hanging has been failed.");
		quest::settimer(300, 1800); # 30-minute cooldown
	}
}

sub EVENT_ITEM 
{
	if(defined $qglobals{pop_poj_mavuin}) {
		if(plugin::check_handin(\%itemcount, 31842 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_execution", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31842); # Item: Mark of Execution
		}
		
		elsif(plugin::check_handin(\%itemcount, 31796 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_flame", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31796); # Item: Mark of Flame
		}
		
		elsif(plugin::check_handin(\%itemcount, 31960 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_lashing", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31960); # Item: Mark of Lashing
		}
		
		elsif(plugin::check_handin(\%itemcount, 31845 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_stoning", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31845); # Item: Mark of Stone
		}
		
		elsif(plugin::check_handin(\%itemcount, 31844 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_torture", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31844); # Item: Mark of Torture
		}
		
		elsif(plugin::check_handin(\%itemcount, 31846 => 1)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_hanging", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
			quest::summonitem(31846); # Item: Mark of Suffocation
		}
	}
		
		plugin::return_items(\%itemcount);

}