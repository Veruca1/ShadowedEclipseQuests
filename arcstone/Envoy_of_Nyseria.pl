my $reliquary_id = 60461;
my $reliquary_required = 20;

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Nyseria",
            "Ah... the breath of fate brushes close again.<br><br>"
            . "Sel'Rheza has fallen. The whispers of the Ssraeshza halls echo hollow now, but the shadows... the shadows have only grown deeper.<br><br>"
            . "Where once I served the dreams of a would-be goddess, now I kneel at the obsidian veil of Nyseria—the true face behind the eclipse.<br><br>"
            . "Within the bowels of Ssra Temple, truths were unearthed: broken seals, tortured stone, and the shimmer of Luclin's fractured gaze. You saw it, didn’t you? The Image? It watched back.<br><br>"
            . "Now, in the time of influence—what you call the Planes of Power—I am reborn. Nyseria’s coven rises. The Shadowed Eclipse stirs, and with it, destiny falters.<br><br>"
            . "Should you wish the blessing of the veiled gods, you must bring forth offerings. Twenty shall be required—relics drawn from the hands of those who defy the eclipse.<br><br>"
            . "Seek and deliver twenty <c \"#E0E070\">Twilight Reliquaries</c>. Only then will your path darken... and deepen.<br><br>"
            . "<c \"#8080C0\">The Eye sleeps. But not forever.</c>"
        );

        plugin::Whisper("The weave changes. Speak the names of the realms you seek—if echoes still bind them, I may open the path.");
        plugin::Whisper("  - " . quest::saylink("Plane of Disease", 1, "Plane of Disease (podisease)"));
        plugin::Whisper("  - " . quest::saylink("Crypt of Decay", 1, "Crypt of Decay (codecay)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Nightmare", 1, "Plane of Nightmare (ponightmare)"));
        plugin::Whisper("  - " . quest::saylink("Lair of Terris Thule", 1, "Lair of Terris Thule (nightmareb)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Innovation", 1, "Plane of Innovation (poinnovation)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Justice", 1, "Plane of Justice (pojustice)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Torment", 1, "Plane of Torment (potorment)"));

        # Flag entire IP-matched group/raid for Plane of Disease (zone ID 205) if not already flagged
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();
        my $zone_id = 205;
        my @flagged;

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag($zone_id)) {
                    $member->SetZoneFlag($zone_id);
                    push @flagged, $member->GetCleanName();
                }
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag($zone_id)) {
                    $member->SetZoneFlag($zone_id);
                    push @flagged, $member->GetCleanName();
                }
            }
        } else {
            if (!$client->HasZoneFlag($zone_id)) {
                $client->SetZoneFlag($zone_id);
                push @flagged, $client->GetCleanName();
            }
        }

        if (@flagged) {
            my $names = join(", ", @flagged);
            quest::we(14, "$names have been flagged for access to Plane of Disease.");
        }
    }

    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Eclipse reveals remnants of fading worlds:");
        plugin::Whisper("  - " . quest::saylink("Plane of Disease", 1, "Plane of Disease (podisease)"));
        plugin::Whisper("  - " . quest::saylink("Crypt of Decay", 1, "Crypt of Decay (codecay)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Nightmare", 1, "Plane of Nightmare (ponightmare)"));
        plugin::Whisper("  - " . quest::saylink("Lair of Terris Thule", 1, "Lair of Terris Thule (nightmareb)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Innovation", 1, "Plane of Innovation (poinnovation)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Justice", 1, "Plane of Justice (pojustice)"));
        plugin::Whisper("  - " . quest::saylink("Plane of Torment", 1, "Plane of Torment (potorment)"));
    }

    elsif ($text =~ /^(Plane of Disease|podisease)$/i) {
        CreateCustomDZ("podisease", "Plane of Disease");
    }

    elsif ($text =~ /^(Crypt of Decay|codecay)$/i) {
        CreateCustomDZ("codecay", "Crypt of Decay");
    }

    elsif ($text =~ /^(Plane of Nightmare|ponightmare)$/i) {
        CreateCustomDZ("ponightmare", "Plane of Nightmare");
    }

    elsif ($text =~ /^(Lair of Terris Thule|nightmareb)$/i) {
        CreateCustomDZ("nightmareb", "Lair of Terris Thule");
    }

    elsif ($text =~ /^(Plane of Innovation|poinnovation)$/i) {
        CreateCustomDZ("poinnovation", "Plane of Innovation");
    }

    elsif ($text =~ /^(Plane of Justice|pojustice)$/i) {
        CreateCustomDZ("pojustice", "Plane of Justice");
    }

    elsif ($text =~ /^(Plane of Torment|potorment)$/i) {
        CreateCustomDZ("potorment", "Plane of Torment");
    }

    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short = $dz->GetZoneName();
            plugin::Whisper("The threads draw inward. You are bound for: $zone_short.");
            $client->MovePCDynamicZone($zone_short);
        } else {
            plugin::Whisper("No tether holds you. Speak again when your steps are chosen.");
        }
    }
}

sub EVENT_ITEM {
    my $reliquary_id       = 60461;
    my $reliquary_required = 20;
    my $key                = "twilight_reliquary_total";

    # Count actual stacked items from all slots
    my $turned_in = 0;

    for my $slot (1..4) {
        my $item_id = plugin::val("item${slot}");
        my $charges = plugin::val("item${slot}_charges");

        if ($item_id == $reliquary_id) {
            $turned_in += ($charges > 0) ? $charges : 1;
        }
    }

    # Use plugin::check_handin with the actual count to properly consume items
    if ($turned_in > 0 && plugin::check_handin(\%itemcount, $reliquary_id => $turned_in)) {
        my $current = quest::get_data($key) || 0;

        # Calculate new total
        my $new_total = $current + $turned_in;

        # Check how many complete cycles we've triggered
        my $cycles_completed = int($new_total / $reliquary_required);
        my $remainder = $new_total % $reliquary_required;

        # Set the remainder as the new stored value (rollover)
        quest::set_data($key, $remainder);

        # Announce progress
        quest::we(14, "The Eclipse stirs... ($remainder / $reliquary_required) Twilight Reliquaries have been offered to Nyseria.");

        # Trigger completion event for each cycle completed
        if ($cycles_completed > 0) {
            for (my $i = 0; $i < $cycles_completed; $i++) {
                plugin::Whisper("The final seal breaks. The Eclipse unfolds...");
                quest::worldwidecastspell(41229);
                quest::worldwidemarquee(15, 510, 1, 1, 5000,
                    "The Shadowed Eclipse stirs... Nyseria's gaze falls across the land.");
            }
        }

        return;
    }

    # Wrong items - return them
    plugin::Whisper("These are not the offerings Nyseria seeks.");
    plugin::return_items(\%itemcount);
}

sub CreateCustomDZ {
    my ($shortname, $fullname) = @_;
    my $dz_duration = 43200; # 12 hours
    my $min_players = 1;
    my $max_players = 6;
    my $expedition_name = "DZ - $fullname";

    my $dz = $client->CreateExpedition($shortname, 0, $dz_duration, $expedition_name, $min_players, $max_players);

    if ($dz) {
        plugin::Whisper("A shard of '$fullname' is now accessible. Say [" . quest::saylink("ready", 1, "ready") . "] when prepared.");
    } else {
        plugin::Whisper("The shard remains closed. Try again later or consult the Eclipse.");
    }
}