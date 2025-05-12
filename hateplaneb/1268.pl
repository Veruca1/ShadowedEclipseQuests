# Script for Shadow of Zarrin (NPCID 1268)

sub EVENT_SPAWN {
    # Initial setup for Shadow of Zarrin
    quest::settimer("zarrin_message", 20); # Send a message shortly after spawning
}

sub EVENT_TIMER {
    if ($timer eq "zarrin_message") {
        # Shadow of Zarrin makes a comment and then despawns
        quest::shout("Xyron's defeat is but a minor setback. My plans for Kunark are already in motion. You will soon understand the true scope of The Eclipse and my power!");
        
        # After speaking, despawn Shadow of Zarrin
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    # Ensure any associated cleanup
}
