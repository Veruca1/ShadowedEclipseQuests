sub EVENT_SAY {
    if ($text =~ /hail/i && $ulevel >= 30) {
        quest::message(14, "Greetings adventurer, there have been reports of loud noises and a constant hum, coming from The Estate of Unrest. We need someone to investigate these reports. Someone such as yourselves might benefit from such an investigation. Are you " . quest::saylink("interested") . "?");
    } elsif ($text =~ /interested/i && $ulevel >= 30) {
        quest::message(14, "Excellent, please make haste and once complete, please come back here and speak with Dizzy to head to Najena..");
        # Assign the task with ID 5 to the player
        quest::assigntask(5);
    } else {
        quest::message(14, "Begone! I will let you know when it is time for your aid!");
    }
}
