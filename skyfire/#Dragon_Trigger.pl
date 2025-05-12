sub EVENT_SPAWN {
    quest::settimer("check_globes", 1); # Check every second
}

sub EVENT_TIMER {
    if ($timer eq "check_globes") {
        if (defined $qglobals{door_one} && defined $qglobals{door_two} &&
            defined $qglobals{door_three} && defined $qglobals{door_four} &&
            !defined $qglobals{dragon_not_ready}) {

            # Spawn the NPC
            quest::spawn2(1533, 0, 0, 921.7, 936.8, -172.7, 288.8);

            # Stop this timer and depop the script entity
            quest::stoptimer("check_globes");
            quest::depop_withtimer();
        }
    }
}
