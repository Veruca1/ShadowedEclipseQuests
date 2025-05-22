my $npc_id = 1955;
my @spawn_points = (
    [-122.63, -32.30, 1.25, 62.50],
    [-57.12, 270.89, 30.77, 428.50],
    [-217.27, 103.34, 16.77, 437.50],
    [-513.94, -445.16, 16.78, 135.00]
);

sub EVENT_SIGNAL {
    #quest::shout("Received signal $signal");
    if ($signal == 1) {
        #quest::shout("Setting 20 minute respawn timer.");
        quest::settimer("spawn_npc", 1200);
    }
}

sub EVENT_TIMER {
    #quest::shout("Timer $timer triggered.");
    if ($timer eq "spawn_npc") {
        quest::stoptimer("spawn_npc");

        if (!quest::isnpcspawned($npc_id)) {
            my $index = int(rand(@spawn_points));
            my ($x, $y, $z, $h) = @{$spawn_points[$index]};
            #quest::shout("Spawning NPC $npc_id at index $index ($x, $y, $z, $h)");
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        } else {
            quest::shout("Spawn timer fired, but NPC $npc_id is already up.");
        }
    }
}