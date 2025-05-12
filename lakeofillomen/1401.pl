sub EVENT_DEATH_COMPLETE {
  my $npc_id = 1399;

  # Check if NPC 1399 is already up
  if (!quest::isnpcspawned($npc_id)) {
    # If NPC 1399 is not up, spawn it at the specified location
    quest::spawn2($npc_id, 0, 0, -319.73, -393.83, 35.22, 100.75);  
  }
}