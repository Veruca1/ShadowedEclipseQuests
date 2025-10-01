sub EVENT_CLICKDOOR {
    if ($doorid == 8) {
        my $key_id = 56755;

        # Check if player has the key in inventory OR on keyring
        if (!$client->CountItem($key_id) && !$client->KeyRingCheck($key_id)) {
            $client->Message(13, "You must possess the correct key to activate this portal.");
            return;
        }

        # Teleport
        my $instance_id = $client->GetInstanceID();
        if (defined $instance_id && $instance_id != 0) {
            quest::MovePCInstance(491, $instance_id, 1123.99, -819.13, 256.57, 330);
        } else {
            quest::movepc(491, 1123.99, -819.13, 256.57, 330);
        }

        # Add to keyring if not already present
        if (!$client->KeyRingCheck($key_id)) {
            eval {
                $client->KeyRingAdd($key_id);
                plugin::Debug("Key $key_id added to keyring for " . $client->GetName());
            };
        }
    }
}