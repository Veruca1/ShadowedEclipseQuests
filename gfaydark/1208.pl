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
