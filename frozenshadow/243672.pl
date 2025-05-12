my %processed_hp = ();  # Hash to track HP events that have already fired
my @locations = (
    [82.00, 486.00, 307.10, 0.00, 111157],  # Location 1 - NPC 111157
    [82.00, 522.00, 307.10, 0.00, 1854],    # Location 2 - NPC 1854
    [82.00, 556.00, 307.10, 0.00, 1855],    # Location 3 - NPC 1855
    [38.00, 570.00, 307.10, 0.00, 1856],    # Location 4 - NPC 1856
    [-28.00, 570.00, 307.10, 0.00, 1857],   # Location 5 - NPC 1857
    [-66.00, 556.00, 307.10, 0.00, 1858],   # Location 6 - NPC 1858
    [-65.00, 522.00, 307.10, 0.00, 1859],   # Location 7 - NPC 1859
    [-65.00, 486.00, 307.10, 0.00, 1860],   # Location 8 - NPC 1860
);

# Keep track of which location is next for each HP event
my $current_loc = 0;

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("The eclipse is but the beginning—soon the moon will consume your very soul, She desires it!");
        quest::setnexthpevent(80);
    }
}

sub EVENT_HP {
    my %hp_to_check = (
        80 => 70,
        70 => 60,
        60 => 50,
        50 => 40,
        40 => 30,
        30 => 20,
        20 => 10,
        10 => 0,
    );

    # Check if this HP event has already been processed
    if ($processed_hp{$hpevent}) {
        return;  # No shout or action needed, this HP event has been handled
    }

    # Mark this HP event as processed
    $processed_hp{$hpevent} = 1;

    # Generic shout for spawning attacking torches
    quest::shout("The torches of the damned awaken! Let their flame scorch all in their path!");

    # Depop and spawn NPCs based on the current location and event
    depop_and_spawn($current_loc);

    # Move to the next location for the next HP event
    $current_loc = ($current_loc + 1) % scalar(@locations);

    # Set the next HP event if there is one
    if (exists $hp_to_check{$hpevent}) {
        quest::setnexthpevent($hp_to_check{$hpevent});
    }
}

sub depop_and_spawn {
    my ($loc_index) = @_;
    my ($x, $y, $z, $h, $npc_id) = @{$locations[$loc_index]};

    # Depop the specific NPC at the current location
    quest::depopall($npc_id);

    # Spawn NPC 1852 at the same location
    quest::spawn2(1852, 0, 0, $x, $y, $z, $h);
}

sub EVENT_DEATH_COMPLETE {
    # Clear HP event tracking and location index
    %processed_hp = ();  
    $current_loc = 0;

    # Spawn NPC 1861 at specified locations
    quest::spawn2(1861, 0, 0, -18.00, 620.00, 302.85, 130.00);
    quest::spawn2(1861, 0, 0, 23.94, 679.67, 306.10, 194.00);
    quest::spawn2(1861, 0, 0, 35.00, 745.00, 304.85, 260.00);
    quest::spawn2(1861, 0, 0, -19.00, 793.00, 304.85, 130.00);
}
