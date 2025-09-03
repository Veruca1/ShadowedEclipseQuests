sub EVENT_ITEM_CLICK {
	my @valid_zones = (163, 167, 160, 169, 165, 162, 154, 179, 164, 153, 157, 171, 173, 156, 175, 172, 170);
	my $cooldown_seconds = 30;
	my $cooldown_var = "hammer_maiden_cd";

	# Client validity check
	return unless $client;

	# Level check
	if ($ulevel < 61) {
		$client->Message(15, "You are not powerful enough to wield the Hammer of the Maiden.");
		return;
	}

	# Zone check
	my $zone_ok = grep { $_ == $zoneid } @valid_zones;
	if (!$zone_ok) {
		$client->Message(15, "The Hammer of the Maiden has no power in this land.");
		return;
	}

	# Cooldown check
	my $last_use = $client->GetBucket($cooldown_var);
	my $now = time();
	if (defined $last_use && ($now - $last_use) < $cooldown_seconds) {
		my $remaining_time = quest::secondstotime($cooldown_seconds - ($now - $last_use));
		$client->Message(15, "The hammer is still recharging, it can be reused again in $remaining_time.");
		return;
	}

	# Set cooldown
	$client->SetBucket($cooldown_var, $now);

	# Use built-in area damage function (much safer!)
	# Note: Check your EQEmu version for exact function signature
	$client->DamageAreaNPCs(500000, 30);

	# Show camera shake effect
	$client->CameraEffect(1000, 2.0);
	$client->Message(13, "You slam the Hammer of the Maiden into the ground, sending shockwaves through the earth!");
}