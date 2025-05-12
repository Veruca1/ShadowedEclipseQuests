sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::shout("Well now, you finally made it this far. Welcome fools, to your future's end!");
        if (!quest::isnpcspawned(1456)) {
            quest::spawn2(1456, 0, 0, -386.58, -985.03, -100.79, 2.75);
        }
    }
    elsif ($signal == 2) {
        quest::shout("Xyron should have stomped on you, he was weak. Ah well, all in due time.");
        if (!quest::isnpcspawned(1457)) {
            quest::spawn2(1457, 0, 0, 224.87, -1887.76, -123.18, 0.75);
        }
    }
    elsif ($signal == 3) {
        quest::shout("So how have you enjoyed your little tour of history and time manipulation?");
        if (!quest::isnpcspawned(1458)) {
            quest::spawn2(1458, 0, 0, 784.05, -1160.06, -87.18, 0.75);
        }
    }
    elsif ($signal == 4) {
        quest::shout("I'm afraid though, class is almost dismissed mortal!");
        if (!quest::isnpcspawned(1465)) {
            quest::spawn2(1465, 0, 0, 108.95, -916.88, -167.17, 1.50);
        }
    }
    elsif ($signal == 5) {
        # Send a marquee message to all clients for signal 5
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A dead silence fills the air...");
        }
    }
}