my $npc_id = 1955;
my @spawn_points = (
    [-556.01, -227.44, -53.13, 13.00],
    [-954.78, 81.93, -24.52, 100.50],
    [-1079.63, -145.01, -39.72, 383.25],
    [-878.16, 144.74, 1.25, 392.25]
);

sub EVENT_ENTERZONE {
    if (!quest::isnpcspawned($npc_id)) {
        quest::settimer("spawn_npc", 1200);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::settimer("spawn_npc", 1200);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        quest::stoptimer("spawn_npc");

        if (!quest::isnpcspawned($npc_id)) {
            my $index = int(rand(@spawn_points));
            my ($x, $y, $z, $h) = @{$spawn_points[$index]};
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        }
    }
}

# sub EVENT_WARP {
#     if ($client->GetGM()) {
#         return;
#     }

#     $client->Kill();
# }