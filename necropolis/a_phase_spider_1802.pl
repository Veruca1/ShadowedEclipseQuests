# ===========================================================
# a_phase_spider (1802)
# Shadowed Eclipse — Necropolis Trash Scaling
# - Applies trash baseline stats
# - Uses RaidScaling for adaptive difficulty
# ===========================================================

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 5);
}