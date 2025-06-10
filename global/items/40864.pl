sub EVENT_ITEM_CLICK {
    my @valid_zones = (163, 167, 160, 169, 165, 162, 154, 179, 164, 153, 157, 171, 173, 156, 175, 172, 170);
    my $cooldown_seconds = 30;
    my $cooldown_var = "hammer_maiden_cd";

    # Check level requirement
    if ($ulevel < 61) {
        $client->Message(15, "You are not powerful enough to wield the Hammer of the Maiden.");
        return;
    }

    # Check zone
    my $zone_ok = 0;
    foreach my $zid (@valid_zones) {
        if ($zoneid == $zid) {
            $zone_ok = 1;
            last;
        }
    }

    if (!$zone_ok) {
        $client->Message(15, "The Hammer of the Maiden has no power in this land.");
        return;
    }

    # Cooldown check
    my $last_use = $client->GetBucket($cooldown_var);
    my $now = time();
    if (defined $last_use && ($now - $last_use) < $cooldown_seconds) {
        my $remain = $cooldown_seconds - ($now - $last_use);
        $client->Message(15, "The hammer is still recharging. ($remain seconds remaining)");
        return;
    }

    # Set cooldown
    $client->SetBucket($cooldown_var, $now);

    # Damage all NPCs within 30 radius
    my @npcs = $entity_list->GetNPCList();
    foreach my $npc (@npcs) {
        if ($npc && !$npc->IsPet() && !$npc->IsCorpse() && $npc->IsAttackable() && $npc->GetHPRatio() > 0) {
            my $dist = $npc->CalculateDistance($client->GetX(), $client->GetY(), $client->GetZ());
            if ($dist <= 30) {
                $npc->Damage($client, 140000, 0, true); # Instant damage
            }
        }
    }

    # Camera shake effect
    $client->CameraEffect(1000, 2.0);

    # Flavor text
    $client->Message(13, "You slam the Hammer of the Maiden into the ground, shaking the earth around you!");
}