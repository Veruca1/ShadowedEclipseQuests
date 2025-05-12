sub EVENT_SAY {
    # Greet the player and give instructions
    if ($text =~ /hail/i) {
        quest::whisper("Hello, $name! I am here to help you craft a set of armor. Choose the type of armor you would like to receive: " .
            quest::saylink("Plate", 1) . ", " .
            quest::saylink("Chain", 1) . ", " .
            quest::saylink("Leather", 1) . ", or " .
            quest::saylink("Cloth", 1) . ". Once you have made your selection, hand me 3 of the correct items for that armor type, and I will reward you (IE hand me 3 bracers, 3 legs, 3 helms etc).");
    }

    # Asking the player to select the armor type
    if ($text =~ /plate/i) {
        quest::whisper("You have selected Plate armor. Please hand me 3 pieces of the correct items for Plate armor.");
        quest::set_data("armor_type", "Plate");
    }
    elsif ($text =~ /chain/i) {
        quest::whisper("You have selected Chain armor. Please hand me 3 pieces of the correct items for Chain armor.");
        quest::set_data("armor_type", "Chain");
    }
    elsif ($text =~ /leather/i) {
        quest::whisper("You have selected Leather armor. Please hand me 3 pieces of the correct items for Leather armor.");
        quest::set_data("armor_type", "Leather");
    }
    elsif ($text =~ /cloth/i) {
        quest::whisper("You have selected Cloth armor. Please hand me 3 pieces of the correct items for Cloth armor.");
        quest::set_data("armor_type", "Cloth");
    }
    else {
        #quest::whisper("I do not understand that selection. Please choose Plate, Chain, Leather, or Cloth.");
    }
}

sub EVENT_ITEM {
    my $armor_type = quest::get_data("armor_type");

    if (!$armor_type) {
        quest::whisper("Please tell me which armor type you prefer first by hailing me and selecting from the options.");
        return;
    }

    # Armor rewards by item category with the respective armor types
    my %armor_rewards = (
        Tunic    => [2828, 4038, 4044, 4079], # Cloth (2828), Leather (4038), Chain (4044), Plate (4079)
        Leggings => [4078, 4043, 2857, 2827], # Cloth (4078), Leather (4043), Chain (2857), Plate (2827)
        Sleeves  => [4065, 4042, 2856, 1802], # Cloth (4065), Leather (4042), Chain (2856), Plate (1802)
        Boots    => [4063, 4045, 2854, 1800], # Cloth (4063), Leather (4045), Chain (2854), Plate (1800)
        Gloves   => [4062, 4040, 2830, 1378], # Cloth (4062), Leather (4040), Chain (2830), Plate (1378)
        Bracers  => [4046, 4039, 2829, 1377], # Cloth (4046), Leather (4039), Chain (2829), Plate (1377)
        Helmets  => [4064, 4041, 2855, 1801], # Cloth (4064), Leather (4041), Chain (2855), Plate (1801)
    );

    # Armor type to column index mapping
    my %armor_type_index = (
        Plate   => 3, # Plate: Fourth column
        Chain   => 2, # Chain: Third column
        Leather => 1, # Leather: Second column
        Cloth   => 0, # Cloth: First column
    );

    my $selected_armor_index = $armor_type_index{$armor_type};

    # Check for 3 handed-in items that match the selected armor type
    my $handed_in_items = 0;
    my $matched_items = [];

    foreach my $slot (keys %armor_rewards) {
        my @valid_items = @{ $armor_rewards{$slot} };

        # Collect handed-in items for this armor slot
        foreach my $item_id (@valid_items) {
            if ($itemcount{$item_id} && $itemcount{$item_id} >= 1) {
                $handed_in_items += $itemcount{$item_id};
                push @$matched_items, $item_id;
            }
        }

        # If the player has handed in 3 matching items
        if ($handed_in_items == 3) {
            # Only reward the selected armor piece
            my $reward_item = $valid_items[$selected_armor_index];

            # Give the correct armor reward item
            quest::summonitem($reward_item);

            # Do NOT return any of the handed-in items
            quest::whisper("Thank you for handing in the correct items for the $slot armor set. Here is your $armor_type $slot!");
            return;
        }
    }

    # If no valid combination matched
    quest::whisper("I cannot process this combination of items. Please check your hand-ins.");
}
