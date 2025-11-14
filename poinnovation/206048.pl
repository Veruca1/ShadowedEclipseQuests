# ===========================================================
# #a_greasy_clockwork (NPC ID 206086) — Plane of Innovation
# Shadowed Eclipse: Endurance Testing Construct
# -----------------------------------------------------------
# - Applies standard Shadowed Eclipse baseline stats.
# - Uses RaidScaling for adaptive difficulty.
# - Ensures full HP after scaling.
# - 25% chance to spawn Junk Beast (206060) on death.
# - When reaching (1125, 0), signals Manaetic_Behemoth (206046),
#   casts Energy Burst (2321), and depops.
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;
    $npc->SetLevel(66);  # Explicitly set level to 66

    # Apply baseline stats and scaling
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Start positional leash check timer
    quest::settimer(4, 1);
}

sub EVENT_DEATH_COMPLETE {
    # 25% chance to spawn Junk Beast
    if (int(rand(100)) < 25) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::shout("The grounds of innovation shakes... something massive stirs.");
        quest::spawn2(206060, 0, 0, $x, $y, $z, $h);  # Spawn Junk Beast at current location
    }
}