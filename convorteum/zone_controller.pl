# ===========================================================
# zone_controller.pl
# Tower of Shattered Lanterns - Zone Spawn Controller
# Floors 1–6 logic
# ===========================================================

# === CONFIG: Floor 1 ===
my @npc_pool = (
    2209,  # Lantern-Stuffed Stalker
    2210,  # Echo of the Forgotten
    2211,  # Tinkerspawn Remnant
    2212,  # Ashlight Cinderling
);

# === LOCATIONS: Floor 1 ===
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

# === CONFIG: Floor 1 Minis ===
my @floor1_minis = (
    [378.46, -1730.52, -65.85, 61.00],   # Ashmaw the Cinder Ghoul (2214)
    [1481.74,  -196.03, -70.20, 333.00], # Marrowhowl the Bone Piper (2215)
);

# === CONFIG: Floor 2 Trash ===
my @floor2_trash_pool = (2216, 2217, 2218);
my @floor2_trash_locs = (
    [1115.28, -1003.62, 255.64, 3.50],
    [1118.40, -961.93, 255.07, 505.00],
    [1185.40, -954.57, 254.77, 383.25],
    [1195.02, -1004.81, 254.77, 433.00],
    [936.27, -1002.83, 256.04, 65.75],
    [1003.47, -1005.21, 254.77, 504.00],
    [992.40, -965.60, 254.77, 12.75],
    [928.45, -929.80, 254.77, 138.25],
    [975.99, -736.34, 254.87, 272.50],
    [930.72, -737.46, 254.77, 207.00],
    [957.60, -811.71, 255.01, 125.50],
);

# === CONFIG: Floor 2 Boss ===
my $floor2_boss_id = 2219; 
my @floor2_boss_loc = (1051.82, -880.79, 267.88, 243.75);

# === CONFIG: Floor 3 Trash ===
my @floor3_trash_pool = (2220, 2221, 2222, 2223);
my @floor3_trash_locs = (
    [1232.41, -763.97, 376.62, 392.75],
    [1182.85, -802.35, 375.62, 503.75],
    [1103.95, -722.45, 374.59, 257.00],
    [1075.70, -801.49, 375.26, 500.25],
    [1006.19, -736.49, 374.32, 217.00],
    [958.30,  -789.67, 374.34, 189.00],
    [906.96,  -841.90, 373.49, 142.25],
    [893.46,  -957.65, 374.72, 122.75],
    [1021.31, -915.00, 375.62, 379.75],
    [1109.56, -835.13, 375.62, 262.75],
    [1066.95, -989.36, 378.57, 28.75],
    [1140.85, -979.86, 381.17, 483.00],
    [1195.46, -917.26, 379.11, 387.50],
    [1193.46, -857.91, 376.42, 369.75],
);

# === CONFIG: Floor 3 Minis ===
my $floor3_mini1_id = 2224; 
my $floor3_mini2_id = 2225; 
my @floor3_mini1_loc = (1178.07, -958.92, 380.46, 448.25);
my @floor3_mini2_loc = (907.04,  -743.84, 375.99, 187.25);

# === CONFIG: Floor 4 Trash ===
my @floor4_trash_pool = (2226, 2227, 2228, 2229);
my @floor4_trash_locs = (
    [845.00,  -764.32, 584.92, 265.75],
    [836.10,  -1024.32, 586.95, 17.00],
    [766.89,  -635.59, 590.57, 185.75],
    [890.91,  -608.71, 594.18, 391.00],
    [1089.10, -576.32, 589.77, 245.50],
    [1289.66, -623.19, 584.38, 398.00],
    [1307.02, -812.09, 612.00, 400.75],
    [1099.80, -817.31, 610.41, 119.00],
    [1108.30, -1011.34, 607.89, 254.75],
    [1192.62, -999.29, 607.96, 130.75],
    [995.39,  -904.33, 607.89, 7.25],
    [1044.21, -763.67, 592.81, 501.75],
    [975.36,  -770.60, 592.64, 510.25],
    [1293.40, -1012.97, 612.74, 382.50],
    [1287.91, -976.21, 613.05, 384.50],
    [1219.31, -911.44, 611.91, 385.25],
    [1295.25, -859.91, 613.15, 312.00],
    [1335.08, -897.01, 613.14, 329.00],
);

