# Configuration options
my $enable_easter_island = 0;  # Set to 0 to disable Easter Island zones
my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 28800;

# Define zone categories with their shortnames and full names
my @antonica_zones = (
	{ shortname => "tutorialb", name => "The Mines of Gloomingdeep" },
	{ shortname => "commons", name => "Commonlands" },
	{ shortname => "befallen", name => "Befallen" },    
	{ shortname => "unrest", name => "The Estate of Unrest" },
	{ shortname => "najena", name => "Najena" },
	{ shortname => "hateplaneb", name => "Plane of Hate" },
	{ shortname => "highpasshold", name => "Highpass Hold" },
	{ shortname => "warrens", name => "The Warrens" },
	{ shortname => "paw", name => "The Lair of Paw" },
	{ shortname => "mistmoore", name => "Mistmoore" },
	{ shortname => "kedge", name => "Kedge Keep" },
	{ shortname => "gukbottom", name => "Lower Guk" },
	{ shortname => "soldungb", name => "Nagafen's Lair" },
	{ shortname => "permafrost", name => "Permafrost" },
	{ shortname => "hole", name => "The Hole" },
	{ shortname => "fearplane", name => "The Plane of Fear" },
	{ shortname => "airplane", name => "The Plane of Sky" }
);

my @kunark_zones = (
	{ shortname => "kurn", name => "Kurn's Tower" },
	{ shortname => "kaesora", name => "Kaesora" },
	{ shortname => "droga", name => "The Temple of Droga" },
	{ shortname => "nurga", name => "The Mines of Nurga" },
	{ shortname => "dalnir", name => "The Crypt of Dalnir" },
	{ shortname => "charasis", name => "The Howling Stones" },
	{ shortname => "citymist", name => "The City of Mist" },
	{ shortname => "lakeofillomen", name => "Lake of Ill Omen" },
	{ shortname => "veksar", name => "Veksar" },
	{ shortname => "karnor", name => "Karnor's Castle" },
	{ shortname => "chardok", name => "Chardok" },
	{ shortname => "burningwood", name => "Burning Woods" },
	{ shortname => "kerraridge", name => "Kerraridge" },
	{ shortname => "timorous", name => "Timorous Deep" },
	{ shortname => "skyfire", name => "Skyfire Mountains" },
	{ shortname => "veeshan", name => "Veeshan's Peak" },
	{ shortname => "fieldofbone", name => "The Field of Bone" },
	{ shortname => "frontiermtns", name => "Frontier Mountains" },
	{ shortname => "warslikswood", name => "Warsliks Woods" },
	{ shortname => "overthere", name => "The Overthere" },
	{ shortname => "emeraldjungle", name => "The Emerald Jungle" },
	{ shortname => "fironiavie", name => "Firiona Vie" }
);

my @velious_zones = (
	{ shortname => "iceclad", name => "Iceclad Ocean" },
	{ shortname => "frozenshadow", name => "The Tower of Frozen Shadow" },
	{ shortname => "eastwastes", name => "Eastern Wastes" },
	{ shortname => "crystal", name => "The Crystal Caverns" },
	{ shortname => "greatdivide", name => "The Great Divide" },
	{ shortname => "velketor", name => "Velketor's Labyrinth" },
	{ shortname => "cobaltscar", name => "Cobaltscar" },
	{ shortname => "sirens", name => "Siren's Grotto" },
	{ shortname => "wakening", name => "Wakening Lands" },
	{ shortname => "kael", name => "Kael Drakkel" },
	{ shortname => "westwastes", name => "The West Wastes" },
	{ shortname => "necropolis", name => "Dragon Necropolis" },
	{ shortname => "growthplane", name => "Plane of Growth" },
	{ shortname => "sleeper", name => "Sleeper's Tomb" },
	{ shortname => "templeveeshan", name => "Temple of Veeshan" }
);

my @event_zones = (
	{ shortname => "brellsarena", name => "Wave Event" },
	{ shortname => "arena", name => "The Arena" },
	{ shortname => "runnyeye", name => "Runnyeye" },
	{ shortname => "blackburrow", name => "Blackburrow" }
);

# Build a lookup hash for quick access
my %zones;
foreach my $zone_list (@antonica_zones, @kunark_zones, @velious_zones, @event_zones) {
	$zones{$zone_list->{shortname}} = $zone_list->{name};
}

my %zone_versions = (
	"oceanoftears" => {
		0 => "Easter Island Beginners Lvl 30",
		1 => "Easter Island Level 60 Sebilis Era",
		2 => "Easter Island End Game",
	},
	"citymist" => 1,
	"droga" => 1,
	"nurga" => 1,
	"sirens" => 1,
	"paw" => 1,
);

sub EVENT_SPAWN {
	quest::settimer("depop_me", 60);
}

sub EVENT_TIMER {
	if ($timer eq "depop_me") {
		quest::depop();
	}
}

