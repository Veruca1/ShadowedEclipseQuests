sub EVENT_SPAWN {
    # Spawn shout for Haggle Baron Dalnir
    quest::shout("You dare enter my crypt?! I suffered endless torment, and now you will pay the price for defiling my resting place!");
}

sub EVENT_DEATH_COMPLETE {
    # Death shout for Haggle Baron Dalnir
    quest::shout("Even in death, my suffering shall haunt this place... you will never be free!");
}