# === CONFIG: Floor 4 Lava Section ===
my @floor4_lava_locs = (
    [908.76, -1040.41, 577.10, 3.75],
    [914.76, -965.82, 577.09, 380.50],
    [918.10, -894.65, 577.08, 385.00],
    [920.84, -818.60, 577.08, 384.25],
    [921.39, -745.53, 577.07, 382.75],
    [969.96, -699.19, 577.06, 478.00],
    [1029.52, -687.84, 577.05, 488.50],
    [1091.15, -679.39, 577.05, 508.50],
    [1207.74, -684.40, 577.04, 139.75],
);

# === CONFIG: Floor 5 (NEW) ===
my $floor5_bones_id = 2234;  # Pile of Bones (spawns 2235 on death)
my $floor5_trash_id = 2235;  # Spawned trash that counts toward essences

# The Lanternless (mini)
my $floor5_mini_id = 2233;
my @floor5_mini_loc = (1193.94, -525.05, 845.99, 322.75);

# Fixed bones locations (spawn 2234 only here)
my @floor5_bones_locs = (
    [893.96,  -492.49, 831.19, 256.75],
    [894.83,  -815.73, 831.84, 2.25],
    [1214.42, -970.54, 782.71, 387.00],
    [1216.86, -1064.74, 783.53, 388.50],
    [924.35,  -885.84, 784.30, 256.00],
    [832.96,  -894.08, 783.30, 254.50],
);

# === CONFIG: Floor 6 (NEW) ===
# The Wickbreaker (mini)
my $floor6_mini_id  = 2241;
my @floor6_mini_loc = (960.76, -1587.63, 1067.92, 2.75);

# Floor 6 Plinths (randomize which ID goes to which loc; 2244 handled elsewhere)
my @floor6_plinth_ids  = (2243, 2245, 2246, 2247);  # Ascent, Cinderwick, Veilbound, Blackglass
my @floor6_plinth_locs = (
    [1272.36,  -870.68, 1047.81, 366.25],
    [1330.76, -1275.58, 1047.81, 412.50],
    [ 656.63, -1304.81, 1048.12, 100.75],
    [ 575.61,  -884.36, 1047.81, 158.75],
);

# ===========================================================
# Tracking
# ===========================================================
my %active_spawns;
my %active_spawns_floor2;
my %active_spawns_floor3;

# ===========================================================
# EVENT_SPAWN
# ===========================================================
sub EVENT_SPAWN {
    spawn_floor1();
    spawn_floor1_minis(); # spawn fixed Floor 1 minibosses
    spawn_floor2_trash();
    spawn_floor2_boss();
    spawn_floor3_trash();
    spawn_floor3_minis();
    spawn_floor4_trash();
    spawn_floor4_lava();
    spawn_floor4_mini();

    # Floor 5
    spawn_floor5_bones_fixed();
    spawn_floor5_mini();

    # Floor 6
    spawn_floor6_mini();
    spawn_floor6_plinths();  # <— new

    quest::settimer("conv_floor2_invul_confirm", 3);
    quest::settimer("conv_postinit", 6);
    plugin::Debug("[ZoneController] EVENT_SPAWN initialized Floors 1–6.");
}

# ===========================================================
# Floor 4 Lava Logic
# ===========================================================
sub spawn_floor4_lava {
    for my $i (0 .. $#floor4_lava_locs) {
        my ($x,$y,$z,$h) = @{$floor4_lava_locs[$i]};
        my $npc_id = 2226; # Cinder_Drake_Scavenger only
        $z += 1.0;
        $h %= 360;
        my $new_id = quest::spawn2($npc_id,0,0,$x,$y,$z,$h);
        if ($new_id) {
            plugin::Debug("[ZoneController] F4 Lava Drake $npc_id spawned at ($x,$y,$z,$h).");
        } else {
            plugin::Debug("[ZoneController] ⚠ Failed to spawn Lava Drake at ($x,$y,$z,$h).");
        }
    }
}

# ===========================================================
# Remaining Floors Logic (unchanged)
# ===========================================================
sub spawn_floor1 {
    for my $i (0 .. $#locs) {
        my ($x,$y,$z,$h) = @{$locs[$i]};
        my $npc_id = $npc_pool[int(rand(@npc_pool))];
        my $new_id = quest::spawn2($npc_id,0,0,$x,$y,$z,$h);
        $active_spawns{$i} = $new_id if $new_id;
    }
}

