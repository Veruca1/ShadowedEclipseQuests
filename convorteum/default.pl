my $is_boss      = 0;
my $scaled_spawn = 0;  # block double scaling

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusion list
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    # ✅ Determine which Era plugin to use (pass $npc)
    my $era = plugin::DetermineEra($npc, $entity_list);

    # ✅ Apply baseline stats from that Era plugin
    plugin::ApplyEraStats($npc, $era, $is_boss);

    # ✅ Apply raid scaling immediately at spawn
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    # ✅ Safe green debug to players in-zone
    $entity_list->MessageClose(
        $npc, 1, 200, 18,
        "Spawn initialized with $era stats."
    );

    # ✅ Also log to server debug
    plugin::Debug("Spawn [$raw_name] using $era stats (NPCID $npc_id).");
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        # ✅ ensure raid scaling adjusts if players add boxes after spawn
        if (!$scaled_spawn) {
            my $era = plugin::DetermineEra($npc, $entity_list);
            plugin::ApplyEraStats($npc, $era, $is_boss);

            plugin::RaidScaling($entity_list, $npc);  # visible + explicit
            $scaled_spawn = 1;

            plugin::Debug("Re-applied stats during combat for [$raw_name] (NPCID $npc_id) using $era era.");
        }

        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain" && $is_boss) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;
        my $radius = 50;
        my $dmg = 40000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }

        plugin::Debug("Life drain pulse triggered by [$raw_name] (NPCID $npc_id) dealing $dmg dmg in $radius range.");
    }
}