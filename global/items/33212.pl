sub EVENT_ITEM_CLICK {
    return unless defined($client) && $client->IsClient();
    return unless defined($itemid) && $itemid == 33212;

    my $char_id = $client->CharacterID();
    my $current_zone = $zoneid;

    # Define supported zones and their respective flag prefixes
    my %zone_flags = (
        156 => "paludal",  # Paludal Caverns
        153 => "echo",     # Echo Caverns
        # Add more zones as needed
    );

    # Exit if not in a supported zone
    return unless exists $zone_flags{$current_zone};

    my $prefix = $zone_flags{$current_zone};
    my $flag_key = "${prefix}_boss_unlock_${char_id}";
    my $flag = quest::get_data($flag_key);

    my $saylink_checkpoint = quest::saylink("checkpoint", 1);
    my $saylink_boss = quest::saylink("boss", 1);

    # Echo Caverns has a unique message regardless of flag state
    if ($current_zone == 153) {
    my $checkpoint_flag = quest::get_data("echo_checkpoint_unlock_" . $char_id);
    my $boss_flag = quest::get_data("echo_boss_unlock_" . $char_id);

    if (defined($checkpoint_flag) && $checkpoint_flag == 1) {
        if (defined($boss_flag) && $boss_flag == 1) {
            quest::say("Where would you like to go? $saylink_checkpoint or $saylink_boss?");
        } else {
            quest::say("The path to the boss is blocked... perhaps defeating a powerful guardian could unlock it. You may still say $saylink_checkpoint to proceed.");
        }
    } else {
        quest::say("Both paths are currently blocked. Perhaps something within these caverns holds the key to progress.");
    }
    return;
}

    # Other zones like Paludal respond based on flag
    if (defined($flag) && $flag == 1) {
        quest::say("Where would you like to go? $saylink_checkpoint or $saylink_boss?");
    } else {
        quest::say("The path to the boss is blocked... perhaps defeating a powerful guardian could unlock it. You may still say $saylink_checkpoint to proceed.");
    }
}