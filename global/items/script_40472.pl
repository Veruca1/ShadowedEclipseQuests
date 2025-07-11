my $last_click_time_40472 = 0;

sub EVENT_ITEM_CLICK {
    #Clicky Buff Item - Replace ID's as needed.
    return unless $client && $client->IsClient();

    if ($itemid == 40472) {
        my $clicked_check = $client->GetBucket("-buff_40472");
        my $cooldown = 60;  # 1 minute cooldown

        if (!$clicked_check) {
            my @buffs = (
                5278,   # Hand of Conviction
                5297,   # Brells Brawny Bullwark
                5488,   # Circle of Fireskin 62 DS
                10028,  # Talisman of Persistance (End/Sta Buff)
                10031,  # Talisman of the Stoic One (Regen)
                10013,  # Talisman of Foresight (Dodge 10% also casts Mammoth)
                10664,  # Voice of Intuition (Kei)
                15031,  # Strength of Gladwalker (Atk and HP)
                2530,   # Khura's focusing
                9414,   # Holy Battle Hymn V
                300,    # Boon of the Avenging Angel IV
            );

            foreach my $spell_id (@buffs) {
                plugin::ApplySpellGroup($client, $spell_id, 600);
            }

            # Apply spell 9976 for only 7 ticks (42 seconds)
            plugin::ApplySpellGroup($client, 9976, 42);  # Panther

            $client->Message(15, "Buffs have been applied.");
            $client->SetBucket("-buff_40472", 1, $cooldown);
        } else {
            my $remaining_time = quest::secondstotime($client->GetBucketRemaining("-buff_40472"));
            $client->Message(315, "You must wait [$remaining_time] before using this item again.");
        }
    }
}