sub EVENT_ENTER_ZONE {
    my $bucket_key = $client->CharacterID() . "-zone-version";
    my $zone_id = 20;  # Desired zone ID for Kithicor
    my $version = 1;    # Desired zone version
    my $x = 3828;       # X coordinate for the spawn point in the target zone
    my $y = 1889;       # Y coordinate for the spawn point in the target zone
    my $z = 459;        # Z coordinate for the spawn point in the target zone
    my $heading = 0;    # Heading for the spawn point

    # Check if the player has a data bucket set for the zone version
    if (quest::get_data($bucket_key) == $version) {
        # Move the player to the specified version of the zone
        quest::movepc($zone_id, $x, $y, $z, $heading);
    }
}
