sub EVENT_ITEM_CLICK {
    my @valid_zones = (163, 167, 160, 169, 165, 162, 154, 179, 164, 153, 157, 171, 173, 156, 175, 172, 170);
    my $cooldown_seconds = 30;
    my $cooldown_var = "hammer_maiden_cd";

    # Level check
    if ($ulevel < 61) {
        $client->Message(15, "You are not powerful enough to wield the Hammer of the Maiden.");
        return;
    }

    # Zone check
    my $zone_ok = grep { $_ == $zoneid } @valid_zones;
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

    # AoE damage to all nearby NPCs
    my @npcs = $entity_list->GetNPCList();
    my $hit = 0;

    foreach my $npc (@npcs) {
        next unless $npc;
        next if $npc->IsPet();
        next if $npc->IsCorpse();
        next if $npc->GetHPRatio() <= 0;

        my $dist = $npc->CalculateDistance($client->GetX(), $client->GetY(), $client->GetZ());
        if ($dist <= 30) {
            $npc->Damage($client, 500000, 0, true);
            $hit = 1;
        }
    }

    # Camera shake if it actually hits something
    if ($hit) {
        $client->CameraEffect(1000, 2.0);
        $client->Message(13, "You slam the Hammer of the Maiden into the ground, sending shockwaves through the earth doing 500k damage to enemies within a 30 raius!");
    } else {
        $client->Message(15, "Nothing is close enough to feel the hammer’s fury.");
    }
}