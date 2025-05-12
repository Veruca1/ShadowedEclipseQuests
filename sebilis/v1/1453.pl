sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::worldwidemessage(257, "When the ancient trees groan and the whispers of the lost weave through the branches, beware, adventurers... the Forbidden Forest stirs once again. Strange eyes watch from the shadows, and the veil between this world and the next grows thin.");
        quest::worldwidemessage(257, "Welcome, brave souls, to the cursed forest of Kithicor. Spirits long forgotten roam these woods, eager to test the courage of those who dare trespass. You may seek treasure or glory, but beware—the forest seeks something far more valuable.");
        quest::worldwidemessage(257, "Step lightly, for the ground beneath you is not as still as it seems. In the Forbidden Forest, not everything that dies stays dead.");
    }
}
