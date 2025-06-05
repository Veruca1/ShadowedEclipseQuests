# 1352.pl - Boss Controller

my $signal_count = 0;
my $invul_stack = 0;

# IDs of watchers and boss placeholder
my @watcher_ids = (1960, 1961, 1962, 1963);
my $boss_placeholder_id = 1959;
my $boss_active_id = 1958;

sub EVENT_SPAWN {
    despawn_npcs_by_id(@watcher_ids, $boss_placeholder_id);

    # Spawn unique watchers and placeholder
    quest::unique_spawn(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
    quest::unique_spawn(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
    quest::unique_spawn(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
    quest::unique_spawn(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
    quest::unique_spawn(1959, 0, 0, 255.86, -1862.38, -144.28, 489.25);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        $signal_count++;

        if ($signal_count >= 4) {
            $signal_count = 0;

            my $all_debuffed = 1;
            foreach my $npc_type (@watcher_ids) {
                my $found = 0;

                foreach my $mob ($entity_list->GetNPCList()) {
                    next unless $mob && $mob->IsNPC();
                    next unless $mob->GetNPCTypeID() == $npc_type;

                    $found = 1;
                    my $mob_id = $mob->GetID();
                    my $has_debuff = quest::get_data("wmu_has_debuff_$mob_id") || 0;

                    if (!$has_debuff) {
                        $all_debuffed = 0;
                        last;
                    }
                }

                $all_debuffed = 0 unless $found;
            }

            my $boss_old    = $entity_list->GetNPCByNPCTypeID($boss_placeholder_id);
            my $boss_active = $entity_list->GetNPCByNPCTypeID($boss_active_id);

            if ($all_debuffed) {
                if ($boss_old) {
                    my ($x, $y, $z, $h) = ($boss_old->GetX(), $boss_old->GetY(), $boss_old->GetZ(), $boss_old->GetHeading());
                    $boss_old->Depop();
                    quest::spawn2($boss_active_id, 0, 0, $x, $y, $z, $h);
                } elsif ($boss_active) {
                    $boss_active->SetInvul(0);
                }
            } else {
                $boss_active->SetInvul(1) if $boss_active;
            }
        }

    } elsif ($signal == 2) {
        $invul_stack++;
        my $boss_active = $entity_list->GetNPCByNPCTypeID($boss_active_id);
        $boss_active->SetInvul(1) if $boss_active;

    } elsif ($signal == 3) {
        if ($invul_stack > 0) {
            $invul_stack--;

            if ($invul_stack == 0) {
                my $boss_active = $entity_list->GetNPCByNPCTypeID($boss_active_id);
                $boss_active->SetInvul(0) if $boss_active;
            }
        }

    } elsif ($signal == 4) {
        quest::settimer("spawn_watchers", 420);  # 7 minutes
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_watchers") {
        quest::stoptimer("spawn_watchers");

        despawn_npcs_by_id(@watcher_ids, $boss_placeholder_id);

        quest::spawn2(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
        quest::spawn2(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
        quest::spawn2(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
        quest::spawn2(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
        quest::spawn2(1959, 0, 0, 255.86, -1862.38, -144.28, 489.25);
    }
}

sub despawn_npcs_by_id {
    foreach my $npcid (@_) {
        my $mob = $entity_list->GetNPCByNPCTypeID($npcid);
        $mob->Depop(1) if $mob;
    }
}