my %luclin_zones = (
	"Shadeweaver's Thicket" => 165,
	"Paludal Caverns" => 156,
	"Echo Caverns" => 153,
	"The Deep" => 164,
	"Maiden's Eye" => 173,
	"Akheva Ruins" => 179,
	"Tenebrous Mountains" => 172,
	"Katta Castellum" => 160,
	"The Twilight Sea" => 170,
	"Fungus Grove" => 157,
	"Grimling Forest" => 167,
	"Scarlet Desert" => 175,
	"Mons Letalis" => 169,
	"The Grey" => 171,
	"Ssraeshza Temple" => 162,
);

sub EVENT_SAY {
	if ($text =~ /hail/i) {
		quest::whisper("Ahh, a curious spark kindles in thine eyes. You stand before the conduit to Luclin's riddled veil. Speak a name, and I shall part the mist.");
		ShowLuclinLinks();
	} else {
		foreach my $zone (sort { $a cmp $b } keys %luclin_zones) {
			if ($text =~ /\b\Q$zone\E\b/i) {
				my $zone_id = $luclin_zones{$zone};
				quest::whisper("To $zone you shall go. May the light of Sel`Rheaza guide your path.");
				quest::movepc($zone_id, 0, 0, 0); # Default safe loc
			}
		}
	}
}

sub EVENT_TIMER {
	if ($timer eq "depop") {
		quest::depop();
	}
}

sub EVENT_SPAWN {
	quest::settimer("depop", 10);  
}

sub ShowLuclinLinks {
	my @zone_links;
	foreach my $zone (sort { $a cmp $b } keys %luclin_zones) {
		my $link = quest::silent_saylink($zone);
		push @zone_links, $link;
	}
	my $line = join(", ", @zone_links);
	quest::message(315, "Speak the name, and the path shall open: $line");
}