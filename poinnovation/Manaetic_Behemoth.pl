# Manaetic_Behemoth — Untargetable Version (206046)
# Shadowed Eclipse: Plane of Innovation
# -----------------------------------------------------------
# Waits for spider activity to stop for 2 minutes before
# spawning the real #Manaetic_Behemoth (206074).
# -----------------------------------------------------------

my $goactive = 0;
my $first_signal = 0;

sub EVENT_SPAWN {
    $first_signal = 0;
    $goactive = 0;
    quest::debug("Manaetic_Behemoth spawned (untargetable). Awaiting spider signals.");
}

sub EVENT_SIGNAL {
    # Signal 1 comes from spiders
    if ($signal == 1 && $first_signal == 0) {
        quest::settimer(1, 5); # every 5 seconds
        $first_signal = 1;
        quest::debug("First spider signal received. Starting activation timer.");
    } elsif ($signal == 1 && $first_signal == 1) {
        # reset timer progress if spiders still active
        $goactive = 0;
        quest::debug("Spider signal received again — resetting activation countdown.");
    }
}

sub EVENT_TIMER {
    if ($timer == 1) {
        $goactive++;
        quest::debug("Activation counter: $goactive / 24");

        # 24 * 5s = 120 seconds (2 minutes)
        if ($goactive == 24) {
            quest::stoptimer(1);
            quest::debug("Timer reached 2 minutes with no spider activity. Activating Behemoth!");
            BEGIN_MB_EVENT();
        } elsif ($goactive > 24) {
            # Safety reset
            $first_signal = 0;
            $goactive = 0;
            quest::debug("Activation counter exceeded — resetting event.");
        }
    }
}

sub BEGIN_MB_EVENT {
    quest::debug("Spawning targetable #Manaetic_Behemoth (206074).");
    quest::spawn2(206074, 0, 0, $x, $y, $z, 0); # Targetable version
    quest::depop_withtimer(); # Remove untargetable
}