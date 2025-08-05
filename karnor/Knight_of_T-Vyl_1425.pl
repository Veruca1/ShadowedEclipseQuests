sub EVENT_SPAWN {
    # When NPC 1425 spawns, shout the message
    quest::shout("You will not rescue her! Guards, forward march!!!");
}

sub EVENT_SIGNAL {
    # Check if the signal is 1
    if ($signal == 1) {
        # Shout the message
        quest::shout("Very well, I'll handle this myself. Father! Protect me!");

        # Set a timer to handle the depop and transformation
        quest::settimer("transform_npc", 5);
    }
}

sub EVENT_TIMER {
    if ($timer eq "transform_npc") {
        # Stop the timer for the transformation
        quest::stoptimer("transform_npc");

        # Depop NPC 1425 and replace with NPC 1438 at the same location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        $npc->Depop();
        quest::spawn2(1438, 0, 0, $x, $y, $z, $h);  # Spawn NPC 1438 at 1425's position
    }
}
