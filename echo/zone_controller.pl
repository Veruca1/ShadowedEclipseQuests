my @spawn_npc_ids = (1928, 1929, 1930, 1931, 1932, 1933);
my @spawn_locs = (
    [1337.53, -1421.02, 118.87, 13.50],
    [1277.51, -1415.85, 118.06, 45.75],
    [1403.20, -1411.32, 118.06, 449.25],
    [1409.48, -1299.01, 118.06, 307.25],
    [1322.77, -1295.00, 118.06, 186.75],
    [1277.36, -1341.14, 120.72, 138.75]
);

sub EVENT_SIGNAL {
    if ($signal == 1) {
        if ($npc) {
            $npc->CameraEffect(1000, 3);
        }

        if ($entity_list) {
            my @clients = $entity_list->GetClientList();
            my $text = "You hear long forgotten but familiar cackles and shrieking echoing throughout the caverns.";

            foreach my $client (@clients) {
                next unless $client;
                $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
            }
        }

        quest::settimer("spawn_npcs", 15);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npcs") {
        quest::stoptimer("spawn_npcs");

        for (my $i = 0; $i < @spawn_npc_ids; $i++) {
            next unless defined $spawn_locs[$i] && ref $spawn_locs[$i] eq 'ARRAY';
            my ($x, $y, $z, $h) = @{$spawn_locs[$i]};
            next unless defined $x && defined $y && defined $z && defined $h;
            quest::spawn2($spawn_npc_ids[$i], 0, 0, $x, $y, $z, $h);
        }
    }
}