sub spawn_floor1_minis {
    my @mini_ids = (2214, 2215); # Ashmaw and Marrowhowl

    for my $i (0 .. $#floor1_minis) {
        my ($x,$y,$z,$h) = @{$floor1_minis[$i]};
        my $npc_id = $mini_ids[$i];
        my $new_id = quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        if ($new_id) {
            plugin::Debug("[ZoneController] F1 Mini $npc_id spawned at ($x,$y,$z,$h).");
        } else {
            plugin::Debug("[ZoneController] ⚠ Failed to spawn F1 Mini $npc_id at ($x,$y,$z,$h).");
        }
    }
}

sub spawn_floor2_trash {
    for my $i (0 .. $#floor2_trash_locs) {
        my ($x,$y,$z,$h) = @{$floor2_trash_locs[$i]};
        my $npc_id = $floor2_trash_pool[int(rand(@floor2_trash_pool))];
        my $new_id = quest::spawn2($npc_id,0,0,$x,$y,$z,$h);
        $active_spawns_floor2{$i} = $new_id if $new_id;
        if ($new_id) {
            my $mob = $entity_list->GetNPCByID($new_id);
            if ($mob) {
                $mob->SetInvul(1);
                quest::settimer("recheck_invul_$new_id",1);
            }
        }
    }
}

sub spawn_floor2_boss {
    my ($x,$y,$z,$h) = @floor2_boss_loc;
    my $new_id = quest::spawn2($floor2_boss_id,0,0,$x,$y,$z,$h);
    if ($new_id) {
        my $mob = $entity_list->GetNPCByID($new_id);
        if ($mob) {
            $mob->SetInvul(1);
            quest::settimer("recheck_invul_$new_id",1);
        }
    }
}

sub spawn_floor3_trash {
    for my $i (0 .. $#floor3_trash_locs) {
        my ($x,$y,$z,$h) = @{$floor3_trash_locs[$i]};
        my $npc_id = $floor3_trash_pool[int(rand(@floor3_trash_pool))];
        my $new_id = quest::spawn2($npc_id,0,0,$x,$y,$z,$h);
        $active_spawns_floor3{$i} = $new_id if $new_id;
    }
}

sub spawn_floor3_minis {
    my ($x1,$y1,$z1,$h1) = @floor3_mini1_loc;
    my ($x2,$y2,$z2,$h2) = @floor3_mini2_loc;
    quest::spawn2($floor3_mini1_id,0,0,$x1,$y1,$z1,$h1);
    quest::spawn2($floor3_mini2_id,0,0,$x2,$y2,$z2,$h2);
}

sub spawn_floor4_trash {
    for my $i (0 .. $#floor4_trash_locs) {
        my ($x,$y,$z,$h) = @{$floor4_trash_locs[$i]};
        my $npc_id = $floor4_trash_pool[int(rand(@floor4_trash_pool))];
        quest::spawn2($npc_id,0,0,$x,$y,$z,$h);
    }
}

# ===========================================================
# Floor 4 Mini-Boss Random Spawn (One of Three)
# ===========================================================
sub spawn_floor4_mini {
    my @floor4_minis = (2232, 2230, 2231);
    my @floor4_mini_locs = (
        [1321.29, -872.21, 613.87, 320.25],
        [1113.85, -910.95, 607.97, 127.25],
        [841.42,  -646.24, 588.94, 434.75],
    );

    my $chosen_index = int(rand(3));
    my ($x,$y,$z,$h) = @{$floor4_mini_locs[$chosen_index]};
    my $npc_id = $floor4_minis[$chosen_index];

    my $new_id = quest::spawn2($npc_id,0,0,$x,$y,$z,$h);

    if ($new_id) {
        plugin::Debug("[ZoneController] Floor 4 Mini ($npc_id) spawned at ($x,$y,$z,$h).");
    } else {
        plugin::Debug("[ZoneController] ⚠ Failed to spawn Floor 4 Mini ($npc_id)!");
    }
}

