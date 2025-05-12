sub EVENT_SPAWN {
    quest::shout("Come on! We need to destroy that horcrux before it's too late!");
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 863 => 1)) {
        quest::shout("Brilliant! It's gone! Now, hurry and get back to Voldemort!");
        quest::signalwith(1853, 1);  # Sends signal 1 to NPC 1853
        quest::depop();
    }
}
