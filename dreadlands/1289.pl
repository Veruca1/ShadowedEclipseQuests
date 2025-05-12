sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        quest::whisper("Greetings, $name. I can transport you to The Field of Bone, The Frontier Mountains, Warsliks Woods, The Overthere, The Emerald Jungle, The Lake of Ill Omen, Trakanon's Teeth, Firiona Vie, Karnor's Castle, or Iceclad Ocean. Please select your destination by clicking the options below: " . 
                        quest::saylink("FoB", 1) . ", " . 
                        quest::saylink("FM", 1) . ", " . 
                        quest::saylink("WW", 1) . ", " . 
                        quest::saylink("OT", 1) . ", " . 
                        quest::saylink("EJ", 1) . ", " . 
                        quest::saylink("LOIO", 1) . ", " . 
                        quest::saylink("Trakanon", 1) . ", " . 
                        quest::saylink("FV", 1) . ", " . 
                        quest::saylink("Karnor", 1) . ", or " . 
                        quest::saylink("Iceclad", 1) . ".");
    }
    elsif ($text =~ /FoB/i) {
        quest::whisper("Very well! I will transport you to The Field of Bone.");
        quest::movepc(78, 1617.00, -1684.00, -49.25); # Field of Bone coordinates
    }
    elsif ($text =~ /FM/i) {
        quest::whisper("Very well! I will transport you to The Frontier Mountains.");
        quest::movepc(92, -3991.94, -601.07, 96.00, 182.25); # Frontier Mountains coordinates
    }
    elsif ($text =~ /WW/i) {
        quest::whisper("Very well! I will transport you to Warsliks Woods.");
        quest::movepc(79, -468.00, -1324.02, 198.99, 0.00); # Warsliks Woods coordinates
    }
    elsif ($text =~ /OT/i) {
        quest::whisper("Very well! I will transport you to The Overthere.");
        quest::movepc(93, 1922.24, 3153.48, -49.03, 353.50); # The Overthere coordinates
    }
    elsif ($text =~ /EJ/i) {
        quest::whisper("Very well! I will transport you to The Emerald Jungle.");
        quest::movepc(94, 4648.00, -1223.00, 2.00, 0.00); # Emerald Jungle coordinates
    }
    elsif ($text =~ /LOIO/i) {
        quest::whisper("Very well! I will transport you to The Lake of Ill Omen.");
        quest::movepc(85, 1158.31, -301.09, 79.08, 390.00); # Lake of Ill Omen coordinates
    }
    elsif ($text =~ /Trakanon/i) {
        quest::whisper("Very well! I will transport you to Trakanon's Teeth.");
        quest::movepc(95, -4814.08, -1549.92, -470.83); # Trakanon's Teeth coordinates
    }
    elsif ($text =~ /FV/i) {  # Firiona Vie option
        quest::whisper("Very well! I will transport you to Firiona Vie.");
        quest::movepc(84, 1266.72, -2573.69, -14.66, 298); # Firiona Vie coordinates
    }
    elsif ($text =~ /Karnor/i) {  # Added Karnor's Castle option
        quest::whisper("Very well! I will transport you to Karnor's Castle.");
        quest::movepc(102, 296.70, 13.71, 3.13, 387.50); # Karnor's Castle coordinates
    }
    elsif ($text =~ /Iceclad/i) {  # Iceclad Ocean option
        quest::whisper("Very well! I will transport you to Iceclad Ocean.");
        quest::movepc(110, -5432.00, -2796.00, -20.00, 120.00); # Iceclad Ocean coordinates
    }
    elsif ($text =~ /friend/i) {  # Secret transport option
        quest::whisper("Ah, a friend indeed! Prepare for transport.");
        quest::movepc(71, 541.55, 1478.40, -655.22, 222.75); # Airplane zone coordinates
    }
}
