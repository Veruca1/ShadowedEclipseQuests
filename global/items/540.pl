sub EVENT_ITEM_CLICK {
    my $item_id = 540;  # ID of the item being clicked (Checks My Bank)
    my $npc_id = 1668;  # ID of the portable banker NPC

    if ($itemid == $item_id) {  # Check if the clicked item ID matches
        # Check if the player has aggro (is in combat with any NPC)
        if ($client->GetAggroCount() > 0) {
            quest::message(314, "You cannot use this while in combat with an enemy.");
            return;
        }

        # Check if the NPC is already spawned
        if (!quest::isnpcspawned($npc_id)) {
            # If not spawned, proceed to spawn the NPC
            my $x = $client->GetX();
            my $y = $client->GetY();
            my $z = $client->GetZ();
            my $h = $client->GetHeading();

            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);  # Spawn at player's location
            quest::say("A portable banker appears, ready to assist you with your banking needs. It will vanish after two minutes.");
        } else {
            quest::message(314, "A portable banker is already available.");
        }
    }
}