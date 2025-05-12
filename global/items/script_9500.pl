
sub EVENT_ITEM_CLICK {
    return unless $client && $client->IsClient();

    my $charid = $client->CharacterID();
    quest::debug("EVENT_ITEM_CLICK triggered for item ID: $itemid, char ID: $charid");

    my $egg_cd_key = "egg_click_cd_$charid";
    my $cooldown_remaining = $client->GetBucketRemaining($egg_cd_key);

    if ($client->GetBucket($egg_cd_key)) {
        my $time = quest::secondstotime($cooldown_remaining);
        $client->Message(13, "You're still recovering from the last egg... try again in [$time].");
        return;
    }

    $client->SetBucket($egg_cd_key, 1, 6);  # Set 6s cooldown

    # Handle baskets by item ID
    if ($itemid == 896 || $itemid == 897 || $itemid == 898) {
        quest::debug("Basket item test clicked.");
        plugin::basket_click($client, $charid, $itemid);
        return;
    }

    my %easter_items = (
        150103 => sub {
            quest::debug("Applying damage buff.");
            plugin::ApplySpellGroup($client, 40663, 600);
            $client->Message(15, "You gain the speed of the rabbit!");
            $client->RemoveItem($itemid, 1);
        },
        150104 => sub {
            quest::debug("Applying loot buff.");
            plugin::ApplySpellGroup($client, 40664, 300);
            $client->Message(15, "You feel luckier...");
            $client->RemoveItem($itemid, 1);
        },
        150105 => sub {
            quest::debug("Applying damage reduction.");
            plugin::ApplySpellGroup($client, 40665, 300);
            $client->Message(15, "A protective aura surrounds you.");
            $client->RemoveItem($itemid, 1);
        },
        150106 => sub {
        quest::debug("Healing 50% HP.");
        plugin::heal_percent_hp($client, 50);
        $client->RemoveItem($itemid, 1);
        },
       150107 => sub {
        quest::debug("Restoring 50% mana.");
        plugin::restore_percent_mana($client, 50);
        $client->RemoveItem($itemid, 1);
        },
        150108 => sub {
            quest::debug("Applying damage shield.");
            plugin::ApplySpellGroup($client, 40662, 300);
            $client->Message(15, "You are surrounded by a spiky aura!");
            $client->RemoveItem($itemid, 1);
        },
        150109 => sub {
            quest::debug("Curing debuffs.");
            $client->CastSpell(40661, $client->GetID());
            $client->Message(15, "A cleansing warmth washes over you.");
            $client->RemoveItem($itemid, 1);
        },
        150110 => sub {
        quest::debug("Listing buffs");
        plugin::double_buff_duration($client);
        $client->RemoveItem($itemid, 1);
        },
    );

    if (defined $easter_items{$itemid}) {
        $easter_items{$itemid}->();
    } else {
        quest::debug("Item ID $itemid not found in Easter egg item list.");
        $client->Message(13, "This item doesn't seem to do anything...");
    }
}









