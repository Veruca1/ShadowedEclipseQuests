use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON;

# Function to clean and prepare the response
sub clean_response {
    my ($response) = @_;
    $response =~ s/https?:\/\/\S+//g;  # Remove URLs
    $response =~ s/[^a-zA-Z0-9 .,!?'"-]//g;  # Remove invalid characters
    $response =~ s/\s+/ /g;  # Normalize whitespace
    $response =~ s/^\s+|\s+$//g;  # Trim leading/trailing whitespace
    return $response;
}

# Split a response into smaller chunks
sub split_response {
    my ($response, $max_length) = @_;
    $max_length ||= 150;  # Default chunk size
    my @chunks;

    while (length($response) > $max_length) {
        my $pos = rindex($response, ' ', $max_length);
        $pos = $max_length if $pos == -1;  # Fall back if no space found
        push @chunks, substr($response, 0, $pos);
        $response = substr($response, $pos + 1);
    }

    push @chunks, $response if $response;
    return @chunks;
}

# Handle player dialogue with the NPC
sub EVENT_SAY {
    my $ua = LWP::UserAgent->new;
    my $server = "http://127.0.0.1:5000/chat";

    # Fetch player information
    my $player_name = $client->GetName();
    my $player_class = $class_map{$client->GetClass()} || "Unknown Class";
    my $player_level = $client->GetLevel();
    my $player_race = $race_map{$client->GetRace()} || "Unknown Race";

    # Prepare the context
    my $character_context = <<"END_CONTEXT";
You are an NPC in the EverQuest universe. Respond in-character.
The player interacting with you is:
- Name: $player_name
- Class: $player_class
- Level: $player_level
- Race: $player_race
END_CONTEXT

    my $prompt = "$character_context\n---\nPlayer: \"$text\"\nNPC:";

    # Send the request to the external server
    my $json_payload = encode_json({ prompt => $prompt });
    my $response = $ua->request(
        POST $server,
        Content_Type => 'application/json',
        Content      => $json_payload
    );

    if ($response->is_success) {
        my $data = eval { decode_json($response->decoded_content) };
        if ($data && $data->{response}) {
            my @chunks = split_response(clean_response($data->{response}));
            for my $chunk (@chunks) {
                quest::whisper($chunk);
            }
        } else {
            quest::whisper("Hmm, I seem to have misunderstood. Could you repeat that?");
        }
    } else {
        quest::whisper("I'm having trouble reaching my thoughts.");
    }
}

# Other Event Functions (Combat, Enter, Death, etc.)
sub EVENT_COMBAT {
    my $combat_state = $_[1];
    if ($combat_state == 1) {
        quest::whisper("You dare challenge me, " . $client->GetName() . "? Prepare for battle!");
    } else {
        quest::whisper("Coward! You flee from the battle!");
    }
}

sub EVENT_ENTER {
    quest::whisper("Welcome, brave adventurer! What brings you to my presence?");
}

sub EVENT_DEATH {
    quest::shout("Alas! I have fallen... but the tales of my adventures shall live on!");
}
