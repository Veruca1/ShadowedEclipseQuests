sub EVENT_ITEM_CLICK {
    # This might not destroy t imers. Needs Testing. 
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
            # SAFER PSEUDO-REPOP: Depop all NPCs except excluded ones, allow respawn
            foreach my $ent ($entity_list->GetNPCList()) {
                my $npc = $ent->CastToNPC();
                my $npcid = $npc->GetNPCTypeID();

                # Exclude quest givers, bankers, etc. Add more NPCTypeIDs to this array as needed.
                my @exclude_npc_ids = (
                    # 12345, # Example quest giver
                    # 67890, # Example banker
                );

                my $exclude = 0;
                foreach my $id (@exclude_npc_ids) {
                    if ($npcid == $id) {
                        $exclude = 1;
                        last;
                    }
                }

                next if $exclude;
                $npc->Depop(1); # Depop and allow respawn from spawn table
            }

            $client->Message(21, "You meddle with forbidden forces, causing the denizens of this place to return to their lairs...");
        }
    }
}
