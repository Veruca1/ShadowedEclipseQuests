sub EVENT_SIGNAL {
	my $signal = $_[0];
	if ($signal == 1) {
		my $random_result = int(rand(100));
		if ($random_result < 100) {
			quest::spawn2(172155, 0, 0, -1425, 576, 317, 128);
		}
	}
}