# This script continuously checks and enforces the limit of 2 active NPCs with ID 1602

sub EVENT_SPAWN {
    # Start a timer to check every 5 seconds (adjust as needed)
    quest::settimer("check_1602_count", 5);
}

sub EVENT_TIMER {
    if ($timer eq "check_1602_count") {
        # Count all NPCs with ID 1602 in the zone
        my $npc_count = quest::countspawnednpcs([1602]);

        # If there are more than 2, depop the extras
        if ($npc_count > 2) {
            my $excess = $npc_count - 2;

            # Depop the excess NPCs
            foreach my $npc ($entity_list->GetNPCList()) {
                if ($npc->GetNPCTypeID() == 1602 && $excess > 0) {
                    $npc->Depop();
                    $excess--;
                }
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the timer when this NPC dies
    quest::stoptimer("check_1602_count");
}
