sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        quest::whisper("Greetings, $name. I can transport you to various locations. Please select your destination by clicking the options below: " .
            quest::saylink("Burning Woods", 1) . ", " . 
            quest::saylink("Kerraridge", 1) . ", " . 
            quest::saylink("The Warrens", 1) . ", " . 
            quest::saylink("The Hole", 1) . ", " . 
            quest::saylink("Highpass Hold", 1) . ", " . 
            quest::saylink("The Lair of Paw", 1) . ", " . 
            quest::saylink("The Plane of Fear", 1) . ", " . 
            quest::saylink("Mistmoore", 1) . ", " . 
            quest::saylink("Kedge Keep", 1) . ", " . 
            quest::saylink("Lower Guk", 1) . ", " . 
            quest::saylink("The Plane of Sky", 1) . ", " . 
            quest::saylink("Nagafens Lair", 1) . ", " . 
            quest::saylink("Permafrost", 1) . ", " . 
            quest::saylink("Timorous Deep", 1) . ", or " . 
            quest::saylink("Skyfire Mountains", 1) . ".");
    }
    elsif ($text =~ /Burning Woods/i) {
        quest::whisper("Very well! I will transport you to Burning Woods.");
        quest::movepc(87, -826.07, -4972.86, 204.75, 21.50); 
    }
    elsif ($text =~ /Kerraridge/i) {
        quest::whisper("Very well! I will transport you to Kerraridge.");
        quest::movepc(74, -50.00, 0.00, 0.00); # Placeholder coordinates for Kerraridge
    }
    elsif ($text =~ /The Warrens/i) {
        quest::whisper("Very well! I will transport you to The Warrens.");
        quest::movepc(101, 100.00, 200.00, -10.00); # Placeholder coordinates for The Warrens
    }
    elsif ($text =~ /The Hole/i) {
        quest::whisper("Very well! I will transport you to The Hole.");
        quest::movepc(39, -1045.90, 633.25, -75.56); # Placeholder coordinates for The Hole
    }
    elsif ($text =~ /Highpass Hold/i) {
        quest::whisper("Very well! I will transport you to Highpass Hold.");
        quest::movepc(407, -201.60, -128.81, -20.42); # Placeholder coordinates for Highpass Hold
    }
    elsif ($text =~ /The Lair of Paw/i) {
        quest::whisper("Very well! I will transport you to The Lair of Paw.");
        quest::movepc(18, 48.69, -109.95, 5.59); # Placeholder coordinates for The Lair of Paw
    }
    elsif ($text =~ /The Plane of Fear/i) {
        quest::whisper("Very well! I will transport you to The Plane of Fear.");
        quest::movepc(72, 1324.65, -1176.20, 19.92); # Placeholder coordinates for The Plane of Fear
    }
    elsif ($text =~ /Mistmoore/i) {
        quest::whisper("Very well! I will transport you to Mistmoore.");
        quest::movepc(59, 0.00, 0.00, -50.00); # Placeholder coordinates for Mistmoore
    }
    elsif ($text =~ /Kedge Keep/i) {
        quest::whisper("Very well! I will transport you to Kedge Keep.");
        quest::movepc(64, 5.07, 96.66, 304.67); # Placeholder coordinates for Kedge Keep
    }
    elsif ($text =~ /Lower Guk/i) {
        quest::whisper("Very well! I will transport you to Lower Guk.");
        quest::movepc(66, -217.00, 1197.00, -79.90); # Placeholder coordinates for Lower Guk
    }
    elsif ($text =~ /The Plane of Sky/i) {
        quest::whisper("Very well! I will transport you to The Plane of Sky.");
        quest::movepc(71, 614.00, 1415.00, -662.68); # Placeholder coordinates for The Plane of Sky
    }
    elsif ($text =~ /Nagafens Lair/i) {
        quest::whisper("Very well! I will transport you to Nagafens Lair.");
        quest::movepc(32, 0.00, 0.00, 0.00); # Placeholder coordinates for Nagafens Lair
    }
    elsif ($text =~ /Permafrost/i) {
        quest::whisper("Very well! I will transport you to Permafrost.");
        quest::movepc(73, 0.00, 0.00, 0.00); # Placeholder coordinates for Permafrost
    }
    elsif ($text =~ /Timorous Deep/i) {
        quest::whisper("Very well! I will transport you to Timorous Deep.");
        quest::movepc(96, 0.00, 0.00, 0.00); # Placeholder coordinates for Timorous Deep
    }
    elsif ($text =~ /Skyfire Mountains/i) {
        quest::whisper("Very well! I will transport you to Skyfire Mountains.");
        quest::movepc(91, 2964.87, 2773.00, -75.28, 44.00); # Placeholder coordinates for Skyfire Mountains
    }
}
