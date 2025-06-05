my $npc_id = 1955;
my @spawn_points = (
    [-122.63, -32.30, 1.25, 62.50],
    [-57.12, 270.89, 30.77, 428.50],
    [-217.27, 103.34, 16.77, 437.50],
    [-513.94, -445.16, 16.78, 135.00]
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