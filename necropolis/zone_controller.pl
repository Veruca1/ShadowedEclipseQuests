my @locations = (
    [-455.75, 1396.15, 11.30, 288.25],
    [-448.12, 1296.67, 11.30, 282.75],
    [-472.40, 1146.98, 11.30, 291.50],
    [-430.58, 1060.26, 11.30, 204.50],
    [-380.98, 935.15, 11.30, 282.25],
    [-433.39, 867.00, 11.30, 329.75],
    [-394.74, 732.18, 11.29, 244.25],
    [-650.66, 647.95, 11.29, 346.00],
    [-717.52, 728.13, 11.29, 489.00],
    [-767.97, 903.73, 11.29, 2.25],
    [-797.20, 1035.83, 11.29, 486.00],
    [-780.33, 1167.24, 11.29, 8.50],
    [-778.89, 1300.82, 11.29, 497.75],
    [-739.47, 1379.21, 11.29, 29.75],
    [-670.46, 1511.77, 11.29, 43.00],
    [-684.68, 1642.07, 11.29, 414.75],
    [-852.39, 1660.35, 11.29, 358.75],
    [-920.73, 1567.21, 11.29, 268.75],
    [-936.81, 1449.82, 11.29, 253.25],
    [-955.38, 1357.38, 11.29, 284.50],
    [-930.42, 1253.73, 11.29, 222.00],
    [-997.55, 1082.85, 11.29, 277.25],
    [-945.12, 892.90, 11.29, 388.75],
    [-917.82, 635.87, 11.29, 192.50],
    [-1023.36, 614.79, 10.67, 277.50],
    [-1101.89, 458.90, 10.67, 373.00],
    [-1284.62, 543.03, 10.67, 434.00],
    [-1361.40, 617.11, 10.67, 471.75],
    [-1440.46, 713.91, 10.67, 427.25],
    [-1595.59, 700.83, 10.67, 367.50],
    [-1648.16, 575.37, 10.67, 255.00],
    [-1605.60, 418.76, 10.67, 240.00],
    [-1585.09, 226.44, 10.67, 281.25],
    [-1648.93, 86.61, 10.67, 326.25],
    [-1792.12, 566.20, 10.67, 491.25],
    [-1837.87, 747.57, 10.67, 15.00],
    [-1844.87, 873.00, 10.67, 23.00],
    [-1837.67, 1031.02, 10.67, 58.50],
    [-1686.26, 1097.42, 10.67, 81.00],
    [-1661.50, 1204.90, 10.67, 507.25],
    [-1621.34, 1320.12, 10.67, 25.25],
    [-2092.77, 836.36, 10.67, 251.00],
    [-2197.60, 702.34, 10.67, 276.50],
    [-2285.83, 603.77, 10.66, 257.25],
    [-2226.25, 488.66, 10.66, 154.25],
    [-2074.38, 438.48, 10.66, 154.25],
    [-2028.74, 247.79, 10.66, 280.25],
    [-1966.57, 112.16, 10.66, 189.25],
    [-1993.59, -9.74, 10.66, 299.75],
    [-2124.99, -109.48, 10.66, 348.50],
    [-2261.91, -48.48, 10.66, 440.00],
    [-2340.00, 76.41, 10.66, 476.00],
    [-2419.46, 161.21, 10.66, 432.75],
    [-2543.94, 324.54, 10.66, 422.00],
    [-2676.93, 272.29, 10.66, 316.75],
    [-2531.01, 79.86, 10.66, 52.25]
);

my $current_index = 0;
my $pause_movement = 0;  # Flag to pause movement
my $signal5_count = 0;    # Count of killed spiders
my $kill_time_remaining = 300;  # Countdown time in seconds (5 min)

sub EVENT_SPAWN {
    if (!quest::isnpcspawned(1801)) {
        quest::settimer("npc_cycle", 1);
    }
}

sub EVENT_TIMER {
    if ($timer eq "npc_cycle" && !$pause_movement) {  
        if (!quest::isnpcspawned(1801)) {
            if (scalar(@locations) > 0) {
                my ($x, $y, $z, $h) = @{$locations[$current_index]};
                quest::spawn2(1801, 0, 0, $x, $y, $z, $h);
            }
        } else {
            quest::depop(1801);
            if (scalar(@locations) > 0) {
                $current_index = ($current_index + 1) % scalar(@locations);
            }
        }
    }
    elsif ($timer eq "respawn_delay") {
        quest::stoptimer("respawn_delay");
        $pause_movement = 0;
        quest::settimer("npc_cycle", 1);
    }
    elsif ($timer eq "kill_timer") {  
        $kill_time_remaining -= 10;  

        if ($kill_time_remaining == 240) { quest::shout("4 minutes remaining!"); }
        elsif ($kill_time_remaining == 180) { quest::shout("3 minutes remaining!"); }
        elsif ($kill_time_remaining == 120) { quest::shout("2 minutes remaining!"); }
        elsif ($kill_time_remaining == 60) { quest::shout("1 minute remaining!"); }
        elsif ($kill_time_remaining == 10) { quest::shout("10 seconds remaining!"); }

        if ($kill_time_remaining <= 0) {  
            quest::stoptimer("kill_timer");  
            quest::shout("Time's up! You failed to kill 40 spiders in time.");  
            
            quest::depopall(1802);  # Ensure all 1802s are removed
            quest::shout("All remaining spiders have vanished!");  # Debug message
            
            $signal5_count = 0;  # Reset counter
        }
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {  
        quest::stoptimer("npc_cycle");
        quest::settimer("respawn_delay", 300);
    }
    elsif ($signal == 2) {  
        $pause_movement = 1;
        quest::stoptimer("npc_cycle");  
    }
    elsif ($signal == 3) {  
        $pause_movement = 0;
        quest::settimer("npc_cycle", 1);
    }
    elsif ($signal == 4) {  
        quest::shout("You have 5 minutes to kill 40 spiders or the event will fail. You will need to start again with Gilthanas Norrathis!");
        $kill_time_remaining = 300;  
        quest::settimer("kill_timer", 10);  

        foreach my $loc (@locations) {
            my ($x, $y, $z, $h) = @$loc;
            quest::spawn2(1802, 0, 0, $x, $y, $z, $h);
        }
    }
    elsif ($signal == 5) {  
        $signal5_count++;  
        quest::shout("Spiders Killed: $signal5_count");

        if ($signal5_count >= 40) {  
            if (!quest::isnpcspawned(123154)) {  
                quest::spawn2(123154, 0, 0, -1248.88, 897.22, 10.70, 104.75);  
                quest::shout("Queen Raltaas has Arrived!");

                quest::stoptimer("kill_timer");  
                quest::depopall(1802);  
            }
        }
    }
}