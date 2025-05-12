sub EVENT_ITEM_CLICK {
    my $duration = 120; # 2 minutes in seconds

    # Check if the clicked item is item ID 697
    if ($itemid == 697) {
        # Make player invulnerable
        $client->SetInvul(true);
        $client->Message(15, "You feel invincible for 2 minutes!");

        # Set a timer to remove invulnerability
        quest::settimer("remove_invul_697", $duration);
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_invul_697") {
        # Remove invulnerability
        $client->SetInvul(false);
        $client->Message(15, "Your invincibility fades...");

        # Stop the timer
        quest::stoptimer("remove_invul_697");
    }
}