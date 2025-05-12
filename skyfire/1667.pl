sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, traveler! I can trade your surplus items for something stronger. If you'd like to trade magical dragon stones or mighty dragon stones, just choose one: " 
            . quest::saylink("Magical Dragon Stone", 1) . " or " . quest::saylink("Mighty Dragon Stone", 1) . ".");
    }
    elsif ($text=~/Magical Dragon Stone/i) {
        quest::whisper("You want to trade Magical Dragon Stones? Hand me 10 magical dragon stones, and I will give you an imbued magical dragon stone.");
        
        # Check if player has at least 10 of item 406 (Magical Dragon Stone)
        if ($client->CountItem(406) >= 10) {
            quest::whisper("You have enough magical dragon stones! Here's your imbued magical dragon stone.");
            quest::summonitem(600218);  # Give item 600218 (Imbued Magical Dragon Stone)
            for (my $i = 0; $i < 10; $i++) {
                quest::removeitem(406, 1);  # Remove 10 items of 406 (Magical Dragon Stone) one at a time
            }
        } else {
            quest::whisper("You do not have enough magical dragon stones. Please hand me exactly 10 magical dragon stones.");
        }
    }
    elsif ($text=~/Mighty Dragon Stone/i) {
        quest::whisper("You want to trade Mighty Dragon Stones? Hand me 10 mighty dragon stones, and I will give you an imbued mighty dragon stone.");
        
        # Check if player has at least 10 of item 407 (Mighty Dragon Stone)
        if ($client->CountItem(407) >= 10) {
            quest::whisper("You have enough mighty dragon stones! Here's your imbued mighty dragon stone.");
            quest::summonitem(600219);  # Give item 600219 (Imbued Mighty Dragon Stone)
            for (my $i = 0; $i < 10; $i++) {
                quest::removeitem(407, 1);  # Remove 10 items of 407 (Mighty Dragon Stone) one at a time
            }
        } else {
            quest::whisper("You do not have enough mighty dragon stones. Please hand me exactly 10 mighty dragon stones.");
        }
    }
}
