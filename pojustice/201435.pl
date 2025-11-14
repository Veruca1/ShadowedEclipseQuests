#201435.pl
#Trial of Lashing
# items: 31842, 31796, 31960, 31845, 31844, 31846

sub EVENT_SAY
{
	if ($text=~/Hail/i) {
		my $prepared_link = quest::saylink("prepared", 1);
		quest::emote(" fixes you with a dark, piercing gaze. 'What do you want, mortal? Are you $prepared_link?'");
	}
	
	elsif ($text=~/prepared/i) {
		my $begin_link = quest::saylink("begin the trial of lashing", 1);
		quest::say("Very well. When you are ready, you may $begin_link. You must protect the victims from their tormentors. Be wary of the scourge of honor - you cannot fight it directly. You must find and destroy its life force to defeat it. We shall judge the mark of your success.");
	}

	elsif ($text=~/begin the trial of lashing/i) {
	my $inst_id = $client->GetInstanceID();
	if (!defined $lashing) {
		quest::say("Then begin.");

		# 🛠️ FIXED LOCATION for Lashing Room (based on controller logic)
		$client->MovePCInstance(201, $inst_id, 1350, -1127, 2, 0); 

		# ✅ Spawn the Lashing Controller into the instance
		quest::spawn2(201449, 0, 0, 1350, -1127, 2, 124); 

		# 💬 Controller script handles signal itself after spawn
		quest::settimer(401, 30);
		$lashing = 1;
	}
	else {
		if (($lashing > 0) && ($lashing < 6)) {
			quest::say("Then begin.");
			$client->MovePCInstance(201, $inst_id, 1350, -1127, 2, 0); 
			$lashing++;
		}
		else {
			quest::say("I'm sorry, the Trial of Lashing is currently unavailable to you.");
		}
	}
}
	
	elsif($text=~/what evidence of Mavuin/i) {
		if(plugin::check_hasitem($client, 31842)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_execution", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31796)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_flame", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31960)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_lashing", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31845)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_stoning", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31844)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_torture", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
		elsif(plugin::check_hasitem($client, 31846)) {
			$client->Message(4,"You have completed a trial - impressive for mortals. You can tell Mavuin that we will hear his plea. We will seek him out as time befits us.");
			quest::setglobal("pop_poj_tribunal", 1, 5, "F");
			quest::setglobal("pop_poj_hanging", 1, 5, "F");
			$client->Message(4,"You receive a character flag!");
		}
	}
}


sub EVENT_TIMER
{
	if($timer == 400) {
		$lashing = undef;
		quest::stoptimer(400);
		quest::signalwith(201078, 4, 5); # NPC: The_Tribunal Execution Trial
	}
	elsif($timer == 401) {
		$lashing = 6;
		quest::stoptimer(401);
		quest::settimer(400, 1200);
	}
}


sub EVENT_SIGNAL
{
	if ($signal == 0) {
		quest::shout("The Trial of Lashing is now available."); # notify once timer expires OR FAIL (~25 minutes)
		$lashing = undef;
		quest::signal(201433);
		quest::stoptimer(400);
	}
}


sub EVENT_ITEM 
{
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

	plugin::return_items(\%itemcount);
}