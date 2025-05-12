my $last_player_name = "";  # Initialize variable to store the name of the player attacking the NPC

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat starts
        $last_player_name = $client ? $client->GetCleanName() : "";  # Store player's name if available
    }
}

sub EVENT_DEATH {
    my $npc_name = $npc->GetCleanName();  # Get the NPC's name
    my $player_name = $last_player_name || "Unknown";  # Use the stored player's name or "Unknown" if no name was captured

    # Announce in-game
    quest::gmsay("$npc_name has been killed by $player_name", 14, 1, 0, 0);

    # Send message to Discord
    quest::discordsend("victory", "$npc_name has been killed by $player_name");

    # Optionally clear the player's name after death
    $last_player_name = "";
}  # <-- Add this closing curly brace
