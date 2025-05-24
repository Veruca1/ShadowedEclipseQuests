sub EVENT_ITEM_CLICK {
    # Define the only NPC ID that the item can affect
    my $valid_npc_id = 1966;

    # Get the item that was clicked
    my $questitem = $questitem->GetItem();

    # Check if the item used is the specific one (ID 515)
    if ($questitem->GetID() == 515) {
        # Get the targeted NPC
        my $npc = $client->GetTarget();

        if ($npc) {
            # Check if the target's NPC ID matches and is within 100 range
            my $npc_type_id = $npc->GetNPCTypeID();
            if ($npc_type_id == $valid_npc_id 
                && $client->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) <= 1000) {
                # Instantly kill the NPC
                $npc->Damage($npc, $npc->GetHP(), 0, 36901);  # 36901 is the spell ID for the damage
                $npc->Say("The item releases a powerful energy, slaying the creature!");
            }
            else {
                $client->Message(13, "The creature is too far away or is not affected by this item.");
            }
        }
        else {
            $client->Message(13, "You must target a creature to use this item.");
        }
    }
    else {
        $client->Message(13, "This item has no effect on the creature.");
    }
}