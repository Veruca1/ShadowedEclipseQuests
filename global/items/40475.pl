sub EVENT_ITEM_CLICK {
    my $item_id = 40475;

    if ($itemid == $item_id) {
        if ($client->GetAggroCount() > 0) {
            quest::message(314, "You cannot use this while in combat with an enemy.");
            return;
        }

        my $char_id = $client->CharacterID();
        my $bucket_key = "easter_donator_dizzy_$char_id";

        # Set permanent flag
        quest::set_data($bucket_key, 1);

        my $x = $client->GetX();
        my $y = $client->GetY();
        my $z = $client->GetZ();
        my $h = $client->GetHeading();

        # Spawn Dizzy and set a timer for despawn
        my $npc_id = quest::spawn2(1967, 0, 0, $x, $y, $z, $h);
        quest::settimer("despawn_dizzy_$npc_id", 60);
        $client->Message(15, "Dizzy appears and offers you teleport options.");
    }
}

sub EVENT_TIMER {
    if ($timer =~ /^despawn_dizzy_(\d+)$/) {
        my $npc_id = $1;
        my $npc = $entity_list->GetNPCByID($npc_id);
        if ($npc) {
            $npc->Depop();
        }
        quest::stoptimer($timer);
    }
}
