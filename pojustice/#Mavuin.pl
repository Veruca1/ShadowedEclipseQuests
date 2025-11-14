# Mavuin.pl
# PoJustice NPC (Trial Completion)
# Requires hand-in of 6 trial proofs (items 1 through 6) to trigger dialogue
# No qglobals or flags are set

sub EVENT_SAY {
    if ($text=~/Hail/i) {
        quest::whisper("I have been locked away, shamed for a crime I did not commit. If you wish to help me, you must complete the six trials set forth by the Tribunal and obtain proof of your success. Return to me with all six proofs, and perhaps we can find justice together. Make your way up to Jacosh Steldenn — he can get you an audience with the Tribunal.");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1)) {
        my $charid = $client->CharacterID();

        quest::whisper("You have done it... The proof of the six trials is undeniable. I thank you, $name. May this mark the beginning of my redemption.");
        $client->Message(7, "You receive recognition for your deeds — the Tribunal will hear your name.");

        quest::set_data("poj_trial_complete_$charid", 1);
    } else {
        plugin::return_items(\%itemcount);
    }
}