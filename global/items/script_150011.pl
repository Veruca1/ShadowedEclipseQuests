    sub EVENT_ITEM_CLICK {
        #Zone Repop Item With Zone Exclusions.
        return unless $client && $client->IsClient();

        my $zone_id = $zoneid;
        my $zone_name = $zonesn;

        # Array of forbidden zone IDs
        my @forbidden_zones = (202, 451, 183, 151); # Add more zone IDs to this array as needed

        if ($itemid == 150079) {
            my $is_forbidden = 0;
            foreach my $forbidden_zone (@forbidden_zones) {
                if ($zone_id == $forbidden_zone) {
                    $is_forbidden = 1;
                    last;
                }
            }

            if ($is_forbidden || $zone_name eq "poknowledge") {
                $client->Message(315, "You cannot use this item in this zone.");
            } else {
                quest::clearspawntimers();
                quest::repopzone();
                $client->Message(21, "You meddle where you shouldn't. The creatures of this place sense the disturbance and return to investigate.");

            }
        }
    }

