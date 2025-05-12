sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Hail, brave adventurer! I am Sir Bard McQuaiden, keeper of ancient relics. I possess a cloak of immense power — a treasure for those deemed worthy.");
        quest::popup("Sir Bard McQuaiden's Request", "
        <c '#FFCC00'>*Sir Bard McQuaiden stands proudly, his voice ringing with strength.*</c><br><br>

        \"Throughout these lands, lesser minions roam — mindless husks of once-proud defenders. From their remains, a fragment of power remains... the <c '#00FF00'>Power of the Chosen</c>.<br><br>

        Bring me <c '#00FF00'>25 Powers of the Chosen</c>, and I shall entrust you with the <c '#FFA500'>Cloak of the Chosen</c> — a mantle of strength worthy of legends.\"<br><br>

        <c '#FFCC00'>*He fixes you with a steady gaze.*</c><br><br>

        \"Seek them out. Prove your worth.\"
        ");
    }
}

sub EVENT_ITEM {
    my $chosen_power_id = 33187; # Power of the Chosen
    my $reward_cloak_id = 30583; # Cloak of the Chosen

    if (plugin::check_handin(\%itemcount, $chosen_power_id => 25)) {
        quest::say("You have done well, champion. Take this Cloak of the Chosen and wear it with pride.");
        quest::summonitem($reward_cloak_id);    # Give the Cloak
        $client->AddAAPoints(5);                # Grant 5 AA points
        quest::ding();                          # Play ding sound
    } else {
        quest::say("This is not what I asked for, adventurer. Bring me <c '#00FF00'>25 Powers of the Chosen</c>.");
        plugin::return_items(\%itemcount);       # Return wrong items
    }
}