sub EVENT_SAY {
	if ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();
            quest::whisper("Teleporting you to your dynamic zone: $zone_short_name.");
            $client->MovePCDynamicZone($zone_short_name);
        } else {
            quest::whisper("You don't have an active dynamic zone. Please create one first.");
        }
    } elsif ($text =~ /hail/i) {
		my $list_link = quest::silent_saylink("list");
		quest::whisper("Greetings, adventurer. Would you like to create a dynamic zone? If you would like, I can $list_link all available zones, or you can tell me the zone name you'd like to explore.");
	} elsif ($text =~ /^list$/i) {
		quest::message(315, "Available Dynamic Zones:");

		quest::message(315, "Antonica Zones:");
		foreach my $zone (@antonica_zones) {
			my $zone_link = quest::silent_saylink($zone->{name}, "$zone->{name} ($zone->{shortname})");
			quest::message(315, $zone_link);
		}

		quest::message(315, "Kunark Zones:");
		foreach my $zone (@kunark_zones) {
			my $zone_link = quest::silent_saylink($zone->{name}, "$zone->{name} ($zone->{shortname})");
			quest::message(315, $zone_link);
		}

		quest::message(315, "Velious Zones:");
		foreach my $zone (@velious_zones) {
			my $zone_link = quest::silent_saylink($zone->{name}, "$zone->{name} ($zone->{shortname})");
			quest::message(315, $zone_link);
		}

		quest::message(315, "Event Zones:");
		foreach my $zone (@event_zones) {
			my $zone_link = quest::silent_saylink($zone->{name}, "$zone->{name} ($zone->{shortname})");
			quest::message(315, $zone_link);
		}

		# Only show Easter Island if enabled
		if ($enable_easter_island) {
			quest::message(315, "Easter Island:");
			my @ordered_versions = (
				"Easter Island Beginners Lvl 30",
				"Easter Island Level 60 Sebilis Era",
				"Easter Island End Game",
			);

			foreach my $version_name (@ordered_versions) {
				my $version_link = quest::silent_saylink($version_name);
				quest::message(315, $version_link);
			}
		}

		quest::message(315, "Temple of Veeshan Versions:");
		my @temple_versions = (
			"Temple of Veeshan",
		   # "Temple of Veeshan 1",
		);
		foreach my $version_name (@temple_versions) {
			my $version_link = quest::silent_saylink($version_name);
			quest::message(315, $version_link);
		}

		quest::whisper("Click on a zone name or say its name to create a DZ.");
	} elsif ($text =~ /^(Easter Island .+)$/i) {
		if (!$enable_easter_island) {
			quest::whisper("Easter Island zones are currently disabled.");
			return;
		}

		my $zone_name = $1;

		foreach my $version (keys %{$zone_versions{"oceanoftears"}}) {
			if ($zone_versions{"oceanoftears"}->{$version} eq $zone_name) {
				my $expedition_name = $expedition_name_prefix . "oceanoftears";
				my $dz = $client->CreateExpedition("oceanoftears", $version, $dz_duration, $expedition_name, $min_players, $max_players);
				if ($dz) {
					my $ready_link = quest::silent_saylink("ready");
					quest::whisper("Dynamic zone for '$zone_name' created successfully. Tell me when you're $ready_link to enter.");
				} else {
					quest::whisper("There was an issue creating your dynamic zone. Please try again.");
				}
				return;
			}
		}

		quest::whisper("I'm sorry, but '$zone_name' is not a valid choice. Please select a valid version.");
	} elsif ($text =~ /^(Temple of Veeshan [0-1])$/i) {
		my $zone_name = $1;

		foreach my $version (keys %{$zone_versions{"templeveeshan"}}) {
			if ($zone_versions{"templeveeshan"}->{$version} eq $zone_name) {
				my $expedition_name = $expedition_name_prefix . "templeveeshan";
				my $dz = $client->CreateExpedition("templeveeshan", $version, $dz_duration, $expedition_name, $min_players, $max_players);
				if ($dz) {
					my $ready_link = quest::silent_saylink("ready");
					quest::whisper("Dynamic zone for '$zone_name' created successfully. Tell me when you're $ready_link to enter.");
				} else {
					quest::whisper("There was an issue creating your dynamic zone. Please try again.");
				}
				return;
			}
		}

		quest::whisper("I'm sorry, but '$zone_name' is not a valid choice. Please select a valid version.");
	} elsif ($text =~ /^(.*)$/i) {
		my $zone_input = $1;
		my $zone_found = 0;
		my $zone_shortname;
		my $zone_name;

		# Check if input matches a shortname or full name
		foreach my $shortname (keys %zones) {
			if ($zone_input =~ /^$shortname$/i || $zone_input =~ /\Q$zones{$shortname}\E/i) {
				$zone_shortname = $shortname;
				$zone_name = $zones{$shortname};
				my $version = 0;

				if (exists $zone_versions{$zone_shortname}) {
					if ($zone_versions{$zone_shortname} == 1) {
						$version = 1;
					}
				}

				my $expedition_name = $expedition_name_prefix . $zone_shortname;
				my $dz = $client->CreateExpedition($zone_shortname, $version, $dz_duration, $expedition_name, $min_players, $max_players);
				if ($dz) {
					my $ready_link = quest::silent_saylink("ready");
					quest::whisper("Dynamic zone for '$zone_name' created successfully. Tell me when you're $ready_link to enter.");
				} else {
					quest::whisper("There was an issue creating your dynamic zone. Please try again.");
				}
				$zone_found = 1;
				last;
			}
		}

		if (!$zone_found) {
			quest::whisper("I'm sorry, but '$zone_input' is not a valid zone name or shortname. Say [list zones] to see the available options.");
		}
	}
}