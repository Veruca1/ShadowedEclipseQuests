# 1986.pl

sub EVENT_DEATH_COMPLETE {
    # Find the closest trigger index
    my @points = (
        [1616.54, 232.71],
        [1563.49, 443.98],
        [1640.43, 728.45],
        [1550.88, 984.49],
        [1550.37,1257.80],
    );

    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $closest = 0;
    my $min_dist = 999999;

    for (my $i = 0; $i < @points; $i++) {
        my ($px, $py) = @{$points[$i]};
        my $dist = (($x - $px) ** 2 + ($y - $py) ** 2);
        if ($dist < $min_dist) {
            $min_dist = $dist;
            $closest = $i;
        }
    }

    # Send signal to zone_controller
    my $controller = $entity_list->GetNPCByNPCTypeID(10);  # Adjust this to actual zone_controller ID if not 10
    $controller->Signal($closest) if $controller;
}