sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        quest::whisper("Greetings, $name. I can transport you to various Velious locations. Please select your destination by clicking the options below: " . 
            quest::saylink("Iceclad Ocean", 1) . ", " . 
            quest::saylink("Tower of Frozen Shadow", 1) . ", " . 
            quest::saylink("Eastern Wastes", 1) . ", " . 
            quest::saylink("Crystal Caverns", 1) . ", " . 
            quest::saylink("Velketor's Labyrinth", 1) . ", " . 
            quest::saylink("Cobalt Scar", 1) . ", or " . 
            quest::saylink("Wakening Lands", 1) . ".");
    }
    elsif ($text =~ /Iceclad Ocean/i) {
        quest::whisper("Very well! I will transport you to Iceclad Ocean.");
        quest::movepc(110, 391.40, 5328.36, -14.41, 126.75);
    }
    elsif ($text =~ /Tower of Frozen Shadow/i) {
        quest::whisper("Very well! I will transport you to the Tower of Frozen Shadow.");
        quest::movepc(111, 200.00, 120.00, 0.75, 0.00);
    }
    elsif ($text =~ /Eastern Wastes/i) {
        quest::whisper("Very well! I will transport you to the Eastern Wastes.");
        quest::movepc(116, -4541.92, -4513.60, 371.37, 123.25);
    }
    elsif ($text =~ /Crystal Caverns/i) {
        quest::whisper("Very well! I will transport you to Crystal Caverns.");
        quest::movepc(121, 250.87, 489.47, -74.36, 285.00);
    }
    elsif ($text =~ /Velketor's Labyrinth/i) {
        quest::whisper("Very well! I will transport you to Velketor's Labyrinth.");
        quest::movepc(112, -124.40, 586.43, -150.35, 253.25);
    }
    elsif ($text =~ /Cobalt Scar/i) {
        quest::whisper("Very well! I will transport you to Cobalt Scar.");
        quest::movepc(117, -1629.48, -1062.79, 295.11, 110.50);
    }
    elsif ($text =~ /Wakening Lands/i) {
        quest::whisper("Very well! I will transport you to Wakening Lands.");
        quest::movepc(119, -1052.53, 424.62, -19.18, 62.75);
    }
}
