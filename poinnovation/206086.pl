# ===========================================================
# a_clockwork_device.pl (NPC ID 206086) — Plane of Innovation
# Shadowed Eclipse: Endurance Testing Construct
# -----------------------------------------------------------
# - Applies standard Shadowed Eclipse baseline stats.
# - Uses RaidScaling for adaptive difficulty.
# - Ensures full HP after scaling.
# - When reaching (1125, 0), signals Manaetic_Behemoth (206046),
#   casts Energy Burst (2321), and depops.
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

     # Explicit level set for tuning consistency
     $npc->SetLevel(60);

    # Apply baseline stats and scaling
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Start positional leash check timer
    quest::settimer(4, 1);
}

sub EVENT_TIMER {
    if ($timer == 4 && $x == 1125 && $y == 0) {
        # Signal Manaetic_Behemoth (206046)
        quest::signalwith(206046, 1, 1);

        # Cast Energy Burst (2321) targeting self (206086)
        $npc->CastSpell(2321, 206086);

        # Depop after triggering
        quest::depop();
    }
}