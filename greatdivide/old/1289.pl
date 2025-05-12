sub EVENT_SAY {
    if ($text=~/hail/i) {
        my $zone_id = 20;                  # Zone ID for Kithicor
        my $instance_id = 101;             # Existing Instance ID
        my $x = 3828;                      # X coordinate for the spawn point
        my $y = 1889;                      # Y coordinate for the spawn point
        my $z = 459;                       # Z coordinate for the spawn point
        my $heading = 0;                   # Heading for the spawn point

        # Check if the player is in a group
        my $group = $client->GetGroup();

        # Move the player to the existing instance of Kithicor (zone ID 20)
        quest::MovePCInstance($zone_id, $instance_id, $x, $y, $z, $heading);

        # If the player is in a group, move each group member to the same location in the existing instance
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                if ($member && $member->IsClient()) {
                    my $member_client = $member->CastToClient();
                    quest::MovePCInstance($zone_id, $instance_id, $x, $y, $z, $heading);
                }
            }
        }
    }
}
