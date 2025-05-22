sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my $forget_link = quest::silent_saylink("forget my spells and disciplines");
        my $teach_link = quest::silent_saylink("I can teach you a thing or two");
        quest::whisper("Greetings, $name! You can $forget_link or $teach_link?");
    } elsif ($text =~ /forget my spells and disciplines/i) {
        quest::whisper("You have chosen to forget all your spells and disciplines.");

        # Forget all spells
        quest::unscribespells();
        quest::untraindiscs();

        quest::whisper("Here you go, drink up.");
    } elsif ($text =~ /I can teach you a thing or two/i) {
        # Max out all skills the player can have
        $client->MaxSkills();

        # Scribe all spells from level 1 up to current level
        quest::scribespells($ulevel);

        # Train all disciplines from level 1 up to current level
        quest::traindiscs($ulevel);

        quest::whisper("All your skills, spells, and disciplines from level 1 to your current level have been learned.");
    }
}