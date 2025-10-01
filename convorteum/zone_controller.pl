# zone_controller.pl
use strict;
use warnings;

# === CONFIG ===
my @npc_pool = (
    2209,  # Lantern-Stuffed Stalker (Animated Scarecrow)
    2210,  # Echo of the Forgotten (Wailing Shade)
    2211,  # Tinkerspawn Remnant (Decaying Gnome Skeleton)
    2212,  # Ashlight Cinderling (Flame Mephit)
);

# All locs: x, y, z, heading
my @locs = (
    [662.75, -67.25, -78.42, 161.00],
    [734.95, -38.15, -75.44, 282.25],
    [645.20, -147.06, -70.96, 45.00],
    [923.00, -197.63, -69.48, 199.50],
    [962.40, -248.69, -71.42, 42.50],
    [992.18, -157.78, -68.22, 231.25],
    [1018.41, -219.22, -70.38, 485.25],
    [1061.04, -131.85, -70.90, 249.75],
    [1087.59, -220.91, -72.71, 269.00],
    [1157.31, -216.20, -69.53, 468.75],
    [1334.33, -150.75, -70.46, 228.25],
    [1408.71, -207.87, -70.46, 477.25],
    [1397.97, -113.32, -70.46, 253.00],
    [1468.65, -242.14, -70.46, 45.75],
    [1517.29, -154.99, -70.46, 323.25],
    [1667.47, -358.46, -69.52, 350.75],
    [1802.52, -419.07, -65.78, 340.25],
    [1733.58, -433.24, -62.48, 364.50],
    [1639.38, -395.28, -62.10, 259.75],
    [1670.46, -446.05, -62.10, 301.25],
    [1443.30, -847.13, -66.64, 293.75],
    [1460.59, -1052.06, -71.89, 1.75],
    [1324.82, -991.41, -71.36, 82.50],
    [1384.47, -877.10, -71.38, 231.25],
    [1405.44, -929.79, -69.72, 331.50],
    [1426.70, -1002.40, -71.28, 448.25],
    [1621.44, -1202.15, -65.41, 349.75],
    [1537.78, -1378.88, -70.08, 404.75],
    [1328.67, -1248.31, -74.04, 332.25],
    [1237.95, -1407.95, -74.01, 396.25],
    [1023.20, -1336.59, -73.94, 269.25],
    [975.73, -1510.38, -73.79, 413.75],
    [802.87, -1525.28, -74.01, 315.75],
    [752.77, -1711.88, -70.49, 443.25],
    [614.98, -1609.95, -68.15, 348.50],
    [442.95, -1559.61, -65.40, 308.00],
    [224.11, -1592.82, -68.28, 116.00],
    [401.28, -1696.21, -71.32, 130.00],
    [372.53, -1770.52, -68.63, 279.00],
    [335.55, -1733.77, -67.01, 411.50],
    [416.70, -1416.49, -72.81, 184.25],
    [438.00, -1365.05, -72.81, 394.25],
    [435.81, -1310.05, -68.69, 425.25],
    [362.18, -1313.87, -67.15, 14.75],
    [393.30, -1240.29, -70.66, 343.00],
    [329.59, -1205.36, -68.27, 300.50],
    [301.90, -1269.52, -66.34, 25.25],
    [273.36, -1229.06, -66.63, 50.25],
    [269.08, -1152.51, -68.66, 216.75],
    [318.54, -1115.79, -70.15, 199.00],
    [454.26, -819.83, -71.91, 29.00],
    [535.39, -791.32, -73.99, 194.00],
    [613.81, -747.52, -72.68, 66.50],
    [533.21, -711.75, -74.05, 389.50],
    [396.76, -701.90, -71.69, 56.50],
);

# Track active spawns by location index
my %active_spawns;

sub EVENT_SPAWN {
    quest::debug("Zone controller: starting F1 trash spawns (2209–2212). Total locs: " . scalar(@locs));
    spawn_all();
    quest::debug("Zone controller: Finished initial spawn pass. Active spawns: " . scalar(keys %active_spawns));
}

sub spawn_all {
    my $count = 0;
    for my $i (0 .. $#locs) {
        $count++ if spawn_at_loc($i);
    }
    quest::debug("Zone controller: spawn_all() attempted " . scalar(@locs) . " locs, succeeded $count.");
}

sub spawn_at_loc {
    my ($i) = @_;
    return 0 if exists $active_spawns{$i};   # already something tracked here

    my ($x, $y, $z, $h) = @{$locs[$i]};
    my $npc_id = $npc_pool[int(rand(@npc_pool))];

    my $new_id = quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
    if ($new_id) {
        $active_spawns{$i} = $new_id;
        quest::debug("Spawned NPC $npc_id at loc index $i ($x,$y,$z)");
        return 1;
    } else {
        quest::debug("FAILED to spawn NPC $npc_id at loc index $i ($x,$y,$z)");
        return 0;
    }
}

# Called by NPC death scripts
sub respawn_request {
    my ($i) = @_;
    delete $active_spawns{$i};  # free the slot
    quest::debug("Respawn requested for loc $i");
    quest::settimer("respawn_$i", 420); # 7 mins
}

sub EVENT_TIMER {
    my $timer = $_[0];   # EQ passes timer name as first arg

    if ($timer =~ /^respawn_(\d+)$/) {
        my $i = $1;
        quest::stoptimer($timer);
        quest::debug("Respawning slot $i via timer");
        spawn_at_loc($i);
        quest::debug("Active spawns after respawn: " . scalar(keys %active_spawns));
    }
}

1;