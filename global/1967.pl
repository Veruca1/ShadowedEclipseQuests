# Configuration options
my $enable_easter_island = 1;  # Set to 0 to disable Easter Island zones
my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 28800;

# Define zone versions specifically for Easter Island and related
my %zone_versions = (
    "oceanoftears" => {
        0 => "Easter Island Beginners Lvl 30",
        1 => "Easter Island Level 60 Sebilis Era",
        2 => "Easter Island Level 60 ToV Era",
    }
);

sub EVENT_SPAWN {
    quest::settimer("depop", 20);  # 20 seconds until depop
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::stoptimer("depop");
        $npc->Depop();
    }
}

sub EVENT_SAY {
    if ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();
            plugin::Whisper("Teleporting you to your dynamic zone: $zone_short_name.");
            $client->MovePCDynamicZone($zone_short_name);
        } else {
            plugin::Whisper("You don't have an active dynamic zone. Please create one first.");
        }
        return;
    }

    if ($text =~ /hail/i) {
        plugin::Whisper("Greetings, adventurer. Would you like to create a dynamic zone? Say [list zones] to see all available zones or tell me the zone name you'd like to explore.");
    } elsif ($text =~ /list zones/i) {
        if ($enable_easter_island) {
            plugin::Whisper("Available Dynamic Zones:");
            plugin::Whisper("Easter Island:");
            my @ordered_versions = (
                "Easter Island Beginners Lvl 30",
                "Easter Island Level 60 Sebilis Era",
                "Easter Island Level 60 ToV Era",
            );

            foreach my $version_name (@ordered_versions) {
                plugin::Whisper("  - " . quest::saylink($version_name, 1, $version_name));
            }
        } else {
            plugin::Whisper("No dynamic zones are currently available.");
        }

        plugin::Whisper("Click on a zone name or say its name to create a DZ.");
    }

    elsif ($text =~ /^(Easter Island .+)$/i) {
        if (!$enable_easter_island) {
            plugin::Whisper("Easter Island zones are currently disabled.");
            return;
        }

        my $zone_name = $1;

        foreach my $version (keys %{$zone_versions{"oceanoftears"}}) {
            if ($zone_versions{"oceanoftears"}->{$version} eq $zone_name) {
                my $expedition_name = $expedition_name_prefix . "oceanoftears";
                my $dz = $client->CreateExpedition("oceanoftears", $version, $dz_duration, $expedition_name, $min_players, $max_players);
                if ($dz) {
                    plugin::Whisper("Dynamic zone for '$zone_name' created successfully. Tell me when you're [" . quest::saylink("ready", 1, "ready") . "] to enter.");
                } else {
                    plugin::Whisper("There was an issue creating your dynamic zone. Please try again.");
                }
                return;
            }
        }

        plugin::Whisper("I'm sorry, but '$zone_name' is not a valid choice. Please select a valid version.");
    }

    else {
        plugin::Whisper("Invalid input. Say [list zones] to see the available options.");
    }
}