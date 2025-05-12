sub EVENT_SPAWN {
    quest::shout("Hurry! Give me the horcrux from that death eater!");
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 862 => 1)) {
        quest::shout("Perfect! It has been destroyed, now get back to Voldemort!");
        quest::signalwith(1853, 1);  # Sends signal 1 to NPC 1853
        quest::depop();  # Removes Ron Weasley NPC
    }
}