# ===========================================================
# Floor 5 (Bones + Mini)
# ===========================================================
sub spawn_floor5_bones_fixed {
    # Unique bone NPCs (each used once)
    my @bone_ids = (2234, 2236, 2237, 2238, 2239, 2240);

    # Shuffle order to randomize which loc each uses
    for (my $i = $#bone_ids; $i > 0; $i--) {
        my $j = int(rand($i + 1));
        my $tmp = $bone_ids[$i];
        $bone_ids[$i] = $bone_ids[$j];
        $bone_ids[$j] = $tmp;
    }

    # Spawn exactly one per loc (6 total)
    for my $i (0 .. $#floor5_bones_locs) {
        my ($x, $y, $z, $h) = @{$floor5_bones_locs[$i]};
        my $npc_id = $bone_ids[$i];
        my $new_id = quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);

        if ($new_id) {
            plugin::Debug("[ZoneController] Floor 5 Bone ($npc_id) spawned at ($x,$y,$z,$h).");
        } else {
            plugin::Debug("[ZoneController] ⚠ Failed to spawn Floor 5 Bone ($npc_id) at ($x,$y,$z,$h).");
        }
    }

    plugin::Debug("[ZoneController] Floor 5: spawned 6 unique Bone NPCs (2234, 2236–2240) at 6 fixed locations.");
}

sub spawn_floor5_mini {
    my ($x,$y,$z,$h) = @floor5_mini_loc;
    my $new_id = quest::spawn2($floor5_mini_id,0,0,$x,$y,$z,$h);
    if ($new_id) {
        plugin::Debug("[ZoneController] Floor 5 Mini ($floor5_mini_id) spawned at ($x,$y,$z,$h).");
    } else {
        plugin::Debug("[ZoneController] ⚠ Failed to spawn Floor 5 Mini ($floor5_mini_id)!");
    }
}

# ===========================================================
# Floor 6 (Mini + Plinths)
# ===========================================================
sub spawn_floor6_mini {
    my ($x,$y,$z,$h) = @floor6_mini_loc;
    my $new_id = quest::spawn2($floor6_mini_id,0,0,$x,$y,$z,$h);
    if ($new_id) {
        plugin::Debug("[ZoneController] Floor 6 Mini ($floor6_mini_id) spawned at ($x,$y,$z,$h).");
    } else {
        plugin::Debug("[ZoneController] ⚠ Failed to spawn Floor 6 Mini ($floor6_mini_id)!");
    }
}

sub spawn_floor6_plinths {
    # Randomize which plinth ID maps to which of the four locations
    my @ids = @floor6_plinth_ids;

    # Fisher–Yates shuffle
    for (my $i = $#ids; $i > 0; $i--) {
        my $j = int(rand($i + 1));
        my $tmp = $ids[$i];
        $ids[$i] = $ids[$j];
        $ids[$j] = $tmp;
    }

    for my $i (0 .. $#floor6_plinth_locs) {
        my ($x,$y,$z,$h) = @{$floor6_plinth_locs[$i]};
        my $npc_id = $ids[$i];
        $h %= 360;
        my $new_id = quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        if ($new_id) {
            plugin::Debug("[ZoneController] F6 Plinth ($npc_id) at ($x,$y,$z,$h).");
        } else {
            plugin::Debug("[ZoneController] ⚠ Failed to spawn F6 Plinth ($npc_id) at ($x,$y,$z,$h).");
        }
    }
}

# ===========================================================
# EVENT_TIMER
# ===========================================================
sub EVENT_TIMER {
    my $timer = $_[0];
    if ($timer =~ /^recheck_invul_(\d+)$/) {
        quest::stoptimer($timer);
        my $mob = $entity_list->GetNPCByID($1);
        if ($mob && !$mob->IsPet()) {
            $mob->SetInvul(1);
        }
    }
    elsif ($timer eq "conv_floor2_invul_confirm") {
        quest::stoptimer($timer);
        foreach my $mob ($entity_list->GetNPCList()) {
            next unless $mob && $mob->IsNPC();
            my $id = $mob->GetNPCTypeID();
            next unless ($id == 2216 || $id == 2217 || $id == 2218 || $id == 2219);
            $mob->SetInvul(1);
        }
    }
    elsif ($timer eq "conv_postinit") {
        quest::stoptimer($timer);
        foreach my $mob ($entity_list->GetNPCList()) {
            next unless $mob && $mob->IsNPC();
            my $id = $mob->GetNPCTypeID();
            next unless ($id == 2216 || $id == 2217 || $id == 2218 || $id == 2219);
            $mob->SetInvul(1);
        }
    }
}

1;