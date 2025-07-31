sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(0);

    $npc->ModifyNPCStat("level", 100);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 9000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 100000);
    $npc->ModifyNPCStat("max_hit", 200000);
    $npc->ModifyNPCStat("atk", 3000);
    $npc->ModifyNPCStat("accuracy", 1900);
    $npc->ModifyNPCStat("avoidance", 105);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 90);
    $npc->ModifyNPCStat("aggro", 57);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1100);
    $npc->ModifyNPCStat("int", 1100);
    $npc->ModifyNPCStat("cha", 900);

    $npc->ModifyNPCStat("mr", 350);
    $npc->ModifyNPCStat("fr", 350);
    $npc->ModifyNPCStat("cr", 350);
    $npc->ModifyNPCStat("pr", 350);
    $npc->ModifyNPCStat("dr", 350);
    $npc->ModifyNPCStat("corruption_resist", 400);
    $npc->ModifyNPCStat("physical_resist", 900);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "12,1^13,1^14,1^15,1^16,1^17,1^31,1^18,1^35,1^26,1^28,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^46,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::whisper("I can link any item if you give me its name or item ID, or link all items in a boss's loot table if you give me the boss's name.");
    } elsif ($text =~ /^(\d+)$/i) {
        # Handle item linking by item ID
        my $item_id = $1;
        my $dbh = plugin::LoadMysql();
        
        my $query = "SELECT Name FROM items WHERE id = ?";
        my $sth = $dbh->prepare($query);
        if ($sth->execute($item_id)) {
            if (my @row = $sth->fetchrow_array()) {
                quest::whisper("Here is the item you requested: " . quest::itemlink($item_id));
            } else {
                quest::whisper("Item not found.");
            }
        } else {
            quest::whisper("Database error: Unable to retrieve item.");
        }

        $sth->finish();
        $dbh->disconnect();
    } elsif ($text =~ /^(.+)$/i) {
        # Handle item linking by item name or boss name
        my $name = $1;
        my $dbh = plugin::LoadMysql();

        # Check if input is a boss name
        my $loottable_query = "SELECT id FROM loottable WHERE name = ?";
        my $sth_loottable = $dbh->prepare($loottable_query);
        if ($sth_loottable->execute($name)) {
            if (my @loottable_row = $sth_loottable->fetchrow_array()) {
                my $loottable_id = $loottable_row[0];

                # Get all lootdrop_ids from loottable_entries
                my $lootdrop_query = "SELECT lootdrop_id FROM loottable_entries WHERE loottable_id = ?";
                my $sth_lootdrop = $dbh->prepare($lootdrop_query);
                if ($sth_lootdrop->execute($loottable_id)) {
                    my $found_items = 0;
                    my $whisper_message = "Items in the loot table for $name: ";
                    
                    while (my @lootdrop_row = $sth_lootdrop->fetchrow_array()) {
                        my $lootdrop_id = $lootdrop_row[0];

                        # Get item_ids from lootdrop_entries
                        my $item_query = "SELECT item_id FROM lootdrop_entries WHERE lootdrop_id = ?";
                        my $sth_item = $dbh->prepare($item_query);
                        if ($sth_item->execute($lootdrop_id)) {
                            while (my @item_row = $sth_item->fetchrow_array()) {
                                my $item_id = $item_row[0];

                                # Fetch item name
                                my $item_name_query = "SELECT Name FROM items WHERE id = ?";
                                my $sth_item_name = $dbh->prepare($item_name_query);
                                if ($sth_item_name->execute($item_id)) {
                                    if (my @item_name_row = $sth_item_name->fetchrow_array()) {
                                        $whisper_message .= quest::itemlink($item_id) . " ";
                                        $found_items++;
                                    } else {
                                        quest::whisper("Item name not found for item ID $item_id.");
                                    }
                                } else {
                                    quest::whisper("Database error: Unable to retrieve item name for item ID $item_id.");
                                }
                                $sth_item_name->finish();
                            }
                        } else {
                            quest::whisper("Database error: Unable to retrieve item IDs from lootdrop_entries for lootdrop_id $lootdrop_id.");
                        }
                        $sth_item->finish();
                    }
                    if ($found_items == 0) {
                        quest::whisper("No items found in the loot table for $name.");
                    } else {
                        quest::whisper($whisper_message);
                    }
                } else {
                    quest::whisper("Database error: Unable to retrieve lootdrop_ids from loottable_entries for loottable_id $loottable_id.");
                }
                $sth_lootdrop->finish();
            } else {
                # If not a boss name, try to link by item name with partial match
                my $item_query = "SELECT id FROM items WHERE Name LIKE ?";
                my $sth_item = $dbh->prepare($item_query);
                if ($sth_item->execute('%' . $name . '%')) {
                    my $found_items = 0;
                    my $whisper_message = "Items containing '$name': ";
                    while (my @item_row = $sth_item->fetchrow_array()) {
                        quest::whisper($whisper_message . quest::itemlink($item_row[0]));
                        $found_items++;
                    }
                    if ($found_items == 0) {
                        quest::whisper("No items found with the name containing '$name'.");
                    }
                } else {
                    quest::whisper("Database error: Unable to retrieve items.");
                }
                $sth_item->finish();
            }
        } else {
            quest::whisper("Database error: Unable to retrieve loottable information for NPC name '$name'.");
        }
        $sth_loottable->finish();
        $dbh->disconnect();
    }
}
