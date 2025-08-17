# zone_controller.pl

# ---------------------------
# Item random ground spawns
# ---------------------------
my @items = (
    45487, 45488, 45489, 45490, 45491, 45492
);

my @locations = (
    { 'x' => 241.26,   'y' => -53.26,    'z' => -4.25,    'h' => 127.50 },
    { 'x' => 493.72,   'y' => 27.22,     'z' => 16.75,    'h' => 134.25 },
    { 'x' => -108.58,  'y' => 532.44,    'z' => -253.98,  'h' => 255.00 },
    { 'x' => 260.37,   'y' => -486.67,   'z' => -252.74,  'h' => 12.25 },
    { 'x' => 117.71,   'y' => -1056.46,  'z' => -256.25,  'h' => 303.50 },
    { 'x' => 256.20,   'y' => 290.29,    'z' => 251.25,   'h' => 2.50 },
    { 'x' => 727.60,   'y' => -325.92,   'z' => 403.75,   'h' => 386.25 }
);

# ---------------------------
# Proximity spawn for NPC 2188 / 1998
# ---------------------------
# Proximity A (original)
my $spawn_x       = 304.89;
my $spawn_y       = -11.77;
my $spawn_z       = -6.12;
my $spawn_radius  = 15;

# Proximity B (new)
my $spawn2_x      = 534.81;
my $spawn2_y      = -193.23;
my $spawn2_z      = -3.94;
my $spawn2_radius = 25;

# Proximity C (new - from screenshot)
my $spawn3_x      = 686.52;
my $spawn3_y      =  -9.00;
my $spawn3_z      =  -3.94;
my $spawn3_radius = 15;

# Spawn target for NPC 1998
my $npc1998_x = 588.91;
my $npc1998_y = -10.86;
my $npc1998_z =   5.06;
my $npc1998_h = 127;

my $cooldown_secs = 600; # 10 minutes
my $spawn_ready_a = 1;
my $spawn_ready_b = 1;
my $spawn_ready_c = 1;

sub EVENT_SPAWN {
    # Only spawn ground items in Ssra version 0
    if ($zoneid == 162 && $instanceversion == 0) {
        my @shuffled_items = shuffle(@items);
        my @chosen_items   = @shuffled_items[0..1];
        my @shuffled_locs  = shuffle(@locations);
        my @chosen_locs    = @shuffled_locs[0..1];

        for my $i (0..1) {
            my $item_id = $chosen_items[$i];
            my $loc     = $chosen_locs[$i];
            quest::creategroundobject(
                $item_id,
                $loc->{'x'},
                $loc->{'y'},
                $loc->{'z'},
                $loc->{'h'},
                600000
            );
        }
    }

    # Start checking for proximity to spawn NPCs
    quest::settimer("proximity_check", 1);
}

sub EVENT_TIMER {
    if ($timer eq "proximity_check") {
        # Only run proximity spawns in Ssra version 1
        return unless ($zoneid == 162 && $instanceversion == 1);

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;

            # --- Proximity A check ---
            my $dx  = $client->GetX() - $spawn_x;
            my $dy  = $client->GetY() - $spawn_y;
            my $dz  = $client->GetZ() - $spawn_z;
            my $d_a = sqrt($dx**2 + $dy**2 + $dz**2);

            if ($d_a <= $spawn_radius && $spawn_ready_a) {
                quest::spawn2(2188, 0, 0, 313.35, -40.34, -6.12, 1.5);
                quest::spawn2(2188, 0, 0, 312.81,  13.23, -6.12, 256.75);
                quest::spawn2(2188, 0, 0, 292.06,  12.69, -6.12, 254.25);
                quest::spawn2(2188, 0, 0, 292.38, -30.50, -6.12, 511.25);

                _marq("You feel eyes in the dark... creeping blights slip from the walls and begin to hunt!");

                $spawn_ready_a = 0;
                quest::settimer("spawn_cooldown_a", $cooldown_secs);
            }

            # --- Proximity B check ---
            my $dx2 = $client->GetX() - $spawn2_x;
            my $dy2 = $client->GetY() - $spawn2_y;
            my $dz2 = $client->GetZ() - $spawn2_z;
            my $d_b = sqrt($dx2**2 + $dy2**2 + $dz2**2);

            if ($d_b <= $spawn2_radius && $spawn_ready_b) {
                quest::spawn2(2188, 0, 0, 609.98, -221.84, -3.94,   3.00);
                quest::spawn2(2188, 0, 0, 609.29, -164.74, -3.94, 256.75);
                quest::spawn2(2188, 0, 0, 569.02, -161.40, -3.94, 261.75);
                quest::spawn2(2188, 0, 0, 567.94, -221.65, -3.94,   2.00);
                quest::spawn2(2188, 0, 0, 525.60, -159.80, -3.94, 255.75);
                quest::spawn2(2188, 0, 0, 525.46, -222.95, -3.94, 511.25);
                quest::spawn2(2188, 0, 0, 483.03, -162.30, -3.94, 250.00);
                quest::spawn2(2188, 0, 0, 484.19, -218.70, -3.94, 511.00);

                _marq("Shadows swarm—more creeping blights converge, drawn by your presence!");

                $spawn_ready_b = 0;
                quest::settimer("spawn_cooldown_b", $cooldown_secs);
            }

            # --- Proximity C check ---
            my $dx3 = $client->GetX() - $spawn3_x;
            my $dy3 = $client->GetY() - $spawn3_y;
            my $dz3 = $client->GetZ() - $spawn3_z;
            my $d_c = sqrt($dx3**2 + $dy3**2 + $dz3**2);

            if ($d_c <= $spawn3_radius && $spawn_ready_c) {
                quest::spawn2(1998, 0, 0, $npc1998_x, $npc1998_y, $npc1998_z, $npc1998_h);

                _marq("The air splits with a guttural roar—the Demogorgon, Guardian of the Basement, awakens!");

                $spawn_ready_c = 0;
                quest::settimer("spawn_cooldown_c", $cooldown_secs);
            }
        }
    }
    elsif ($timer eq "spawn_cooldown_a") {
        $spawn_ready_a = 1;
        quest::stoptimer("spawn_cooldown_a");
    }
    elsif ($timer eq "spawn_cooldown_b") {
        $spawn_ready_b = 1;
        quest::stoptimer("spawn_cooldown_b");
    }
    elsif ($timer eq "spawn_cooldown_c") {
        $spawn_ready_c = 1;
        quest::stoptimer("spawn_cooldown_c");
    }
}

# ---------------------------
# Simple Fisher-Yates shuffle
# ---------------------------
sub shuffle {
    my @array = @_;
    my $i = @array;
    while ($i--) {
        my $j = int(rand($i + 1));
        @array[$i, $j] = @array[$j, $i];
    }
    return @array;
}

# ---------------------------
# Marquee message helper
# ---------------------------
sub _marq {
    my ($text) = @_;
    foreach my $c ($entity_list->GetClientList()) {
        next unless $c;
        $c->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }
}