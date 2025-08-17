# time.pl
# Clock event in Ssra UD

# ---------------------------
# Proximity radius
# ---------------------------
my $proximity_radius = 15;

# ---------------------------
# Spawn locations for Guardians
# ---------------------------
my $guardian1_x = -86.05;   # Guardian 1 loc
my $guardian1_y = 170.41;
my $guardian1_z = -222.94;
my $guardian1_h = 265.75;

my $guardian2_x = -83.24;   # Guardian 2 loc
my $guardian2_y = -190.16;
my $guardian2_z = -222.94;
my $guardian2_h = 2.25;

# ---------------------------
# Location for Vecna (NPC 2185) spawn
# ---------------------------
my $npc2185_x = -59.31;
my $npc2185_y =  -8.22;
my $npc2185_z = -225.12;
my $npc2185_h = 129.75;

# ---------------------------
# Signal counter for 11
# ---------------------------
my $signal11_count = 0;
my $vecna_spawned  = 0; # Prevent multiple spawns

sub EVENT_SPAWN {
    $npc->SetEntityVariable("clock_event_done", "0"); # reset per NPC spawn
    quest::settimer("clock_check", 2); # Check every 2 seconds
}

sub EVENT_TIMER {
    if ($timer eq "clock_check") {
        # Skip if already triggered
        return if ($npc->GetEntityVariable("clock_event_done") eq "1");

        my $cx = $npc->GetX();
        my $cy = $npc->GetY();
        my $cz = $npc->GetZ();

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;

            my $dx = $client->GetX() - $cx;
            my $dy = $client->GetY() - $cy;
            my $dz = $client->GetZ() - $cz;
            my $dist = sqrt($dx**2 + $dy**2 + $dz**2);

            if ($dist <= $proximity_radius) {
                quest::shout("The Clock Guardians awaken!");
                quest::spawn2(2191, 0, 0, $guardian1_x, $guardian1_y, $guardian1_z, $guardian1_h);
                quest::spawn2(2192, 0, 0, $guardian2_x, $guardian2_y, $guardian2_z, $guardian2_h);

                $npc->SetEntityVariable("clock_event_done", "1"); # lock event for this spawn
                quest::stoptimer("clock_check");
                last;
            }
        }
    }
    elsif ($timer eq "spawn_vecna") {
        quest::stoptimer("spawn_vecna");
        quest::spawn2(2185, 0, 0, $npc2185_x, $npc2185_y, $npc2185_z, $npc2185_h);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 11 && !$vecna_spawned) {
        $signal11_count++;

        if ($signal11_count == 2) {
            # Marquee message immediately
            foreach my $c ($entity_list->GetClientList()) {
                next unless $c;
                $c->SendMarqueeMessage(15, 510, 1, 1, 8000, "A cold, deathly presence fills the air... Vecna has arrived!");
            }

            # Start 10-second delay before spawning Vecna
            quest::settimer("spawn_vecna", 10);

            $vecna_spawned = 1; # Prevent further triggers
        }
    }
}