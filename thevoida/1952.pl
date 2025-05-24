sub EVENT_SAY {
    if ($text=~/hail/i) {
        if (defined $client && $client->IsClient()) {
            my $aa_ranks = $client->GetAAByAAID(405); # Secondary Recall

            if (defined $aa_ranks && $aa_ranks >= 1) {
                plugin::Whisper("Ah, I see you've mastered the art of secondary recall. Here, take this stone.");
                quest::summonitem(40469); # Stone of the Eclipse
            } else {
                plugin::Whisper("Greetings, traveler. Return to me once you have expanded your arcane abilities.");
            }
        } else {
            quest::say("You're not a valid client.");
        }
    }
}