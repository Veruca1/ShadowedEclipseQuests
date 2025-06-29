# 1352.pl - Sanctum of Dust Controller

my @watcher_ids = (1960, 1961, 1962, 1963);
my $boss_placeholder_id = 1959;
my $boss_active_id = 1958;
my $debuff_id = 40732;

sub EVENT_SPAWN {
    # Start monitoring for watcher debuffs to spawn the real boss
    quest::settimer("check_for_spawn", 1);

    # Clean up any leftover mobs
    despawn_npcs_by_id(@watcher_ids, $boss_placeholder_id);

    # Spawn watchers and placeholder boss
    quest::unique_spawn(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
    quest::unique_spawn(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
    quest::unique_spawn(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
    quest::unique_spawn(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
    quest::unique_spawn($boss_placeholder_id, 0, 0, 255.86, -1862.38, -144.28, 489.25);
}

sub EVENT_SIGNAL {
    if ($signal == 4) {
        # Boss died — respawn everything in 7 minutes
        quest::settimer("spawn_watchers", 420);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_watchers") {
        quest::stoptimer("spawn_watchers");

        despawn_npcs_by_id(@watcher_ids, $boss_placeholder_id);

        # Respawn watchers and placeholder
        quest::spawn2(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
        quest::spawn2(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
        quest::spawn2(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
        quest::spawn2(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
        quest::spawn2($boss_placeholder_id, 0, 0, 255.86, -1862.38, -144.28, 489.25);
    }

    elsif ($timer eq "check_for_spawn") {
        my $all_debuffed = 1;

        foreach my $npc_type (@watcher_ids) {
            my $mob = $entity_list->GetNPCByNPCTypeID($npc_type);
            if (!$mob || !$mob->FindBuff($debuff_id)) {
                $all_debuffed = 0;
                last;
            }
        }

        my $placeholder = $entity_list->GetNPCByNPCTypeID($boss_placeholder_id);
        my $active_boss = $entity_list->GetNPCByNPCTypeID($boss_active_id);

        # If all watchers are debuffed, placeholder is up, and active boss is not yet spawned
        if ($all_debuffed && $placeholder && !$active_boss) {
            my ($x, $y, $z, $h) = ($placeholder->GetX(), $placeholder->GetY(), $placeholder->GetZ(), $placeholder->GetHeading());
            $placeholder->Depop();
            quest::spawn2($boss_active_id, 0, 0, $x, $y, $z, $h);
        }
    }
}

sub despawn_npcs_by_id {
    foreach my $npcid (@_) {
        my $mob = $entity_list->GetNPCByNPCTypeID($npcid);
        $mob->Depop(1) if $mob;
    }
}