# ===========================================================
# #Manaetic_Behemoth.pl — Plane of Innovation (poinnovation)
# Shadowed Eclipse: Endurance Testing Encounter
# -----------------------------------------------------------
# - Applies standard Shadowed Eclipse baseline stats.
# - Uses RaidScaling for adaptive difficulty.
# - Ensures full HP after scaling.
# - Handles leash, aggro, and timed despawn logic.
# - Signals Giwin_Mirakon (206038) and spider_controller (206087) on death.
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # Apply baseline stats and scaling
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Timers: despawn & leash
    quest::settimer(9, 1200);  # Despawn after 20 minutes
    quest::settimer(4, 1);     # Leash check
}

sub EVENT_AGGRO {
    quest::settimer(8, 1200);  # fail timer
    quest::stoptimer(9);       # stop despawn timer
}

sub EVENT_TIMER {
    if ($timer == 9) {
        # Auto-despawn after 20 min if idle
        quest::updatespawntimer(42135, 5000);
        quest::depop();
    }
    elsif ($timer == 4 && ($x < 1010 || $x > 1240)) {
        # Leash back to center area
        $npc->GMMove(1125, 0, 12.5, 0);
    }
}

sub EVENT_DEATH_COMPLETE {
    # Instantly restart Behemoth event loop
    quest::signalwith(206087, 1, 1);  # spider_controller
}