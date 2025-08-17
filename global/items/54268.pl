my $last_use_time = 0;  # Track last use time

sub EVENT_ITEM_CLICK {
    if ($itemid == 54268) {
        my $current_time = time();
        if ($current_time - $last_use_time < 120) {
            $client->Message(15, "The item is recharging. Please wait before using it again.");
            return;
        }
        $last_use_time = $current_time;
        
        # Define allowed Luclin zones
        my %allowed_zones = (
            165 => 1,  # Shadeweaver's Thicket
            156 => 1,  # Paludal Caverns
            153 => 1,  # Echo Caverns
            164 => 1,  # The Deep
            173 => 1,  # Maiden's Eye
            179 => 1,  # Akheva Ruins
            172 => 1,  # Tenebrous Mountains
            160 => 1,  # Katta
            170 => 1,  # Twilight Sea
            157 => 1,  # Fungus Grove
            167 => 1,  # Grimling Forest
            175 => 1,  # Scarlet Desert
            169 => 1,  # Mons Letalis
            171 => 1,  # The Grey
            162 => 1   # Ssraeshza Temple
        );

        # Check if the current zone is allowed
        if (!exists $allowed_zones{$zoneid}) {
            $client->Message(15, "The Harbinger of Luclin resonates faintly but nothing happens here.");
        } else {
            my $radius = 400;  # Radius in which mobs will agro
            my $x = $client->GetX();
            my $y = $client->GetY();
            my $z = $client->GetZ();

            $client->Message(15, "A chilling gust sweeps the land as nearby creatures sense your presence!");

            # Get all NPCs in the zone
            my @npcs = $entity_list->GetNPCList();

            foreach my $npc (@npcs) {
                if ($npc) {
                    my $dist = sqrt(($npc->GetX() - $x) ** 2 + ($npc->GetY() - $y) ** 2 + ($npc->GetZ() - $z) ** 2);

                    if ($dist <= $radius) {
                        $npc->AddToHateList($client, 1); # Force agro
                    }
                }
            }
        }
    }
}