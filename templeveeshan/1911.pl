#Nyseria Taunting and Controller

my $client = $entity_list->GetClientByID($client_id);
if ($client) {
    $client->Kill();
}

my $npc_124074_defeated = 0;
my $npc_124103_defeated = 0;
my $npc_124077_defeated = 0;
my $npc_124076_defeated = 0;
my $npc_124008_defeated = 0;
my $npc_1916_defeated = 0;
my $npc_124017_defeated = 0;
my $combat_engaged = 0;
my $signal_100_count = 0;
my $signal_102_count = 0;
my $signal_201_count = 0;
my $signal_301_count = 0;
my $instance_1_active = 0;
my $spawned_npc_id;
my $spawned_engage_timer = 0;

sub EVENT_SPAWN {
    if ($instanceversion == 0) {
        quest::spawn2(124064, 0, 0, -459, -1768, -34.78, 258);
        quest::spawn2(124062, 0, 0, -539, -1768, -34.78, 258);
        quest::spawn2(124062, 0, 0, -527, -1660, 15.23, 175.75);
        quest::spawn2(124062, 0, 0, -472, -1660, 15.73, 375.75);
        quest::spawn2(124062, 0, 0, -472, -1460, 15.73, 375.75);
        quest::spawn2(124044, 0, 0, -472, -1560, 15.73, 375.75);
        quest::spawn2(124048, 0, 0, -527, -1560, 15.23, 175.75);
        quest::spawn2(124048, 0, 0, -527, -1460, 15.23, 175.75);
    } elsif ($instanceversion == 1) {
        $instance_1_active = 1;
    }
}

