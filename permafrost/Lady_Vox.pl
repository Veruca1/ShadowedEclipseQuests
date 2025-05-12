# Modified script for Nagafen and Vox without level restrictions or banishing.

my $spawn_x = 0;
my $spawn_y = 0;
my $spawn_z = 0;
my $spawn_h = 0;

sub EVENT_SPAWN {
	$spawn_x = $x;
	$spawn_y = $y;
	$spawn_z = $z;
	$spawn_h = $h;
	my $range = 200;
	my $range2 = 88;
	quest::set_proximity($x - $range, $x + $range, $y - $range2, $y + $range);
	quest::setnexthpevent(96);
}

sub EVENT_HP {
	# Ensure the leash timer runs if the NPC's HP drops.
	quest::stoptimer(1);
	EVENT_AGGRO();
	# Backup safety check
	quest::setnexthpevent(int($npc->GetHPRatio()) - 9);
}

sub EVENT_ENTER {
	# Proximity message; no restrictions or banishing.
	quest::echo(0, "You feel the icy winds intensify as you approach!");
}

sub EVENT_AGGRO {
	# Start a 1-second leash timer.
	quest::settimer(1, 1);
}

sub EVENT_TIMER {
	if ($timer == 1) {
		# Leash check: Reset NPC if it leaves the allowed area.
		if ($x < -431 || $x > -85 || $y < 770 || $y > 1090 || $z < -50) {
			WIPE_AGGRO();
		}

		my @hate_list = $npc->GetHateListClients();
		if (!@hate_list) {
			WIPE_AGGRO();
		}
	}
}

sub WIPE_AGGRO {
	# Reset NPC to its original spawn state.
	$npc->BuffFadeAll();
	$npc->WipeHateList();
	$npc->SetHP($npc->GetMaxHP());
	$npc->GMMove($spawn_x, $spawn_y, $spawn_z, $spawn_h);
	quest::stoptimer(1);
	quest::setnexthpevent(96);
}
