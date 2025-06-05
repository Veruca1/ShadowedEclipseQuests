sub EVENT_ITEM_CLICK {
    my $client = $entity_list->GetClientByID($userid);
    return unless $client && $client->IsClient();

    # Get the current time
    my $current_time = time();

    # Get the account ID to use in the bucket key
    my $account_id = $client->AccountID();

    # Generate a unique bucket key using the account ID
    my $bucket_key = "MagefireItem-" . $account_id;

    # Retrieve the last time the item was used from the "MagefireItem" bucket associated with the account
    my $last_used_time = $client->GetBucket($bucket_key) || 0;

    # Check if five seconds (15 seconds) have passed since the last use
    if (($current_time - $last_used_time) >= 15) {
        # Define the radius and damage amount
        my $radius = 50;
        my $damage = 10000;

        # Get the location of the client (caster)
        my $x = $client->GetX();
        my $y = $client->GetY();
        my $z = $client->GetZ();

        # Find NPCs in the specified radius
        my @npc_list = $entity_list->GetNPCList();
        foreach my $npc (@npc_list) {
            # Check if the NPC is valid, within the radius, and is not a pet
            if ($npc && $npc->IsNPC() && !$npc->IsPet() && $npc->CalculateDistance($x, $y, $z) <= $radius) {
                # Apply damage to the NPC
                if ($npc->GetHP() > 0 && !$npc->IsCorpse()) {
                    $npc->Damage($client, $damage, 0, 0, 0, -1, 0);
                    $client->Message(15, "Your attack engulfs " . $npc->GetCleanName() . " in Magefire for $damage damage.");
                }
            }
        }

        # Inform the player of the successful use of the item's effect
        $client->Message(15, "You channel the essence of Flame, engulfing those around you in Magefire!");

        # Update the last used time to the current time in the "MagefireItem" bucket for the account
        $client->SetBucket($bucket_key, $current_time);

    } else {
        # Calculate how much time is left on the cooldown
        my $time_left = 5 - ($current_time - $last_used_time);
        my $seconds_left = $time_left > 0 ? $time_left : 0;

        # Inform the player that the item is still on cooldown
        $client->Message(15, "The power of Flame has not fully recharged. Try again in $seconds_left seconds.");
    }
}