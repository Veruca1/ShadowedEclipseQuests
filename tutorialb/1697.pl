my %responses = ();  # Initialize a hash to store responses for the client
my $step = 0;        # Variable to track progress through the questions

sub EVENT_SAY {
    # Check if the player is level 1
    if ($client->GetLevel() != 1) {
        $client->Message(15, "I will only speak to those who are level 1.");
        return;
    }

    if ($text=~/hail/i) {
        $client->Message(15, "Greetings, traveler. Fate has questions for you.");
        $client->Message(15, "White or Black? " . quest::saylink("White", 1) . " or " . quest::saylink("Black", 1));
        $step = 1;  # Move to the first question (White/Black)
    }
    elsif ($step == 1 && ($text=~/White/i || $text=~/Black/i)) {
        push(@{$responses{$client->GetID()}}, $text=~/White/i ? 'A' : 'B');  # Record response
        $client->Message(15, "Up or Down? " . quest::saylink("Up", 1) . " or " . quest::saylink("Down", 1));
        $step = 2;  # Move to the next question
    }
    elsif ($step == 2 && ($text=~/Up/i || $text=~/Down/i)) {
        push(@{$responses{$client->GetID()}}, $text=~/Up/i ? 'A' : 'B');  # Record response
        $client->Message(15, "Right or Left? " . quest::saylink("Right", 1) . " or " . quest::saylink("Left", 1));
        $step = 3;  # Move to the next question
    }
    elsif ($step == 3 && ($text=~/Right/i || $text=~/Left/i)) {
        push(@{$responses{$client->GetID()}}, $text=~/Right/i ? 'A' : 'B');  # Record response
        $client->Message(15, "Good or Bad? " . quest::saylink("Good", 1) . " or " . quest::saylink("Bad", 1));
        $step = 4;  # Move to the next question
    }
    elsif ($step == 4 && ($text=~/Good/i || $text=~/Bad/i)) {
        push(@{$responses{$client->GetID()}}, $text=~/Good/i ? 'A' : 'B');  # Record response
        $client->Message(15, "Day or Night? " . quest::saylink("Day", 1) . " or " . quest::saylink("Night", 1));
        $step = 5;  # Move to the next question
    }
    elsif ($step == 5 && ($text=~/Day/i || $text=~/Night/i)) {
        push(@{$responses{$client->GetID()}}, $text=~/Day/i ? 'A' : 'B');  # Record response

        # Tally responses
        my $count_A = grep { $_ eq 'A' } @{$responses{$client->GetID()}};
        my $count_B = grep { $_ eq 'B' } @{$responses{$client->GetID()}};

        # Only show the tally to GMs
        quest::debug("Responses so far: A = $count_A, B = $count_B", 1) if $client->GetGM();

        if ($count_A > $count_B) {
            # Move to Crushbone and set zone flags
            quest::set_zone_flag(58);
            quest::we(14, "$name has earned access to Crushbone.");
            $client->Message(15, "Your destiny lies in Crushbone.");
            $client->SetBotSpawnLimit(0);  # Set bot spawn limit to 0
            quest::movepc(58, 159.64, -654.12, 3.13, 30.50);
        }
        elsif ($count_B > $count_A) {
            # Move to Nektulos Forest and set zone flags
            quest::set_zone_flag(25);
            quest::we(14, "$name has earned access to Nektulos Forest.");
            $client->Message(15, "Your fate leads to Nektulos Forest.");
            $client->SetBotSpawnLimit(0);  # Set bot spawn limit to 0
            quest::movepc(25, -934.33, 1817.03, 26.42, 146.50);
        }

        # Reset the flow after completion
        $step = 0;
        %responses = ();  # Clear responses
    }
}
