sub EVENT_SPAWN {
    quest::shout("We have to destroy the horcrux, it's the only way to stop him!");
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 865 => 1)) {
        quest::shout("It's gone! We've done it! Now, let's get back to Voldemort and finish this!");
        quest::signalwith(1853, 1);  # Sends signal 1 to NPC 1853
        quest::depop();
    }
}
