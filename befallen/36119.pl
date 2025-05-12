# 36119.pl
sub EVENT_SPAWN {
    # Shout a message upon spawning
    quest::shout("You Fool! You should not have come here!");
}

sub EVENT_DEATH_COMPLETE {
    # Shout a message upon death
    quest::shout("Leave while you can, before the flames of hate consume you!");
}