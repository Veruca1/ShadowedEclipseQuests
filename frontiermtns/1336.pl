sub EVENT_SPAWN {
    # Reset any timers and set HP event for transformation at 50% HP
    quest::setnexthpevent(50);
}

sub EVENT_HP {
    if ($hpevent == 50) {
        # At 50% HP, Vazaelle transforms into her Drachnid form
        quest::shout("laughs maniacally as her body twists and transforms!");
        quest::shout("Foolish mortals! My true form will break your minds and shatter your will. Welcome to the madness of Vazaelle!");

        # Get current location and heading of the Erudite form
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Despawn the current Erudite version of Vazaelle
        quest::depop();

        # Spawn the Drachnid version (NPC ID 1337) at the same location
        quest::spawn2(1337, 0, 0, $x, $y, $z, $h);
    }
}
