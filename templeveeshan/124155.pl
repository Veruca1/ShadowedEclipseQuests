sub EVENT_SPAWN {
    $npc->Shout("This ends now!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("check_back_item", 1);    # Check back slot every second
        quest::settimer("first_knockback", 10);   # First knockback after 10 seconds
    } else {
        quest::stoptimer("check_back_item");
        quest::stoptimer("first_knockback");
        quest::stoptimer("repeat_knockback");
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

    if ($timer eq "first_knockback") {
        do_mass_knockback();
        quest::settimer("repeat_knockback", 60);  # Next knockback in 60 seconds
        quest::stoptimer("first_knockback");
    }

    if ($timer eq "repeat_knockback") {
        do_mass_knockback();
    }
}

sub do_mass_knockback {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 500; # Knockback range

    # Destination you want to fling them to
    my $dest_x = -741.37;
    my $dest_y = 1201.14;
    my $dest_z = 124;
    my $dest_heading = 255.25;

    my $zone_id = $npc->GetZoneID(); # Safer to pull dynamically, just in case

    foreach my $client ($entity_list->GetClientList()) {
        my $distance = $client->CalculateDistance($npc_x, $npc_y, $npc_z);
        if ($distance <= $radius) {
            my $instance_id = $client->GetInstanceID();
            $client->MovePCInstance($zone_id, $instance_id, $dest_x, $dest_y, $dest_z, $dest_heading);
            $client->Message(4, "You are hurled across the battlefield!");
        }
    }

    foreach my $bot ($entity_list->GetBotList()) {
        my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
        if ($distance <= $radius) {
            # Bots can't be moved with MovePCInstance normally.
            # You could despawn them and respawn near player if needed, but normally safe to ignore.
        }
    }

    quest::shout("Feel the wrath of Veeshan’s chosen!");
}
