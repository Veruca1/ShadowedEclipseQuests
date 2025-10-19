# Luclin DZ Configuration

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 6;
my $dz_duration = 82800;

# Define zones and versions
my %zone_versions = (
    "shadeweaver" => { 0 => "Shadeweaver's Thicket" },
    "paludal"     => { 0 => "Paludal Caverns" },
    "echo"        => { 0 => "Echo Caverns" },
    "thedeep"        => { 0 => "The Deep" },
    "maiden"      => { 1 => "Maiden's Eye" },   # 👈 Explicitly version 1
    "akheva"      => { 0 => "Akheva Ruins" },
    "tenebrous"   => { 0 => "Tenebrous Mountains" },
    "katta"       => { 0 => "Katta Castellum" },
    "twilight"    => { 0 => "The Twilight Sea" },
    "fungusgrove" => { 0 => "Fungus Grove" },
    "grimling"    => { 0 => "Grimling Forest" },
    "scarlet"     => { 0 => "Scarlet Desert" },
    "letalis"     => { 0 => "Mons Letalis" },
    "thegrey"     => { 0 => "The Grey" },
    "ssratemple"  => { 0 => "Ssraeshza Temple" },
);

sub ShowLuclinLinks {
    my @zone_links;
    foreach my $short (keys %zone_versions) {
        foreach my $ver (keys %{ $zone_versions{$short} }) {
            push @zone_links, quest::silent_saylink($zone_versions{$short}{$ver});
        }
    }
    my $line = join(", ", @zone_links);
    quest::message(315, "Speak the name, and the path shall open: $line");
}

sub EVENT_SAY {
    return unless $client;

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
    }
    elsif ($text =~ /^(.*)$/i) {
        my $input = $1;
        my ($zone_short, $version, $zone_name);

        foreach my $short (keys %zone_versions) {
            foreach my $ver (keys %{ $zone_versions{$short} }) {
                my $name = $zone_versions{$short}{$ver};
                if ($input =~ /\Q$name\E/i || $input =~ /^$short$/i) {
                    $zone_short = $short;
                    $version    = $ver;
                    $zone_name  = $name;
                    last;
                }
            }
        }

        if ($zone_short) {
            my $expedition_name = $expedition_name_prefix . $zone_name;
            my $dz = $client->CreateExpedition($zone_short, $version, $dz_duration, $expedition_name, $min_players, $max_players);
            if ($dz) {
                my $ready_link = quest::silent_saylink("ready");
                quest::whisper("To $zone_name you shall go (version $version). May the light of Sel`Rheaza guide your path. Say [$ready_link] when you are prepared.");
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