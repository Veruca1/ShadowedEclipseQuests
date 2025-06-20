# zone_controller.pl

my @trigger_points = (
    { x => 1616.54, y => 232.71,  z => 647.45,  heading => 490.75, ground_z => 630.0 },
    { x => 1563.49, y => 443.98,  z => 659.06,  heading => 492.00, ground_z => 640.0 },
    { x => 1640.43, y => 728.45,  z => 682.25,  heading =>  45.75, ground_z => 660.0 },
    { x => 1550.88, y => 984.49,  z => 703.76,  heading => 470.25, ground_z => 680.0 },
    { x => 1550.37, y =>1257.80,  z => 726.75,  heading =>  54.00, ground_z => 700.0 },
);

my %active_spawns;

sub EVENT_SPAWN {
    quest::settimer("proximity_check", 2);
}

sub EVENT_SIGNAL {
    # Expect signal ID to be the index of the trigger point
    my $idx = $signal;
    $active_spawns{$idx} = 0;
    quest::settimer("cooldown_$idx", 600);  # 10 minutes
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

                if ($distance2D <= 50 && $pz >= $point->{z} && $pz > ($point->{ground_z} + 10)) {
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