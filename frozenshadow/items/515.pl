sub EVENT_ITEM_CLICK {
    # Define the NPC IDs that the item can affect
    my $npc_id_1 = 1618;
    my $npc_id_2 = 1624;

    # Get the item that was clicked
    my $questitem = $questitem->GetItem();

    # Check if the item used is the specific one (ID 515)
    if ($questitem->GetID() == 515) {
        # Get the targeted NPC
        my $npc = $client->GetTarget();

        if ($npc) {
            # Check if the target's NPC ID matches one of the valid IDs and is within 100 range
            my $npc_type_id = $npc->GetNPCTypeID();
            if (($npc_type_id == $npc_id_1 || $npc_type_id == $npc_id_2) 
                && $client->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) <= 100) {
                # Instantly kill the NPC
                $npc->Damage($npc, $npc->GetHP(), 0, 36901);  # 36901 is the spell ID for the damage
                $npc->Say("The item releases a powerful energy, slaying the creature!");
            }
            else {
                # If the target is not the correct NPC or is out of range
                $client->Message(13, "The creature is too far away or is not affected by this item.");
            }
        }
        else {
            # If no NPC is targeted
            $client->Message(13, "You must target a creature to use this item.");
        }
    }
    else {
        # If the wrong item is used
        $client->Message(13, "This item has no effect on the creature.");
    }
}
