sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Check if NPC 25099 is already up
        if (!quest::isnpcspawned(25099)) {
            # If NPC 25099 is not up, spawn it at the specified location
            quest::spawn2(25099, 0, 0, 531.62, 891.63, 13.93, 459.00);
        }
    }
}