sub EVENT_TIMER {
    return unless $instanceversion == 1;

    if ($timer eq "random_spawn") {
        quest::stoptimer("random_spawn");

        # Block if there's an active NPC
        if ($spawned_npc_id && $entity_list->GetMobByID($spawned_npc_id)) {
            quest::shout("An NPC is already spawned — waiting until it is defeated or times out.");
            return;
        }

        # Phase 1 only
        my @npc_ids;
        push @npc_ids, 124008 unless $npc_124008_defeated;
        push @npc_ids, 1916   unless $npc_1916_defeated;
        push @npc_ids, 124017 unless $npc_124017_defeated;

        if (!@npc_ids) {
            #quest::shout("All first phase NPCs defeated! Starting next phase soon...");
            quest::settimer("random_spawn2", 10);
            return;
        }

        my $npc_id = $npc_ids[int(rand(@npc_ids))];

        my %locations = (
            124008 => [1135.00, -1070.00, -119.78, 385, 60],
            1916   => [-467.00, -389.00, 11.35, 382, 40],
            124017 => [-1903.00, -1039.00, -12.90, 128, 60],
        );

        my $loc = $locations{$npc_id};
        $spawned_npc_id = quest::spawn2($npc_id, 0, 0, @$loc[0..3]);
        $spawned_engage_timer = $loc->[4];
        $combat_engaged = 0;
        quest::settimer("countdown_timer", 1);
    }

    elsif ($timer eq "random_spawn2") {
    quest::stoptimer("random_spawn2");

    # Phase 2 only
    my @phase2_npcs;
    push @phase2_npcs, 124074 unless $npc_124074_defeated;
    push @phase2_npcs, 124103 unless $npc_124103_defeated;
    push @phase2_npcs, 124077 unless $npc_124077_defeated;
    push @phase2_npcs, 124076 unless $npc_124076_defeated;

    if (!@phase2_npcs) {
        #quest::shout("All second phase NPCs defeated!");
        quest::shout("The air grows still... something stirs in the distance.");
        quest::settimer("final_phase", 15);  # Start 15s countdown to final boss
        return;
    }

    my $npc_id = $phase2_npcs[int(rand(@phase2_npcs))];

    my %locations = (
        124074 => [-1267.00, -50.00, 89.98, 80, 60],
        124076 => [-59.00, -269.00, 38.85, 505, 60],
        124077 => [-1700.00, 197.00, 79.98, 16, 60],
        124103 => [-124.00, 738.00, 70.10, 73, 60]
    );

    my $loc = $locations{$npc_id};
    $spawned_npc_id = quest::spawn2($npc_id, 0, 0, @$loc[0..3]);
    $spawned_engage_timer = $loc->[4];
    $combat_engaged = 0;
    quest::settimer("countdown_timer", 1);
    }

elsif ($timer eq "final_phase") {
    quest::stoptimer("final_phase");
    #quest::shout("The final guardian has appeared!");

    quest::spawn2(1915, 0, 0, -739.4, 517.2, 121, 510);
}

    elsif ($timer eq "countdown_timer") {
        return if $combat_engaged;

        quest::shout("$spawned_engage_timer");
        $spawned_engage_timer--;

        if ($spawned_engage_timer <= 0) {
            quest::stoptimer("countdown_timer");

            my $npc = $entity_list->GetMobByID($spawned_npc_id);
            if ($npc) {
                $npc->Depop();
            }

            my @clients = $entity_list->GetClientList();
            foreach my $c (@clients) {
                $c->Kill();
            }

            $spawned_npc_id = 0;
            #quest::shout("Time's up! The NPC has been removed.");
        }
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1 && $instance_1_active == 1 && !quest::isnpcspawned(1355)) {
        quest::shout("Ahhhhhhh my prized possession finally arrives. Welcome, to my playground of dragons!");
        quest::spawn2(1355, 0, 0, -503.69, -1242.68, 4.06, 0);
        quest::settimer("random_spawn", 20);
        my @spawn_points = (
            [-500.97, -1169.55, 2.88, 7.50],
            [-497.82, -965.10, 2.78, 261.75],
            [53.05, -1049.37, -21.26, 117.50],
            [-635.32, -1080.38, 5.58, 378.75],
            [-1308.11, -986.65, -14.40, 507.00],
            [-1642.33, -1090.68, -14.41, 5.75],
        );

        foreach my $point (@spawn_points) {
            my ($x, $y, $z, $h) = @$point;
            my $found = 0;

            foreach my $npc ($entity_list->GetNPCList()) {
                if ($npc->GetNPCTypeID() == 2137) {
                    my $dx = abs($npc->GetX() - $x);
                    my $dy = abs($npc->GetY() - $y);
                    my $dz = abs($npc->GetZ() - $z);

                    if ($dx < 10 && $dy < 10 && $dz < 10) {
                        $found = 1;
                        last;
                    }
                }
            }

            if (!$found) {
                quest::spawn2(2137, 0, 0, $x, $y, $z, $h);
            }
        }
    }
    elsif ($signal == 100) {
        $signal_100_count++;
        quest::spawn2(124078, 0, 0, -700, -1080, 6.98, 127) if $signal_100_count == 8;
    }
    elsif ($signal == 101) {
        quest::spawn2(2001747, 0, 0, -1699.00, -659.00, -12.90, 258);
        quest::spawn2(2001751, 0, 0, -1903.00, -1039.00, -12.90, 128);
        quest::spawn2(2001752, 0, 0, -1679.00, -1038.00, -12.90, 255);
        quest::spawn2(2001748, 0, 0, -1599.00, -1340.00, -12.90, 383);
        quest::spawn2(2001757, 0, 0, -1439.00, -1322.00, -12.90, 253);
        quest::spawn2(2001753, 0, 0, -1419.00, -1120.00, -12.90, 0);
        quest::spawn2(2001756, 0, 0, -1420.00, -1039.00, -12.90, 255);
        quest::spawn2(2001755, 0, 0, -1079.00, -1339.00, -12.90, 257);
    }
    elsif ($signal == 102) {
        $signal_102_count++;
        quest::spawn2(124037, 0, 0, -1281.00, -1080.00, -15.40, 130) if $signal_102_count == 8;
    }
    elsif ($signal == 103) {
        quest::spawn2(2001795, 0, 0, -297.00, -1079.00, 5.10, 0);
    }
    elsif ($signal == 200) {
        quest::spawn2(2001821, 0, 0, -210.00, -691.00, 0.10, 253);
        quest::spawn2(2001820, 0, 0, -195.00, -1350.00, 0.10, 128);
        quest::spawn2(2001815, 0, 0, 441.00, -1620.00, -59.78, 384);
        quest::spawn2(2001815, 0, 0, 631.00, -1450.00, -59.78, 128);
        quest::spawn2(2001815, 0, 0, 679.00, -1083.00, -59.78, 0);
        quest::spawn2(2001761, 0, 0, 860.00, -932.00, -133.53, 0);
        quest::spawn2(2001815, 0, 0, 1130.00, -1009.00, -119.78, 253);
    }
    elsif ($signal == 201) {
        $signal_201_count++;
        quest::spawn2(2001738, 0, 0, 1135.00, -1070.00, -119.78, 385) if $signal_201_count == 7;
    }
    elsif ($signal == 202) {
        quest::spawn2(2001780, 0, 0, -499.00, -970.00, 6.35, 255);
    }
    elsif ($signal == 300) {
        quest::spawn2(2001719, 0, 0, -745.00, -573.00, 9.48, 176);
        quest::spawn2(2001722, 0, 0, -467.00, -389.00, 11.35, 382);
    }
    elsif ($signal == 301) {
        $signal_301_count++;
        quest::spawn2(2001728, 0, 0, -782.00, 208.00, 98.73, 256) if $signal_301_count == 2;
    }
    elsif ($signal == 400) {
        quest::spawn2(2001726, 0, 0, -1267.00, -50.00, 89.98, 80);
        quest::spawn2(2001735, 0, 0, -59.00, -269.00, 38.85, 505);
        quest::spawn2(2001791, 0, 0, -1700.00, 197.00, 79.98, 16);
        quest::spawn2(2001819, 0, 0, -124.00, 738.00, 70.10, 73);
        quest::spawn2(2001794, 0, 0, -150.00, 974.00, 130.10, 357);
        quest::spawn2(2001793, 0, 0, -1644.00, 1622.00, 189.98, 315);
        quest::spawn2(2001789, 0, 0, -1761.00, 1604.00, 189.98, 144);
        quest::spawn2(2001788, 0, 0, -1260.00, 1947.00, 179.98, 255);
        quest::spawn2(2001790, 0, 0, -1333.00, 1799.00, 179.98, 126);
        quest::spawn2(2001792, 0, 0, -1258.00, 1652.00, 179.98, 510);
    }

elsif ($signal == 500) {
    quest::spawn2(1355, 0, 0, -503.69, -1242.68, 4.06, 0);
}
    elsif ($signal == 998) {
        $npc_124008_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124008 defeated. Respawning soon...");
        quest::settimer("random_spawn", 15);
    }
    elsif ($signal == 997) {
        $npc_1916_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("1916 defeated. Respawning soon...");
        quest::settimer("random_spawn", 15);
    }
    elsif ($signal == 996) {
        $npc_124017_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124017 defeated. Respawning soon...");
        quest::settimer("random_spawn", 15);
    }
    elsif ($signal == 995) {
        $npc_124074_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124074 defeated. Respawning soon...");
        quest::settimer("random_spawn2", 15);
    }
    elsif ($signal == 994) {
        $npc_124103_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124103 defeated. Respawning soon...");
        quest::settimer("random_spawn2", 15);
    }
    elsif ($signal == 993) {
        $npc_124077_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124077 defeated. Respawning soon...");
        quest::settimer("random_spawn2", 15);
    }
    elsif ($signal == 992) {
        $npc_124076_defeated = 1;
        $spawned_npc_id = 0;
        #quest::shout("124076 defeated. Respawning soon...");
        quest::settimer("random_spawn2", 15);
    }
    elsif ($signal == 899) {
        quest::shout("Let's see if you can become my new Arm, hahahaHA!");
        $npc->CameraEffect(1000, 3);    
    }
    elsif ($signal == 900) {
        if ($instance_1_active == 1 && $spawned_engage_timer > 0) {
            $spawned_engage_timer += 20;
            quest::shout("The countdown timer has been extended by 20 seconds! New timer: $spawned_engage_timer seconds.");
        }
    }
    elsif ($signal == 999) {
        $combat_engaged = 1;
        quest::stoptimer("countdown_timer");
        #quest::shout("Combat engaged! Countdown stopped.");
    }
}

sub EVENT_COMBAT {
    if ($npcid == $spawned_npc_id && $combat_state == 1) {
        $combat_engaged = 1;
        quest::stoptimer("countdown_timer");
        #quest::shout("Combat engaged — timer stopped!");
    }
}my $client = $entity_list->GetClientByID($client_id);
if ($client) {
    $client->Kill();
}