sub EVENT_SPAWN {
    $npc->Shout("This ends now!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("check_back_item", 1);    # Check back slot every second
    } else {
        quest::stoptimer("check_back_item");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_back_item") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 500; # Adjust if needed
        my $entity_list = $entity_list;

        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $back_item = $client->GetItemIDAt(8); # Slot 8 = Back
                if ($back_item != 30583) {
                    $npc->Shout("Without the protective item, you are obliterated by Vulak's wrath!");
                    $client->BuffFadeAll(); # Strip all buffs
                    $client->Kill();         # Kill player
                }
            }
        }
    }
}