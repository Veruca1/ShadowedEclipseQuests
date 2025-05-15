# NPC script: cycles through tints every 5 seconds
my @tints = (10, 20, 30, 40); # Replace with valid tint IDs
my $current = 0;

sub EVENT_SPAWN {
    quest::settimer("tintcycle", 5);
}

sub EVENT_TIMER {
    if ($timer eq "tintcycle") {
        $npc->SetNPCTintIndex($tints[$current]);
        $current = ($current + 1) % scalar(@tints);
    }
}