sub EVENT_SPAWN {
    return unless $npc;

    # Mark as boss for plugin logic
    $is_boss = 1;

    # Optional: Set faction (adjust or remove if unnecessary)
    $npc->SetNPCFactionID(623);

    # Set boss level
    $npc->ModifyNPCStat("level", 66);

    # Apply default boss stats and raid scaling
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);

    # Ensure proper HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    my @clientlist = $entity_list->GetClientList();
    foreach my $ent (@clientlist) {
        # Distance check: only nearby players get moved
        if ($ent->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) <= 100) {
            my $instance_id = $ent->GetInstanceID();
            $ent->MovePCInstance(207, $instance_id, -1094, 910, -746, 0);  # Zone: potorment (instance-safe)
        }
    }

    # Signal stomach trigger to spawn mobs
    quest::signal(207071);

    # Start depop timer (5 seconds)
    quest::settimer(1, 5);
}

sub EVENT_TIMER {
    quest::depop_withtimer();
}