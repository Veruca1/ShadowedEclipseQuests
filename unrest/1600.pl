# Define item categories for each armor slot and type
my %armor_items = (
  Leggings => [17663, 17657, 9612, 9602], # Cloth, Leather, Chain, Plate
  Sleeves  => [17662, 17656, 9611, 9601], # Cloth, Leather, Chain, Plate
  Boots    => [17660, 9615, 9609, 9557],  # Cloth, Leather, Chain, Plate
  Gloves   => [17659, 9614, 9608, 9558],  # Cloth, Leather, Chain, Plate
  Bracers  => [17658, 9613, 9607, 9556],  # Cloth, Leather, Chain, Plate
  Helmets  => [17661, 9616, 9610, 9600],  # Cloth, Leather, Chain, Plate
);

sub EVENT_SAY {
  if ($text =~ /hail/i) {
    # Provide clickable saylinks for the player to choose an armor type
    my $cloth_link = quest::saylink("Cloth", 1);
    my $leather_link = quest::saylink("Leather", 1);
    my $chain_link = quest::saylink("Chain", 1);
    my $plate_link = quest::saylink("Plate", 1);

    quest::whisper("Greetings! I can offer you a reward based on the armor type you prefer. Please choose from the following options: $cloth_link, $leather_link, $chain_link, or $plate_link.");
  }
  elsif ($text =~ /(Cloth|Leather|Chain|Plate)/i) {
    # Save the chosen armor type as a data key
    quest::set_data("armor_type", $1);
    quest::whisper("Very well, you have chosen $1. Please hand in 3 items of the SAME armor slot (any combo, doesn't need to match) to receive your reward.");
  }
}

sub EVENT_ITEM {
  # Retrieve the player's chosen armor type from the data
  my $armor_type = quest::get_data("armor_type");

  if (!$armor_type) {
    quest::whisper("Please tell me which armor type you prefer first by hailing me and selecting from the options.");
    plugin::return_items(\%itemcount);
    return;
  }

  # Track the total valid items handed in by slot type
  foreach my $slot (keys %armor_items) {
    my $valid_item_count = 0;

    # Count how many valid items of this slot are handed in
    foreach my $item_id (@{$armor_items{$slot}}) {
      $valid_item_count += $itemcount{$item_id} || 0;
    }

    # If the player handed in exactly 3 items of the same slot
    if ($valid_item_count == 3) {
      quest::whisper("Thank you for handing in 3 $slot items for $armor_type. Here is your reward.");

      # Determine the reward item based on the player's armor type
      my $reward_index = $armor_type eq "Plate"   ? 3 :
                         $armor_type eq "Chain"   ? 2 :
                         $armor_type eq "Leather" ? 1 :
                         $armor_type eq "Cloth"   ? 0 : 0;

      # The reward item for this slot and armor type
      my $reward_item = $armor_items{$slot}[$reward_index];
      quest::summonitem($reward_item);

      # Reset the data after rewarding the player
      quest::delete_data("armor_type");
      return;
    }
  }

  # If no valid set of 3 items is found
  quest::whisper("You must hand in exactly 3 items of the same slot type to receive a reward.");
  plugin::return_items(\%itemcount);
}
