my $client = $entity_list->GetClientByID($client_id);
if ($client) {
    $client->Kill();
}

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
my $spawned_engage_timer_countdown = 60; # Starting countdown time in seconds

my $disable_loc1 = 0; # 1135.00 loc (124008)
my $disable_loc2 = 0; # -782.00 loc (1916)
my $disable_loc3 = 0; # -1903.00 loc (124017)

sub EVENT_SPAWN {
    if ($instanceversion == 0) {
        # Initial spawn for version 0 (just for example, adjust as needed)
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

    # Dynamic selection of available NPCs
    my @npc_ids;
    push @npc_ids, 124008 unless $npc_124008_defeated;
    push @npc_ids, 1916   unless $npc_1916_defeated;
    push @npc_ids, 124017 unless $npc_124017_defeated;

    # Exit early if all are defeated
    if (!@npc_ids) {
        quest::shout("All first phase NPCs defeated! Starting next phase soon...");
        quest::settimer("random_spawn2", 10);  # Placeholder — define later
        return;
    }

    # Select a random NPC ID
    my $npc_id = $npc_ids[int(rand(@npc_ids))];

    # Spawn logic unchanged
    my %locations = (
        124008 => [1135.00, -1070.00, -119.78, 385, 60],
        1916   => [-467.00, -389.00, 11.35, 382, 40],
        124017 => [-1903.00, -1039.00, -12.90, 128, 60]
    );

    my $loc = $locations{$npc_id};
    $spawned_npc_id = quest::spawn2($npc_id, 0, 0, @$loc[0..3]);
    $spawned_engage_timer = $loc->[4];
    quest::settimer("countdown_timer", 1);
    }

    # Countdown for remaining time
    elsif ($timer eq "countdown_timer") {
    return if $combat_engaged;  # Timer stops doing anything if combat has started

    quest::shout(" $spawned_engage_timer seconds.");
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

        quest::shout("Time's up! The NPC has been removed.");
}
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1 && $instance_1_active == 1) {
        quest::shout("Ahhhhhhh my prized possession finally arrives. Welcome, to my playground of dragons!");
	quest::settimer("random_spawn", 20);
    }
    elsif ($signal == 100) {
        $signal_100_count++;
        if ($signal_100_count == 8) {
            quest::spawn2(124078, 0, 0, -700, -1080, 6.98, 127);
        }
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
        if ($signal_102_count == 8) {
            quest::spawn2(124037, 0, 0, -1281.00, -1080.00, -15.40, 130);
        }
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
        if ($signal_201_count == 7) {
            quest::spawn2(2001738, 0, 0, 1135.00, -1070.00, -119.78, 385);
        }
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
        if ($signal_301_count == 2) {
            quest::spawn2(2001728, 0, 0, -782.00, 208.00, 98.73, 256);
        }
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

elsif ($signal == 998) {  # 124008 defeated
    $npc_124008_defeated = 1;
    quest::shout("124008 defeated. Respawning soon...");
    quest::settimer("random_spawn", 15);  # Restart spawn after short delay
}
elsif ($signal == 997) {  # 1916 defeated
    $npc_1916_defeated = 1;
    quest::shout("1916 defeated. Respawning soon...");
    quest::settimer("random_spawn", 15);
}
elsif ($signal == 996) {  # 124017 defeated
    $npc_124017_defeated = 1;
    quest::shout("124017 defeated. Respawning soon...");
    quest::settimer("random_spawn", 15);
}

    elsif ($signal == 999) {
        $combat_engaged = 1;
        quest::stoptimer("countdown_timer");
        quest::shout("Combat engaged! Countdown stopped.");
    }
}

sub EVENT_COMBAT {
    # Only run this if it's the spawned NPC that engaged
    if ($npcid == $spawned_npc_id && $combat_state == 1) {
        $combat_engaged = 1;
        quest::stoptimer("countdown_timer");
        quest::shout("Combat engaged — timer stopped!");
    }
}

sub check_all_wave1_dead {
    if ($npc_124008_defeated && $npc_1916_defeated && $npc_124017_defeated) {
        quest::shout("All wave 1 NPCs are down. Preparing for the second wave...");
        quest::settimer("random_spawn2", 10);  # This can be updated with the actual next rotation
    }
}