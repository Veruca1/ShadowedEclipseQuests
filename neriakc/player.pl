my $npc_id = 1955;
my @spawn_points = (
    [-887.57, 860.51, -37.90, 319.25],
    [-1346.83, 666.30, -109.08, 382.00],
    [-1614.70, 1378.72, -94.20, 255.75],
    [-1769.00, 693.00, -87.84, 0.00]
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