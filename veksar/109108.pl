sub EVENT_DEATH_COMPLETE {
    # Check if NPC 1405 is already spawned
    if (!quest::isnpcspawned(1405)) {
        # Spawn NPC 1405 at the current location of the NPC
        quest::spawn2(1405, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}