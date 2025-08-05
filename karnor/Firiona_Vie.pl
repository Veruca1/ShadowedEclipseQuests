sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            quest::message(315, "Thank you for rescuing me! The last thing I remember is being held captive by Venril Sathir. I'm not quite sure how Lanys came into play in all this. Please, rest up, and when you are ready, speak with Sir Bard MCquaiden and give him the book you found.");
        }
        quest::settimer("depop", 120); # Set a timer for 2 minutes (120 seconds)
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop(); # Depop Firiona Vie after 2 minutes
    }
}
