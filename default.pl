my @tint_ids = (10, 20, 30, 40, 50);  # replace with valid tint IDs from npct.ini
my $tint_index = 0;

sub EVENT_SPAWN {
    quest::settimer("tint_cycle", 2);  # every 5 seconds
}

sub EVENT_TIMER {
    if ($timer eq "tint_cycle") {
        $npc->SetNPCTintIndex($tint_ids[$tint_index]);
        $tint_index = ($tint_index + 1) % scalar(@tint_ids);  # wrap around
    }
}
