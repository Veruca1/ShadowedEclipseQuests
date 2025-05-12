sub EVENT_SPAWN {
    spawn_npcs(1415);  # Spawn initial NPCs for 1415
  
    quest::settimer("respawn_npcs", 10800);  # Respawn NPCs 20 seconds later (10,810 seconds)
    quest::settimer("depop_npcs", 10775);  # Depop NPCs after 10,790 seconds (~2h 59m)

    $signal_count_1 = 0;
    $signal_count_2 = 0;
    $signal_count_3 = 0;
    $signal_count_4 = 0;
    $signal_count_5 = 0;
    $signal_count_6 = 0;
    $signal_count_7 = 0;
    $kill_count = 0;  # Initialize kill count
}

sub EVENT_TIMER {
    if ($timer eq "respawn_npcs") {
        spawn_npcs(1415);  # Respawn NPCs for 1415
       #quest::worldwidemessage(257, "When the ancient trees groan and the whispers of the lost weave through the branches, beware, adventurers... the Forbidden Forest stirs once again. Strange eyes watch from the shadows, and the veil between this world and the next grows thin.");
#quest::worldwidemessage(257, "Welcome, brave souls, to the cursed forest of Kithicor. Spirits long forgotten roam these woods, eager to test the courage of those who dare trespass. You may seek treasure or glory, but beware—the forest seeks something far more valuable.");
#quest::worldwidemessage(257, "Step lightly, for the ground beneath you is not as still as it seems. In the Forbidden Forest, not everything that dies stays dead.");

    } elsif ($timer eq "depop_npcs") {
        depop_npcs(1415);
        depop_npcs(1416);
        depop_npcs(1417);
        depop_npcs(1420);
        depop_npcs(1421);
    }
}


sub EVENT_SIGNAL {
    if ($signal == 1) {
        $signal_count_1++;
        $kill_count++;  # Increment kill count for signal 1
        if ($kill_count % 10 == 0) {  # Check if 10 kills have been made
            quest::shout("We have taken down $kill_count foes! Keep up the fight!");
        }
        if ($signal_count_1 == 30) {
            quest::shout("As the last spider falls, the hum of bees fills the air...");
	    depop_npcs(1415);
            spawn_npcs(1416);
        }
    } elsif ($signal == 2) {
        $signal_count_2++;
        $kill_count++;  # Increment kill count for signal 2
        if ($kill_count % 10 == 0) {  # Check if 10 kills have been made
            quest::shout("We have taken down $kill_count foes! Keep up the fight!");
        }
        if ($signal_count_2 == 30) {
            quest::shout("A swarm of frogs emerges from the swamp, their croaking echoing eerily...");
	    depop_npcs(1416);
            spawn_npcs(1417);
        }
    } elsif ($signal == 3) {
        $signal_count_3++;
        $kill_count++;  # Increment kill count for signal 3
        if ($kill_count % 10 == 0) {  # Check if 10 kills have been made
            quest::shout("We have taken down $kill_count foes! Keep up the fight!");
        }
        if ($signal_count_3 == 30) {
            quest::shout("A powerful force stirs within the swamp, and the ground shifts beneath your feet, it's the dragon!");
	    depop_npcs(1417);
            quest::spawn2(1418, 0, 0, 2201.48, 410.20, 257.56, 210.75);
        }
    } elsif ($signal == 4) {
        $signal_count_4++;
        if ($signal_count_4 == 1) {
            quest::shout("The ground trembles as the skeletal warriors rise from their graves!");
	    spawn_npcs(1420);
        }
    } elsif ($signal == 5) {
        $signal_count_5++;
        $kill_count++;  # Increment kill count for signal 5
        if ($kill_count % 10 == 0) {  # Check if 10 kills have been made
            quest::shout("We have taken down $kill_count foes! Keep up the fight!");
        }
        if ($signal_count_5 == 30) {
            quest::shout("The skies darken as a shadow looms overhead...");
	    depop_npcs(1420);
            quest::spawn2(1419, 0, 0, 2201.48, 410.20, 257.56, 210.75);
        }
    } elsif ($signal == 6) {
        $signal_count_6++;
        if ($signal_count_6 == 1) {
            quest::shout("The giant snakes slither forth, their eyes glinting with hunger!");
	    spawn_npcs(1421);
        }
    } elsif ($signal == 7) {
        $signal_count_7++;
        $kill_count++;  # Increment kill count for signal 7
        if ($kill_count % 10 == 0) {  # Check if 10 kills have been made
            quest::shout("We have taken down $kill_count foes! Keep up the fight!");
        }
        if ($signal_count_7 == 30) {
            quest::shout("The swamp is filled with the sound of howling winds and the rustle of leaves, you look up and through the lightning flashes you see the silhouette of an enormous demon!");
	    depop_npcs(1421);
            quest::spawn2(1422, 0, 0, 2201.48, 410.20, 257.56, 210.75);
        }
    }
}

sub depop_npcs {
    my @npc_ids = @_;  # Accept a list of NPC IDs

    foreach my $npc_id (@npc_ids) {
        quest::depopall($npc_id);  # Depop all instances of the NPC type
    }
}

