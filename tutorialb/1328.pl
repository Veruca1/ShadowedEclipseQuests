sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my $instance_link = quest::silent_saylink("instance");
        quest::whisper("If you would like your own private instance of this place just let me know. Then I can send you to an $instance_link if you like.");
    } elsif ($text =~ /instance/i) {
        my $type = $group ? "group" : "solo";
        quest::whisper("Cya!");
        $client->SendToInstance($type, $zonesn, 0, $x, $y, $z, 0, "tutorialb", 7200);
    }
}