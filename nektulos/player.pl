sub EVENT_ENTERZONE {
    # Set the player's bind point to their current location
    $client->SetBindPoint(25, 0, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());

    # Send a whisper message to the player to confirm they've been soulbound
    quest::whisper("You have been soulbound to this zone!");
}

sub EVENT_CAST {
    my $spell_id = $spell_id; # ID of the spell being cast
    my @restricted_zones = (25); # Zone IDs to restrict spells (25 is Nektulos)
    my $zone_id = $zoneid; # Zone ID of the current zone

    # List of gate spell IDs to restrict
    my @restricted_spells = (
        541, 542, 543, 544, 545, 546, 547, 548, 
        797, 1325, 1417, 2026, 2027, 2028, 2418, 2423, 
        2428, 2945, 3046, 3183, 3795, 4963, 5734, 6176, 
        6181, 8238, 8968, 10876, 10879, 10882, 11985, 
        12865, 15891, 16536, 17779, 17885, 20543, 21987, 
        29839, 29842, 35713, 40441,
        561, 562, 563, 564, 565, 566, 567, 568, 
        1399, 1418, 1423, 1425, 1516, 2123, 2124, 2279, 
        2280, 2281, 2282, 2283, 2284, 2285, 2286, 2287, 
        2288, 2289, 2290, 2291, 2292, 2420, 2425, 2430, 
        2728, 2944, 3065, 3134, 3180, 3793, 4965, 5732, 
        6178, 6183, 6836, 8236, 8881, 8882, 8966, 9483, 
        9484, 9485, 10875, 10878, 10881, 10991, 11746, 
        11984, 14768, 15890, 17555, 17886, 18838, 20542, 
        21985, 27751, 27755, 29840, 29843, 35714, 37801, 
        40442, 40473,
        463, 550, 551, 552, 553, 554, 555, 556, 
        557, 558, 807, 1247, 1398, 1434, 1438, 1440, 
        1517, 1551, 1552, 2020, 2419, 2424, 2429, 2432, 
        2519, 3184, 3792, 4049, 4050, 4966, 5451, 5455, 
        5488, 5517, 5731, 6179, 6184, 7003, 8235, 8965, 
        8991, 8992, 8993, 8994, 8995, 8996, 8997, 8998, 
        9000, 9001, 9002, 9003, 9004, 9005, 9006, 9007, 
        9008, 9009, 9010, 9011, 9012, 9013, 9014, 9015, 
        9951, 9954, 9957, 10747, 10748, 10749, 11519, 
        11520, 11523, 11981, 14325, 14326, 14327, 14715, 
        14716, 14717, 15887, 17883, 18346, 18347, 18348, 
        18782, 18783, 18784, 19926, 19927, 19928, 20539, 
        21984, 24919, 26812, 26813, 26814, 27781, 27784, 
        28997, 29000, 29940, 29941, 29942, 34832, 35777, 
        35778, 35779, 35988, 35989, 35990, 36760, 37242, 
        37569, 39606, 39607, 39608, 39609, 39610, 39611, 
        40216, 42160, 42210, 42237
    );

    # Check if the zone is restricted by zone ID
    if (grep { $_ == $zone_id } @restricted_zones) {
        # If the spell is in the restricted list
        if (grep { $_ == $spell_id } @restricted_spells) {
            # Send a message to the player telling them the spell is restricted
            quest::message(315, "The spell you are attempting to cast is restricted in this zone!");

            # Teleport the player to zone 25 (Nektulos) - specific coordinates
            $client->MovePC(25, -934.33, 1817.03, 26.42, 146.50);
        }
    }
}