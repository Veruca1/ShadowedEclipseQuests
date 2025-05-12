sub EVENT_SAY {
    if ($text =~ /hail/i) {
        $client->Message(15, quest::saylink("Dark", 1) . " or " . quest::saylink("Light", 1));
    }
    elsif ($text =~ /Dark/i) {
        $client->Message(15, "I require 3 Forrest Nights.");
    }
    elsif ($text =~ /Light/i) {
        $client->Message(15, "I require 3 Forrest Lights.");
    }
}

sub EVENT_ITEM {
    # Check if player handed in 3 Forrest Nights (594)
    if (plugin::check_handin(\%itemcount, 594 => 3)) {
        # Give 2 Forrest Dark Bracers (596)
        $client->SummonItem(596);  # Summon the first bracer
        $client->SummonItem(596);  # Summon the second bracer

        # Level up the player to level 3
        $client->AddLevelBasedExp(100, 3);  # Level 3 XP
        $client->Message(14, "You have been leveled up to level 3!");

        # Spawn NPC ID 1707 at the specified location
        quest::spawn2(1707, 0, 0, -2.61, 904.24, 10.54, 119.75);

        # Send message to all clients in the zone
        my @clients = $entity_list->GetClientList();  # Get all clients in the zone
        foreach my $client (@clients) {
            if ($client) {
                $client->Message(14, "You hear the howl of a wolf nearby.");
            }
        }

        # Depop the NPC after giving the items and leveling up
        quest::depop();
    }
    # Check if player handed in 3 Forrest Lights (595)
    elsif (plugin::check_handin(\%itemcount, 595 => 3)) {
        # Give 2 Forrest Light Bracers (597)
        $client->SummonItem(597);  # Summon the first bracer
        $client->SummonItem(597);  # Summon the second bracer

        # Level up the player to level 3
        $client->AddLevelBasedExp(100, 3);  # Level 3 XP
        $client->Message(14, "You have been leveled up to level 3!");

        # Spawn NPC ID 1707 at the specified location
        quest::spawn2(1707, 0, 0, -2.61, 904.24, 10.54, 119.75);

        # Send message to all clients in the zone
        my @clients = $entity_list->GetClientList();  # Get all clients in the zone
        foreach my $client (@clients) {
            if ($client) {
                $client->Message(14, "You hear the howl of a wolf nearby.");
            }
        }

        # Depop the NPC after giving the items and leveling up
        quest::depop();
    }
    else {
        # Return any unneeded items back to the player
        plugin::return_items(\%itemcount);
    }
}