sub spawn_npcs {
    my $npc_id = shift;
    my @locations = (
         [2298.5, 815.75, 272.880005, 494.5],  # #1
        [2267, 835.5, 266.5, 111.5],          # #2
        [4248, 103, 515.900024, 328],         # #3
        [4536, -740, 613, 240],                # #4
        [2290, 793, 272.380005, 33],           # #5
        [2263, 1458, 299.130005, 128],         # #6
        [4529.879883, -678.880005, 598.630005, 456],  # #7
        [2293, 812, 272.380005, 50],           # #8
        [2304.237793, 830.446045, 272.776794, 378.25], # #9
        [-684, 1095, -40.25, 510],              # #10
        [2353.879883, 102, 280.130005, 195.5], # #11
        [3813, -216, 496.25, 111],              # #12
        [3882.75, -331.880005, 497.380005, 504], # #13
        [4000.5, -264.380005, 498.880005, 382], # #14
        [3821, -281, 496, 272],                 # #15
        [3793.879883, -307, 496.130005, 80],   # #16
        [3082.879883, -775.880005, 475, 504],  # #17
        [1962, -571, 227.130005, 502],          # #18
        [1929.880005, -570.5, 225.130005, 90],  # #19
        [-825, 1427, -44, 309],                  # #20
        [2315, 1522, 299.75, 90],               # #21
        [2383, 1465, 300.130005, 313],          # #22
        [2386, 1441, 300, 382],                  # #23
        [2316, 1464, 298.130005, 241],          # #24
        [-680, 1148, -40.25, 206],               # #25
        [2288, 1394, 298.380005, 388],          # #26
        [4536.879883, -868.880005, 660, 488],   # #27
        [1340.5, 1199.75, 150.75, 188.25],      # #28
        [3092, 1404, 381.799988, 213.5],        # #29
        [1915.880005, -636, 245.399994, 248.5], # #30
        [2309.879883, 887, 289, 305.5],         # #31
        [-313.880005, 1084, -17.879999, 0],     # #32
        [3980.879883, -151, 492.75, 0],         # #33
        [3359.879883, 200, 426.899994, 254.5],  # #34
        [1518, -133, 174, 326.5],                # #35
        [-194.880005, 801.880005, -7.6, 301.5],  # #36
        [1034, -338, 152.25, 386.25],            # #37
        [4366.879883, -640.880005, 561.5, 0],    # #38
        [284.880005, 781.880005, -14.5, 94.75],  # #39
        [3496, 1442, 414.130005, 0],              # #40
        [3894.879883, 1241, 463.130005, 124.75], # #41
        [4263.879883, 1818.880005, 544.599976, 0], # #42
        [-86, 631.880005, 12.1, 140],            # #43
        [3609, 1407.880005, 428, 292.5],         # #44
        [1239, -194, 154, 112],                   # #45
        [1183.880005, -249, 150.880005, 112],    # #46
        [1227.880005, -205, 153.880005, 112],    # #47
        [4300, 1107, 581.799988, 492.5],         # #48
        [2309.098145, 827.551025, 273.67453, 296], # #49
        [87, 669.880005, -10.63, 399.25],        # #50
        [1954, -453.880005, 238.300003, 240.5],  # #51
        [1245.880005, -724, 243.100006, 229],    # #52
        [1144, -46, 159.880005, 0],               # #53
        [746, 230, 83.800003, 245.5],            # #54
        [3336, 1898.880005, 480.5, 449],         # #55
        [4427.879883, -166, 531.599976, 218.5],  # #56
        [3041, 1110, 407, 362.5],                 # #57
        [1224.880005, -275, 152.25, 90],         # #58
        [1235.880005, -264, 152.130005, 90],     # #59
        [3265, 1813.880005, 417.380005, 10.75],   # #60
        [1216.880005, -216, 153.630005, 112],     # #61
        [1194.880005, -238, 151.5, 112],          # #62
        [1205.880005, -227, 152.880005, 112],     # #63
        [3356.879883, 1655.880005, 397.100006, 86.5], # #64
        [151, 916.880005, -20.9, 297],            # #65
        [2376, 671, 283.880005, 0],               # #66
        [1792, 1617, 225, 0],                     # #67
        [2084, -637, 263.880005, 0],              # #68
        [1377, 795, 162.880005, 0],               # #69
        [-627.880005, 1542.880005, -34.630001, 398.75], # #70
        [743, 775.880005, 87.25, 0],              # #71
        [1630, 1178, 199.75, 260.25],             # #72
        [3384, 1830.880005, 439.630005, 429],     # #73
        [4344.879883, 1814.880005, 564.630005, 101.75], # #74
        [4458.879883, 1477.880005, 550.630005, 121.25], # #75
        [4145.879883, 1739.880005, 510.880005, 0],  # #76
        [3963.879883, 1051.880005, 493.630005, 184],  # #77
        [3257.879883, -225.880005, 472, 0],      # #78
        [3348, 88.25, 458.880005, 0],             # #79
        [2894, 771.880005, 387, 210.5],           # #80
        [3050, 1290, 416, 228],                   # #81
        [1692, -228, 176.25, 193.75],             # #82
        [3008, 760, 407.100006, 0],               # #83
        [3880.879883, 1059.880005, 469.630005, 214.5], # #84
        [4305.879883, -687.880005, 554.599976, 0], # #85
        [4536.879883, -1011.880005, 610, 240],   # #86
        [3894.879883, -1221, 460.380005, 0],     # #87
        [1201, 1850, 197.75, 272],                # #88
        [1882, 696.880005, 234, 0],               # #89
        [1900, 634, 240, 282],                    # #90
        [2232, 825, 272.880005, 291],             # #91
        [4195.879883, 1235.880005, 508, 225],    # #92
        [1295.879883, -341.880005, 187, 148],    # #93
        [1259.879883, -529.880005, 188.799988, 315], # #94
        [4665.879883, -904.880005, 629, 0],      # #95
        [1918.880005, -169.630005, 260.5, 0],    # #96
        [1926, -302, 267.75, 230],                # #97
        [2005.880005, 74.5, 284.75, 0],           # #98
        [2001.5, -367, 266.600006, 0],            # #99
        [2283, 1675.880005, 285.5, 269.5],       # #100
        [1687, 643.5, 155.100006, 256],           # #101
        [2580, 1100, 320.100006, 0],              # #102
        [1303, 1917.880005, 148.75, 203.5],       # #103
        [1989, 703.5, 267.880005, 312],           # #104
        [2598.880005, 1545, 315.130005, 221.5],   # #105
        [4292.879883, 792.880005, 574.130005, 0], # #106
        [1583, 1520.880005, 179.75, 312.5],       # #107
        [1655.879883, 1500.880005, 185.600006, 227.5], # #108
        [1787, 1932, 255.130005, 295.5],          # #109
        [1971.5, 770, 266, 338],                  # #110
        [1241, 962.5, 122.130005, 138.5],        # #111
        [1982, 849.5, 265.130005, 334],           # #112
        [1972.5, 859.5, 263, 304],                # #113
        [2043, 915.5, 276, 344],                  # #114
        [2000.75, 696, 280.130005, 135.75],       # #115
        [1858, 1997.5, 226.130005, 314],          # #116
        [1846.5, 1138, 223, 0],                   # #117
        [1139, 1455, 197.75, 0],                  # #118
        [3401.75, 1666.25, 453.130005, 334],     # #119
        [1822, 1344.880005, 220.5, 335],          # #120
        [1780, 2100, 225, 0],                     # #121
        [2267, 1785, 276, 0],                     # #122
        [3411, 1033.5, 473, 0],                   # #123
        [1432, 1672, 204.5, 0],                   # #124
        [3451, 764, 508.5, 0],                    # #125
        [2525, 1730, 276, 0],                     # #126
        [3435, 1545, 490, 0],                     # #127
        [3445, 2053.5, 420, 0],                   # #128
        [2754.880005, -244.630005, 345, 0],      # #129
        [1752, 1828.880005, 261.75, 0],           # #130
        [1885, -194, 236, 0],                     # #131
        [2061, -420, 247.130005, 0],              # #132
        [2254, 482.880005, 285, 0],               # #133
        [1824.880005, 488, 220, 0],               # #134
        [1847, 375.880005, 204, 0],               # #135
        [1632, 523.880005, 187, 0],               # #136
        [1848, 1337.880005, 226.5, 0],            # #137
        [1105, 282, 106.630005, 0],               # #138
        [1141, 1488, 197.630005, 0],              # #139
        [1041, 1028, 128.100006, 0],              # #140
        [1543, 1142, 218, 0],                     # #141
        [1692, 758, 180, 0],                      # #142
        [1720, 839.880005, 187.5, 0],             # #143
        [1182, 1486, 203.880005, 0],              # #144
        [1266, 689.880005, 171.75, 0],            # #145
        [1965, 661, 241, 0],                      # #146
        [1963, 1289.880005, 225, 0],              # #147
        [1642, 1380.880005, 225.130005, 0],      # #148
        [2257.5, 952.880005, 278, 0],             # #149
        [2253, 1441.880005, 278.130005, 0],      # #150
    );
    
    foreach my $loc (@locations) {
        my ($x, $y, $z, $h) = @$loc;
        quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
    }
}

# Declare a global variable to keep track of kills
my $kill_counter = 0;

sub EVENT_DEATH_COMPLETE {
    # Check if the NPC ID matches one of the desired IDs
    if ($npc->GetNPCTypeID() == 1415 || $npc->GetNPCTypeID() == 1416 || $npc->GetNPCTypeID() == 1417 || $npc->GetNPCTypeID() == 1420 || $npc->GetNPCTypeID() == 1421) {
        
        # Increment the kill counter
        $kill_counter++;
        
        # Check if the kill counter is a multiple of 10
        if ($kill_counter % 10 == 0) {
            quest::shout("We have killed $kill_counter enemies so far!");
        }
        
        # Continue with existing spawn NPC logic here...
    }
}

