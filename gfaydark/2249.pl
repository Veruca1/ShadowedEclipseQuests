my $expedition_name = "The Forbidden Forest";
my $min_players     = 1;
my $max_players     = 6;
my $dz_zone         = "kithicor";
my $dz_version      = 1;
my $dz_duration     = 21600;  # 6 hours in seconds

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # === Zone Flagging: The Forbidden Forest ===
        unless ($client->HasZoneFlag(20)) {
            $client->SetZoneFlag(20);
            $client->Message(4, "You receive a character flag for access to The Forbidden Forest!");
            quest::we(15, "$name has earned access to The Forbidden Forest.");
        }

        my $dz = $client->GetExpedition();
        if ($dz && $dz->GetName() eq $expedition_name) {
            plugin::Whisper("Tell me when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            plugin::Whisper("Would you like to [" . quest::saylink("request") . "] the expedition The Forbidden Forest?");
        }
    }
    elsif ($text =~ /request/i) {
        my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
        if ($dz) {
            plugin::Whisper("Expedition created successfully. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            plugin::Whisper("There was an error creating the expedition.");
        }
    }
    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz && $dz->GetName() eq $expedition_name) {
            plugin::Whisper("Moving you to the DZ.");
            $client->MovePCDynamicZone($dz_zone, $dz_version);  # Move the player to the DZ
        } else {
            plugin::Whisper("You are not in the correct expedition to enter.");
        }
    }
}