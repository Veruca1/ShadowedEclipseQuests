sub EVENT_ITEM_CLICK {
    my $itemid = 40500;
    my @restricted_zones = (344, 202, 219, 223, 451, 183, 151);
    my @excluded_npc_ids = (724075, 10);
    my $large_hate_value = 10000;

    return unless $client && $client->IsClient();

    my $zoneid = $client->GetZoneID();

    if ($itemid == 40500) {
        if (is_zone_restricted($zoneid, \@restricted_zones)) {
            $client->Message(15, "===========You can't use this in this zone. Duh=============");
        } else {
            my $target = $client->GetTarget();

            if ($target) {
                my $target_id = $target->GetID();
                my $client_id = $client->GetID();
                my $pet_id = $client->GetPetID();
                
                my $is_group_member = 0;
                my $is_raid_member = 0;

                if (my $group = $client->GetGroup()) {
                    for (my $i = 0; $i < $group->GroupCount(); $i++) {
                        if (my $member = $group->GetMember($i)) {
                            if ($member->GetID() == $target_id) {
                                $is_group_member = 1;
                                last;
                            }
                        }
                    }
                }

                if (my $raid = $client->GetRaid()) {
                    for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                        if (my $member = $raid->GetMember($i)) {
                            if ($member->GetID() == $target_id) {
                                $is_raid_member = 1;
                                last;
                            }
                        }
                    }
                }

                if ($target_id == $client_id || $target_id == $pet_id || $is_group_member || $is_raid_member || is_bot($target)) {
                    $client->Message(15, "=========%%AGGRO ZONE INCOMING, Watch the f#$% out!%%=========");
                    SUMMON_MOBS_TO_TARGET($client, $target, \@excluded_npc_ids, $large_hate_value);
                } else {
                    $client->Message(15, "You can only use this item on yourself, your pet, or a group/raid member.");
                }
            } else {
                $client->Message(15, "You need to target something to use this item.");
            }
        }
    }
}

sub SUMMON_MOBS_TO_TARGET {
    my ($client, $target, $excluded_npc_ids, $large_hate_value) = @_;
    
    if ($client && $target) {
        my $target_x = $target->GetX();
        my $target_y = $target->GetY();
        my $target_z = $target->GetZ();

        my @npcs = $entity_list->GetNPCList();
        foreach my $npc (@npcs) {
            if ($npc) {
                my $npc_id = $npc->GetNPCTypeID();
                if (!is_npc_excluded($npc_id, $excluded_npc_ids)) {
                    $npc->GMMove($target_x, $target_y, $target_z);
                    $npc->AddToHateList($target, $large_hate_value);
                }
            }
        }
    }
}

sub is_bot {
    my ($target) = @_;
    return $target->IsBot();
}

sub is_zone_restricted {
    my ($zoneid, $restricted_zones) = @_;
    foreach my $restricted_zone (@$restricted_zones) {
        if ($zoneid == $restricted_zone) {
            return 1;
        }
    }
    return 0;
}

sub is_npc_excluded {
    my ($npc_id, $excluded_npc_ids) = @_;
    foreach my $excluded_npc_id (@$excluded_npc_ids) {
        if ($npc_id == $excluded_npc_id) {
            return 1;
        }
    }
    return 0;
}