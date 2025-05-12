my $expedition_name = "City of Mist";
my $min_players     = 1;
my $max_players     = 99;
my $dz_zone         = "citymist";                # Valid zone name
my $dz_version      = 1;                         # Version of the dynamic zone
my $dz_duration     = 2592000;                   # Duration (1 month)

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my $dz = $client->GetExpedition();
        if ($dz && $dz->GetName() eq $expedition_name) {
            plugin::Whisper("Tell me when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            plugin::Whisper("Would you like to [" . quest::saylink("request") . "] the expedition City of Mist?");
        }
    }
    elsif ($text =~ /request/i) {
        my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
        if ($dz) {
            plugin::Whisper("Expedition created successfully. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
            # $dz->AddReplayLockout(21600);  # Remove or comment out this line to disable lockout
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
