# Luclin DZ Configuration
my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 6;
my $dz_duration = 82800;

my @luclin_zones = (
    { shortname => "shadeweaver", name => "Shadeweaver's Thicket" },
    { shortname => "paludal", name => "Paludal Caverns" },
    { shortname => "echo", name => "Echo Caverns" },
    { shortname => "deep", name => "The Deep" },
    { shortname => "maiden", name => "Maiden's Eye" },
    { shortname => "akheva", name => "Akheva Ruins" },
    { shortname => "tenebrous", name => "Tenebrous Mountains" },
    { shortname => "katta", name => "Katta Castellum" },
    { shortname => "twilight", name => "The Twilight Sea" },
    { shortname => "fungusgrove", name => "Fungus Grove" },
    { shortname => "grimling", name => "Grimling Forest" },
    { shortname => "scarlet", name => "Scarlet Desert" },
    { shortname => "letalis", name => "Mons Letalis" },
    { shortname => "thegrey", name => "The Grey" },
    { shortname => "ssratemple", name => "Ssraeshza Temple" },
);

# Build lookup hash
my %zones;
foreach my $zone (@luclin_zones) {
    $zones{ $zone->{shortname} } = $zone->{name };
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::whisper("Ahh, a curious spark kindles in thine eyes. You stand before the conduit to Luclin's riddled veil. Speak a name, and I shall part the mist.");
        ShowLuclinLinks();
    }
    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();
            quest::whisper("Teleporting you to your dynamic zone: $zone_short_name.");
            $client->MovePCDynamicZone($zone_short_name);
        } else {
            quest::whisper("You don't have an active dynamic zone. Please speak the name of a place first.");
        }
        return;
    }
    elsif ($text =~ /^(.*)$/i) {
        my $input = $1;
        my $zone_short;
        my $zone_name;

        foreach my $zone (@luclin_zones) {
            if ($input =~ /\Q$zone->{name}\E/i || $input =~ /^$zone->{shortname}$/i) {
                $zone_short = $zone->{shortname};
                $zone_name = $zone->{name};
                last;
            }
        }

        if ($zone_short) {
            my $expedition_name = $expedition_name_prefix . $zone_short;
            my $dz = $client->CreateExpedition($zone_short, 0, $dz_duration, $expedition_name, $min_players, $max_players);
            if ($dz) {
                my $ready_link = quest::silent_saylink("ready");
                quest::whisper("To $zone_name you shall go. May the light of Sel`Rheaza guide your path. Say [$ready_link] when you are prepared.");
            } else {
                quest::whisper("Something has hindered the creation of your path to $zone_name. Try once more.");
            }
        } else {
            quest::whisper("I know not that name. Let me show you again the zones I can send you to:");
            ShowLuclinLinks();
        }
    }
}

sub EVENT_TIMER {
    quest::depop() if $timer eq "depop";
}

sub EVENT_SPAWN {
    quest::settimer("depop", 10);
}

sub ShowLuclinLinks {
    my @zone_links;
    foreach my $zone (@luclin_zones) {
        push @zone_links, quest::silent_saylink($zone->{name});
    }
    my $line = join(", ", @zone_links);
    quest::message(315, "Speak the name, and the path shall open: $line");
}