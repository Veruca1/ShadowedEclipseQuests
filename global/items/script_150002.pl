sub EVENT_ITEM_CLICK {
    my $itemid = 150002;  # Define the item ID to check
    my @restricted_zones = (344, 202, 219, 223, 451, 183, 151);  # List of restricted zone IDs
    my @excluded_npc_ids = (724075, 10);  # List of NPC IDs to exclude from aggro
    my $large_hate_value = 10000;  # Large hate value to be added to the target

    # Targetable Zone Aggro Item - Can target other PC's/Bots to aggro the zone on them instead of you. 
    return unless $client && $client->IsClient();

    # Get the current zone ID
    my $zoneid = $client->GetZoneID();

    # Check if the clicked item matches the specified item ID
    if ($itemid == 150002) {
        # Check if the player is in a restricted zone
        if (is_zone_restricted($zoneid, \@restricted_zones)) {
            $client->Message(15, "===========You can't use this in this zone. Duh=============");
        } else {
            my $target = $client->GetTarget();  # Get the player's current target

            if ($target) {
                my $target_id = $target->GetID();
                my $client_id = $client->GetID();
                my $pet_id = $client->GetPetID();
                
                my $is_group_member = 0;
                my $is_raid_member = 0;

                # Check if the target is a group member
                my $group = $client->GetGroup();
                if ($group) {
                    for (my $i = 0; $i < $group->GroupCount(); $i++) {
                        if (my $member = $group->GetMember($i)) {
                            if ($member->GetID() == $target_id) {
                                $is_group_member = 1;
                                last;
                            }
                        }
                    }
                }

                # Check if the target is a raid member
                my $raid = $client->GetRaid();
                if ($raid) {
                    for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                        if (my $member = $raid->GetMember($i)) {
                            if ($member->GetID() == $target_id) {
                                $is_raid_member = 1;
                                last;
                            }
                        }
                    }
                }

                # Check if the target is appropriate
                if ($target_id == $client_id || $target_id == $pet_id || $is_group_member || $is_raid_member || is_bot($target)) {
                    $client->Message(15, "=========%%AGGRO ZONE INCOMING, Watch the f##K out!%%=========");
                    
                    AGGRO_ZONE($client, $target, \@excluded_npc_ids, $large_hate_value);
                } else {
                    $client->Message(15, "You can only use this item on yourself, your pet, or a group/raid member.");
                }
            } else {
                $client->Message(15, "You need to target something to use this item.");
            }
        }
    }
}

sub AGGRO_ZONE {
    my ($client, $target, $excluded_npc_ids, $large_hate_value) = @_;
    
    # Validate the client and target to prevent null pointer issues
    return unless $client && $client->IsClient() && $target;

    my @npc_list = $entity_list->GetNPCList();
    foreach my $ent (@npc_list) {
        my $trashaggro = $ent->CastToNPC();
        my $trashnpctype = $trashaggro->GetNPCTypeID();
        unless (is_npc_excluded($trashnpctype, $excluded_npc_ids)) {
            # Add to hate list with a large amount of hate
            $trashaggro->AddToHateList($target, $large_hate_value);
        }
    }
}

# Function to check if the target is a bot
sub is_bot {
    my ($target) = @_;
    return $target && $target->IsBot();
}

# Function to check if the zone is restricted
sub is_zone_restricted {
    my ($zoneid, $restricted_zones) = @_;
    foreach my $restricted_zone (@$restricted_zones) {
        if ($zoneid == $restricted_zone) {
            return 1;
        }
    }
    return 0;
}

# Function to check if the NPC is in the exclusion list
sub is_npc_excluded {
    my ($npc_id, $excluded_npc_ids) = @_;
    foreach my $excluded_npc_id (@$excluded_npc_ids) {
        if ($npc_id == $excluded_npc_id) {
            return 1;
        }
    }
    return 0;
}
