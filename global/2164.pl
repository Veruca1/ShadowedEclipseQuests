sub EVENT_SPAWN {
    quest::settimer("depop", 60); # 60 seconds
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::stoptimer("depop");
        quest::depop();
    }
}

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 21600;

my %zones = (
    "katta" => "Katta Castellum The Upside Down",
);

my %zone_versions = (
    "katta" => {
        1 => "Katta Castellum The Upside Down",
    },
);

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
        plugin::Whisper("Greetings, adventurer. Would you like to create a dynamic zone? Say [list zones] to see the available zone.");
    } elsif ($text =~ /list zones/i) {
        plugin::Whisper("Available Dynamic Zones:");
        plugin::Whisper("Katta Castellum Versions:");
        my @katta_versions = ("Katta Castellum The Upside Down");
        foreach my $version_name (@katta_versions) {
            plugin::Whisper("  - " . quest::saylink($version_name, 1, $version_name));
        }
        plugin::Whisper("Say the name to create a DZ.");
    }

    elsif ($text =~ /^(Katta Castellum The Upside Down)$/i) {
        my $zone_name = $1;
        foreach my $version (keys %{$zone_versions{"katta"}}) {
            if ($zone_versions{"katta"}->{$version} eq $zone_name) {
                my $expedition_name = $expedition_name_prefix . "katta";
                my $dz = $client->CreateExpedition("katta", $version, $dz_duration, $expedition_name, $min_players, $max_players);
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
        plugin::Whisper("I'm sorry, but I don't recognize that zone. Please say [list zones] to see available options.");
    }
}