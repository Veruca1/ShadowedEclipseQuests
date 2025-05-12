sub EVENT_ENTERZONE {
    # Check if the player has the sustenance buff already
    my $buff_check = $client->GetGlobal("sustenance_buff");

    # If the global variable does not exist, cast the spell
    if (!$buff_check) {
        # Cast the Song of Sustenance (spell ID 2602) on the player
        $client->CastSpell(2602, $client->GetID());

        # Set a global variable to indicate the buff has been applied
        $client->SetGlobal("sustenance_buff", "1", 5, "F");  # Lasts 5 minutes
    }
}