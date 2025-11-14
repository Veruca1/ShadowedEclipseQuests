# ===========================================================
# Planar Projection after Nightmareb Boss
# Grants Plane of Innovation (206) access + DZ creation (poinnovation, version 0)
# ===========================================================

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 21600; # 6 hours

my %zone_versions = (
    "poinnovation" => {
        0 => "Plane of Innovation",  # base version
    },
);

sub EVENT_SPAWN {
    quest::settimer(1, 600); # Despawn after 10 minutes
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # === Flagging logic (only if not already flagged) ===
        unless ($client->HasZoneFlag(206)) {
            quest::setglobal("pop_poi_innovation", 1, 5, "F");  # Innovation flag
            $client->Message(4, "You receive a character flag!");

            # Group/Raid propagation by IP
            my $clicker_ip = $client->GetIP();
            my $group = $client->GetGroup();
            my $raid  = $client->GetRaid();
            my $flagged = 0;

            if ($group) {
                for (my $i = 0; $i < $group->GroupCount(); $i++) {
                    my $member = $group->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag(206)) {
                        $member->SetZoneFlag(206);  # PoInnovation flag
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, "$name and group members on the same IP have earned access to the Plane of Innovation.");
                }
            } elsif ($raid) {
                for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                    my $member = $raid->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag(206)) {
                        $member->SetZoneFlag(206);
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, "$name and raid members on the same IP have earned access to the Plane of Innovation.");
                }
            } else {
                $client->SetZoneFlag(206);
                quest::we(14, "$name has earned access to the Plane of Innovation.");
            }
        }

        # === DZ Prompt (always shown) ===
        plugin::Whisper("You hold access to the [" . quest::saylink("Plane of Innovation DZ", 1, "Plane of Innovation DZ") . "]. Say it if you wish me to spin a dynamic zone.");
    }

    elsif ($text =~ /Plane of Innovation DZ/i) {
        my $zone_name = "Plane of Innovation";
        foreach my $version (keys %{$zone_versions{"poinnovation"}}) {
            if ($zone_versions{"poinnovation"}->{$version} eq $zone_name) {
                my $expedition_name = $expedition_name_prefix . "poinnovation";
                my $dz = $client->CreateExpedition("poinnovation", $version, $dz_duration, $expedition_name, $min_players, $max_players);
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