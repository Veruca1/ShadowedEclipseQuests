sub EVENT_SAY {
    my $recycle_link = quest::saylink("Recycle", 1);

    if ($text=~/hail/i) {
        quest::say("Greetings, traveler. I am a quartermaster of the *Shadowsbane*, guardians of the old ways. In ages past, our warriors, scouts, and mystics forged their own gear from the raw elements of Norrath.");
        quest::say("Bring me crafting materials, and I shall see them returned to you in the form of Shadowsbane armor:");
        quest::say(" - 5 Chunk of Bronze → a piece of mighty *Plate*");
        quest::say(" - 5 Coarse Silk → soft yet magical *Cloth* garments");
        quest::say(" - 5 Silvril Ore → agile and enduring *Chain* gear");
        quest::say(" - 5 Raw Crude Hide → rugged *Leather* armor for scouts and wilds-born");
        quest::say("Each offering of five will yield one piece of our legacy. Choose wisely and wear it well.");
        quest::say("I can also help you [$recycle_link] Shadowsbane armor.");
    }

    if ($text=~/recycle/i) {
        quest::say("If you bring me any Shadowsbane armor piece — up to four at once — I can break them down and return some of the raw materials used to forge them. You'll get *2 of the base material* for each armor item, even if they're mixed types.");
    }
}


sub EVENT_ITEM {
    my %material_rewards = (
        54229 => [1377, 1378, 1800, 1801, 1802, 2827, 2828],             # Chunk of Bronze → Plate
        34211 => [4046, 4062, 4063, 4064, 4065, 4078, 4079],             # Coarse Silk → Cloth
        34239 => [2829, 2830, 2854, 2855, 2856, 2857, 4038],             # Silvril Ore → Chain
        984   => [4039, 4040, 4041, 4042, 4043, 4044, 4045],             # Raw Crude Hide → Leather
    );

    my %recycling_map;
    while (my ($material, $rewards_ref) = each %material_rewards) {
        foreach my $armor (@$rewards_ref) {
            $recycling_map{$armor} = $material;
        }
    }

    # Handle crafting hand-ins
    foreach my $material_id (keys %material_rewards) {
        if (plugin::check_handin(\%itemcount, $material_id => 5)) {
            my @rewards = @{$material_rewards{$material_id}};
            my $reward = $rewards[int(rand(@rewards))];
            quest::say("You have chosen well. Accept this piece of Shadowsbane craftsmanship.");
            quest::summonitem($reward);
            return;
        }
    }

    # Enhanced recycling logic
    my %return_materials;
    my $recycled_any = 0;

    foreach my $item_id (keys %itemcount) {
        next unless exists $recycling_map{$item_id};
        my $qty = $itemcount{$item_id};

        # Only take and process up to the number handed in
        for (1 .. $qty) {
            if (plugin::takeItems($item_id => 1)) {
                $return_materials{$recycling_map{$item_id}} += 2;
                $recycled_any = 1;
            }
        }
    }

    if ($recycled_any) {
        quest::say("Reclaimed, reforged. May these materials serve you once again.");
        foreach my $mat_id (keys %return_materials) {
            quest::summonitem($mat_id, $return_materials{$mat_id});
        }
        return;
    }

    plugin::return_items(\%itemcount);
}


