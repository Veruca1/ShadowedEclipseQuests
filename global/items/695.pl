my $last_use_time = 0;  # Track last use time

sub EVENT_ITEM_CLICK {
    if ($itemid == 695) {
        my $current_time = time();
        if ($current_time - $last_use_time < 30) {
            $client->Message(15, "The item is recharging. Please wait before using it again.");
            return;
        }
        $last_use_time = $current_time;
        
        # Define allowed zones
        my %allowed_zones = (
            18  => 1,  # Splitpaw
	    36  => 1,  # Befallen
            63  => 1,  # Unrest
            44  => 1,  # Najena
            186 => 1   # Plane of Hate B
        );

        # Check if the current zone is allowed
        if (!exists $allowed_zones{$zoneid}) {
            $client->Message(15, "This item's power does not work in this area.");
        } else {
            my $radius = 250;  # Define radius (adjustable)
            my $x = $client->GetX();
            my $y = $client->GetY();
            my $z = $client->GetZ();

            $client->Message(15, "You feel a sudden disturbance as nearby creatures become hostile!");

            # Get all NPCs in the zone
            my @npcs = $entity_list->GetNPCList();

            foreach my $npc (@npcs) {
    if ($npc && $npc->GetNPCFactionID() != 0) {
        my $dist = sqrt(($npc->GetX() - $x) ** 2 + ($npc->GetY() - $y) ** 2 + ($npc->GetZ() - $z) ** 2);

        if ($dist <= $radius) {
            $npc->AddToHateList($client, 1); # Add player to hate list
        }
    }
}
        }
    }
}