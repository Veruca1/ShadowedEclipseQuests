sub EVENT_SPAWN {
    quest::shout("Oi! We gotta smash that horcrux, now!");
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 864 => 1)) {
        quest::shout("Yeah! It's done! Now, let's get back to Voldemort!");
        quest::signalwith(1853, 1);  # Sends signal 1 to NPC 1853
        quest::depop();
    }
}
