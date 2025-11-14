sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Hey there! You here to help me beat Deyid the Twisted? If you're down, just say [" 
            . quest::saylink("Sure, I'll help", 1) . "].");
    }

    elsif ($text =~ /Sure, I'll help/i) {
        plugin::Whisper("Awesome! When you and your group are ready, just say [" 
            . quest::saylink("ready", 1) . "] and I’ll send you in.");
    }

    elsif ($text =~ /ready/i) {
        my $inst_id = $client->GetInstanceID();
        if ($inst_id > 0) {
            plugin::Whisper("Alright, sending you in. Good luck!");
            $client->MovePCInstance(204, $inst_id, 1194, 1121, 280, 0);
        } else {
            plugin::Whisper("Uh… you're not inside an instance. I can't send you in unless you're part of one.");
        }
    }
}

sub EVENT_SIGNAL {
    quest::shout("Thanks! I think that did it. Maybe Mother's Locket will work again now...");
    quest::depop_withtimer();
}