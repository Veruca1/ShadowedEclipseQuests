sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get player’s unique ID
    my $cooldown_key = "$char_id-kreacher_cd";  # Cooldown flag
    my $cooldown_time = 900;  # 15-minute cooldown (900 seconds)
    my $current_time = time();  # Current timestamp

    if ($text =~ /hail/i) {
        quest::whisper("You there! I need your help. Kreacher has stolen something precious, an artifact that is needed to advance beyond these frozen walls.
                        But he will not return it willingly. He lurks in the shadows, hiding from those who seek him. If you are brave enough, I can summon him...
                        But be warned, once he vanishes, you must wait before you can challenge him again. " . quest::saylink("Are you ready?", 1) . ".");
    }

    elsif ($text =~ /are you ready\??/i) {
        my $last_summon_time = quest::get_data($cooldown_key);

        if (!$last_summon_time || ($current_time - $last_summon_time) > $cooldown_time) {
            # Start cooldown
            quest::set_data($cooldown_key, $current_time);

            # Get Sirius Black's current location
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();

            # Spawn Kreacher (NPC ID: 1734)
            quest::spawn2(1734, 0, 0, $x + 5, $y + 5, $z, $h);
            
            quest::whisper("Be on your guard... Kreacher is near!");
        } 
        else {
            # Calculate remaining cooldown time
            my $remaining_time = $cooldown_time - ($current_time - $last_summon_time);
            my $minutes = int($remaining_time / 60);
            my $seconds = $remaining_time % 60;
            quest::whisper("The magic takes time to recharge. You must wait $minutes minutes and $seconds seconds before trying again.");
        }
    }
}
