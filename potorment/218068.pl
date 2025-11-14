# Planar Projection — Plane of Storms (postorms)
# Shadowed Eclipse: Storms Flag + DZ Creation

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 21600; # 6 hours

my %zone_versions = (
    "postorms" => {
        0 => "Plane of Storms",
    },
);

sub EVENT_SPAWN {
    quest::settimer(1, 600); # Despawn after 10 minutes
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        unless ($client->HasZoneFlag(210)) {
            quest::setglobal("pop_pos_storms_planar_projection", 1, 5, "F");
            $client->Message(4, "You receive a character flag!");

            my $clicker_ip = $client->GetIP();
            my $group = $client->GetGroup();
            my $raid  = $client->GetRaid();
            my $flagged = 0;

            if ($group) {
                for (my $i = 0; $i < $group->GroupCount(); $i++) {
                    my $member = $group->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag(210)) {
                        $member->SetZoneFlag(210);
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, "$name and group members on the same IP have earned access to the Plane of Storms.");
                }
            } elsif ($raid) {
                for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                    my $member = $raid->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag(210)) {
                        $member->SetZoneFlag(210);
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, "$name and raid members on the same IP have earned access to the Plane of Storms.");
                }
            } else {
                $client->SetZoneFlag(210);
                quest::we(14, "$name has earned access to the Plane of Storms.");
            }
        }

        plugin::Whisper("You hold access to the [" . quest::saylink("Plane of Storms DZ", 1, "Plane of Storms DZ") . "]. Say it if you wish me to spin a dynamic zone.");
    }

    elsif ($text =~ /Plane of Storms DZ/i) {
        my $zone_name = "Plane of Storms";
        foreach my $version (keys %{$zone_versions{"postorms"}}) {
            if ($zone_versions{"postorms"}->{$version} eq $zone_name) {
                my $expedition_name = $expedition_name_prefix . "postorms";
                my $dz = $client->CreateExpedition("postorms", $version, $dz_duration, $expedition_name, $min_players, $max_players);
                if ($dz) {
                    plugin::Whisper("Dynamic zone for '$zone_name' created successfully. Tell me when you're [" . quest::saylink("ready", 1, "ready") . "] to enter.");
                } else {
                    plugin::Whisper("There was an issue creating your dynamic zone. Please try again.");
                }
                return;
            }
        }
        plugin::Whisper("That is not a valid choice. Please try again.");
    }

    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();
            plugin::Whisper("Teleporting you to your dynamic zone: $zone_short_name.");
            $client->MovePCDynamicZone($zone_short_name);
        } else {
            plugin::Whisper("You don't have an active dynamic zone. Please create one first.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer == 1) {
        quest::depop();
    }
}