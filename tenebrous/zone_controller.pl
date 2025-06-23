# zone_controller.pl

my @trigger_points = (
    { x => 1616.54, y => 232.71,  z => 647.45,  heading => 490.75, ground_z => 630.0 },
    { x => 1563.49, y => 443.98,  z => 659.06,  heading => 492.00, ground_z => 640.0 },
    { x => 1640.43, y => 728.45,  z => 682.25,  heading =>  45.75, ground_z => 660.0 },
    { x => 1550.88, y => 984.49,  z => 703.76,  heading => 470.25, ground_z => 680.0 },
    { x => 1550.37, y =>1257.80,  z => 726.75,  heading =>  54.00, ground_z => 700.0 },
    { x => 1633.83, y =>  23.35,  z => 647.36,  heading => 318.00, ground_z => 630.0 },
    { x => 1146.29, y => 110.56,  z => 647.34,  heading => 467.25, ground_z => 630.0 },
    { x =>  911.08, y => 378.73,  z => 647.33,  heading => 443.50, ground_z => 630.0 },
    { x => 1133.71, y => 628.29,  z => 647.31,  heading =>  87.00, ground_z => 630.0 },
    { x => 957.22, y => 906.47,  z => 647.29,  heading => 480.75, ground_z => 630.0 },
    { x => 1116.12, y =>1213.66,  z => 647.27,  heading =>  98.00, ground_z => 630.0 },
    { x => 968.11, y =>1494.30,  z => 647.26,  heading => 479.50, ground_z => 630.0 },
    { x => 1265.79, y =>1656.58,  z => 647.24,  heading => 102.25, ground_z => 630.0 },
    { x => 1696.40, y =>1459.10,  z => 647.22,  heading => 177.75, ground_z => 630.0 },
    { x => 1431.58, y =>1264.42,  z => 647.20,  heading => 349.75, ground_z => 630.0 },
    { x => 628.46, y =>1540.58,  z => 647.16,  heading => 341.00, ground_z => 630.0 },
    { x => 649.56, y =>1232.98,  z => 647.14,  heading => 313.75, ground_z => 630.0 },
    { x => 163.63, y =>1034.00,  z => 647.12,  heading => 297.00, ground_z => 630.0 },
    { x => 407.16, y => 726.42,  z => 647.10,  heading => 175.75, ground_z => 630.0 },
    { x => 44.63, y => 442.22,  z => 647.09,  heading => 360.75, ground_z => 630.0 },
    { x => 295.38, y => 86.36,  z => 647.07,  heading => 157.25, ground_z => 630.0 },
    { x => -439.12, y => 249.69,  z => 647.04,  heading => 436.25, ground_z => 630.0 },
    { x => -435.49, y => 646.34,  z => 647.02,  heading =>  99.75, ground_z => 630.0 },
    { x => -724.33, y => 974.43,  z => 647.00,  heading => 428.25, ground_z => 630.0 },
    { x => -486.37, y =>1255.57,  z => 646.97,  heading =>  85.25, ground_z => 630.0 },
    { x => -881.84, y =>1570.18,  z => 646.95,  heading => 436.25, ground_z => 630.0 },
    { x =>-1400.76, y =>1586.70,  z => 646.92,  heading => 350.25, ground_z => 630.0 },
    { x =>-1308.85, y =>1217.38,  z => 646.90,  heading => 154.75, ground_z => 630.0 },
    { x =>-1436.35, y => 873.62,  z => 646.88,  heading => 301.50, ground_z => 630.0 },
    { x =>-1162.10, y => 603.91,  z => 646.87,  heading => 190.00, ground_z => 630.0 },
    { x =>-1498.53, y => 375.26,  z => 646.84,  heading => 339.50, ground_z => 630.0 },
    { x =>-1246.34, y =>  79.97,  z => 646.82,  heading => 160.50, ground_z => 630.0 },
);

my %active_spawns;

sub EVENT_SPAWN {
    quest::settimer("proximity_check", 2);
}

sub EVENT_SIGNAL {
    # Expect signal ID to be the index of the trigger point
    my $idx = $signal;
    $active_spawns{$idx} = 0;
    quest::settimer("cooldown_$idx", 300);  # 5 minutes
}

sub EVENT_TIMER {
    if ($timer eq "proximity_check") {
        foreach my $client ($entity_list->GetClientList()) {
            next unless defined $client;

            my $px = $client->GetX();
            my $py = $client->GetY();
            my $pz = $client->GetZ();

            for (my $i = 0; $i < @trigger_points; $i++) {
                next if $active_spawns{$i};

                my $point = $trigger_points[$i];
                my $dx = $px - $point->{x};
                my $dy = $py - $point->{y};
                my $distance2D = sqrt($dx**2 + $dy**2);

                if ($distance2D <= 100 && $pz >= $point->{z} && $pz > ($point->{ground_z} + 100)) {
                    quest::spawn2(1986, 0, 0, $point->{x}, $point->{y}, $point->{z}, $point->{heading});
                    $active_spawns{$i} = 1;
                }
            }
        }
    } elsif ($timer =~ /^cooldown_(\d+)$/) {
        my $idx = $1;
        $active_spawns{$idx} = 0;
        quest::stoptimer($timer);
    }
}