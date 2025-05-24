sub EVENT_ITEM_CLICK {
    return unless defined($client) && $client->IsClient();
    return unless defined($itemid) && $itemid == 33212;

    my $char_id = $client->CharacterID();
    my $current_zone = $zoneid;

    my %zone_flags = (
        156 => "paludal",
        153 => "echo",
    );

    return unless exists $zone_flags{$current_zone};

    my $prefix = $zone_flags{$current_zone};
    my $boss_flag_key = "${prefix}_boss_unlock_$char_id";
    my $checkpoint_flag_key = "${prefix}_checkpoint_unlock_$char_id";

    my $saylink_checkpoint = quest::saylink("checkpoint", 1);
    my $saylink_boss = quest::saylink("boss", 1);

    if ($current_zone == 153) {
        my $checkpoint_flag = quest::get_data($checkpoint_flag_key);
        my $boss_flag = quest::get_data($boss_flag_key);

        if ($checkpoint_flag) {
            if ($boss_flag) {
                quest::say("Where would you like to go? $saylink_checkpoint or $saylink_boss?");
            } else {
                quest::say("The path to the boss is blocked... perhaps defeating a powerful guardian could unlock it. You may still say $saylink_checkpoint to proceed.");
            }
        } else {
            quest::say("Both paths are currently blocked. Perhaps something within these caverns holds the key to progress.");
        }
        return;
    }

    # Default logic for other zones
    my $boss_flag = quest::get_data($boss_flag_key);

    if ($boss_flag) {
        quest::say("Where would you like to go? $saylink_checkpoint or $saylink_boss?");
    } else {
        quest::say("The path to the boss is blocked... perhaps defeating a powerful guardian could unlock it. You may still say $saylink_checkpoint to proceed.");
    }
}