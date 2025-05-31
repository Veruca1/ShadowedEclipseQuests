# 1352.pl - Boss Controller

my $signal_count = 0;
my $invul_stack = 0;

sub EVENT_SPAWN {
    # NPC ID, x, y, z, heading
    quest::spawn2(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
    quest::spawn2(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
    quest::spawn2(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
    quest::spawn2(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
    quest::spawn2(1959, 0, 0, 255.86, -1862.38, -144.28, 489.25);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        $signal_count++;

        if ($signal_count >= 4) {
            $signal_count = 0;

            my @watch_npcs = (1960, 1961, 1962, 1963);
            my $all_debuffed = 1;

            foreach my $npc_type (@watch_npcs) {
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

                if (!$found) {
                    $all_debuffed = 0;
                }
            }

            my $boss_old    = $entity_list->GetNPCByNPCTypeID(1959);
            my $boss_active = $entity_list->GetNPCByNPCTypeID(1958);

            if ($all_debuffed) {
                if ($boss_old) {
                    my ($x, $y, $z, $h) = ($boss_old->GetX(), $boss_old->GetY(), $boss_old->GetZ(), $boss_old->GetHeading());
                    $boss_old->Depop();
                    quest::spawn2(1958, 0, 0, $x, $y, $z, $h);
                } elsif ($boss_active) {
                    $boss_active->SetInvul(0);
                }
            } else {
                if ($boss_active) {
                    $boss_active->SetInvul(1);
                }
            }
        }

    } elsif ($signal == 2) {
        $invul_stack++;
        my $boss_active = $entity_list->GetNPCByNPCTypeID(1958);
        if ($boss_active) {
            $boss_active->SetInvul(1);
        }

    } elsif ($signal == 3) {
        if ($invul_stack > 0) {
            $invul_stack--;

            if ($invul_stack == 0) {
                my $boss_active = $entity_list->GetNPCByNPCTypeID(1958);
                if ($boss_active) {
                    $boss_active->SetInvul(0);
                }
            }
        }

    } elsif ($signal == 4) {
        # Start 7-minute timer (420 seconds)
        quest::settimer("spawn_watchers", 420);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_watchers") {
        quest::stoptimer("spawn_watchers");

        # Spawn the five NPCs after delay
        quest::spawn2(1962, 0, 0, 246.22, -1680.14, -156.97, 74.25);
        quest::spawn2(1963, 0, 0, 133.27, -1848.22, -156.89, 62.25);
        quest::spawn2(1961, 0, 0, 399.97, -1765.68, -156.93, 489.00);
        quest::spawn2(1960, 0, 0, 432.35, -1877.35, -156.93, 489.00);
        quest::spawn2(1959, 0, 0, 255.86, -1862.38, -144.28, 489.25);
    }
}