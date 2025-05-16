my $last_use_time = 0;  # Track last use time

sub EVENT_ITEM_CLICK {
    if ($itemid == 39667) {
        my $current_time = time();
        if ($current_time - $last_use_time < 120) {
            $client->Message(15, "The item is recharging. Please wait before using it again.");
            return;
        }
        $last_use_time = $current_time;
        
        # Define allowed Velious zones
        my %allowed_zones = (
            117 => 1,  # Cobalt Scar
            123 => 1,  # Dragon Necropolis
            116 => 1,  # Eastern Wastes
            113 => 1,  # Kael Drakkel
            125 => 1,  # Siren's Grotto
            121 => 1,  # Crystal Caverns
            127 => 1,  # Plane of Growth
            128 => 1,  # Sleeper's Tomb
            124 => 1,  # Temple of Veeshan
            111 => 1,  # Tower of Frozen Shadow
            119 => 1,  # Wakening Land
            120 => 1,  # Western Wastes
            112 => 1   # Velketor's Labyrinth
        );

        # Check if the current zone is allowed
        if (!exists $allowed_zones{$zoneid}) {
            $client->Message(15, "The Harbinger of Velious resonates faintly but nothing happens here.");
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