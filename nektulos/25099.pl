my $reward_choice = 0;  # Local variable to track reward choice during the quest

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, stranger. It has been some time since anyone has come around. The circle before me needs to be restored. Are you willing to [" . quest::saylink("help", 1) . "]?");
    }
    elsif ($text=~/help/i) {
        quest::whisper("Thank you, brave soul. The restoration will require effort, but I believe you are capable. You will need to collect three Essence Shards from nearby corrupted ghosts. Return to me once you have them.");
        quest::spawn2(1714, 0, 0, 540.07, 748.58, 21.49, 505.50); # Location 1
        quest::spawn2(1714, 0, 0, 613.32, 813.94, 17.66, 441.50); # Location 2
        quest::spawn2(1714, 0, 0, 673.54, 882.88, 12.84, 379.50); # Location 3
    }
    
    if ($reward_choice == 1) {
        if ($text=~/Shield of Unity/i) {
            quest::summonitem(624);  # Shield of Unity
            quest::whisper("Here is your Shield of Unity. Use it well to protect those in need.");
            spawn_creatures();
        }
        elsif ($text=~/Mace of Unity/i) {
            quest::summonitem(625);  # Mace of Unity
            quest::whisper("Here is your Mace of Unity. Use it wisely in your journey.");
            spawn_creatures();
        }
    }
}

sub spawn_creatures {
    # Spawn NPC 1715 at the locations before depopping
    quest::spawn2(1715, 0, 0, 778.26, 88.35, 9.79, 472.75);  # Location 1
    quest::spawn2(1715, 0, 0, 816.99, 15.88, 9.79, 427.25);  # Location 2
    quest::spawn2(1715, 0, 0, 877.28, 26.72, 9.79, 424.50);  # Location 3
    quest::spawn2(1715, 0, 0, 869.58, 67.80, 9.79, 482.50);  # Location 4

    # Send the message to all clients in the zone
    my @clients = $entity_list->GetClientList();
    foreach my $client (@clients) {
        if ($client) {
            $client->Message(14, "You hear distant chanting, sounds like old druidic.");
        }
    }

    # Cleanup after reward is chosen
    $reward_choice = 0;   # Reset the reward choice
    quest::depop();        # Depop the NPC
    quest::depop(1708);    # Depop NPC with ID 1708
}

sub EVENT_ITEM {
    # Check if the player hands in 3 Essence Shards (item 623)
    if (plugin::check_handin(\%itemcount, 623 => 3)) {
        quest::whisper("Thank you for your efforts, brave one. The circle has been restored! As a token of my gratitude, you may choose your reward: a [" . quest::saylink("Shield of Unity", 1) . "] or a [" . quest::saylink("Mace of Unity", 1) . "].");

        # Level the player to level 4
        $client->AddLevelBasedExp(100, 4);  # Level 4 XP
        $client->Message(14, "You have been leveled up to level 4!");

        # Set the reward_choice flag to indicate the player can now choose their reward
        $reward_choice = 1;  # Local flag tracking that the player has completed the task
    }
    else {
        # If the hand-in isn't correct, return items
        plugin::return_items(\%itemcount);
    }
}
