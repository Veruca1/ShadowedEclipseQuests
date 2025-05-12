# The zone_controller script will handle the spawning

sub EVENT_SPAWN {
    # Define the location where the NPC should be spawned
    my $x = 195.58;
    my $y = 113.17;
    my $z = 63.58;
    my $h = 351.75;  # Heading

    # Spawn NPC with ID 117094 at the specified location
    quest::spawn2(117094, 0, 0, $x, $y, $z, $h);  # Spawning the NPC at the given location
}
