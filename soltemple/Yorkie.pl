# Track session lockouts by character ID
my %ready_lockout;

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup(
            "Yorkie",
            "<c \"#FF0000\">Well, would you look at that...</c> " .
            "<c \"#FF7F00\">You actually made it here.</c> " .
            "<c \"#FFFF00\">Most never do.</c><br><br>" .

            "<c \"#00FF00\">San Junipero is... different.</c> " .
            "<c \"#00FFFF\">A place where the living can cross into the echo of the dead —</c> " .
            "<c \"#0000FF\">to speak, to see,</c> " .
            "<c \"#8B00FF\">and, yes... to fight them again.</c><br><br>" .

            "<c \"#FF0000\">Here, you’ll be given a chance to relive your past battles.</c> " .
            "<c \"#FF7F00\">Old foes, familiar faces —</c> " .
            "<c \"#FFFF00\">but you won’t know which ones you’ll face until they arrive.</c><br><br>" .

            "<c \"#00FF00\">Defeat them,</c> " .
            "<c \"#00FFFF\">and you’ll walk away with stories no living soul could imagine.</c> " .
            "<c \"#0000FF\">Lose...</c> " .
            "<c \"#8B00FF\">and some memories are better left buried.</c><br><br>" .

            "<c \"#FF0000\">Once a battle ends,</c> " .
            "<c \"#FF7F00\">you’ll have two minutes to leave</c> " .
            "<c \"#FFFF00\">before the system pulls you back.</c> " .
            "<c \"#00FF00\">Consider it...</c> " .
            "<c \"#00FFFF\">a courtesy.</c>"
        );

        my $ready_link = quest::saylink("ready", 1, "Are you ready?");
        plugin::Whisper("So... $ready_link");
    }
    elsif ($text =~ /ready/i) {
        my $char_id = $client->CharacterID();

        # Prevent multiple starts in the same session
        if ($ready_lockout{$char_id}) {
            plugin::Whisper("You've already started a session — you can't start again until the next one.");
            return;
        }

        $ready_lockout{$char_id} = 1;
        plugin::Whisper("Alright... let's begin.");

        # Boss list
        my @bosses = (
            2194, # Hates Heat 3.0
            2195, # Second boss
            2196, # Third boss
        );

        # Random pick with debug
        my $rand_index = int(rand(@bosses));
        my $random_boss = $bosses[$rand_index];
        quest::debug("Random boss index: $rand_index, NPC ID: $random_boss");

        # Spawn the selected boss
        quest::spawn2($random_boss, 0, 0, 4.66, 461.52, 4.06, 262.00);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 87) {
        quest::shout("Attention: You have 2 minutes left to vacate San Junipero!");
        quest::settimer("sj_logout", 120);
    }
}

sub EVENT_TIMER {
    if ($timer eq "sj_logout") {
        quest::stoptimer("sj_logout");

        my @clients = $entity_list->GetClientList();
        foreach my $pc (@clients) {
            my $c = $pc->CastToClient();
            $c->MovePC(
                $c->GetBindZoneID(),
                $c->GetBindX(),
                $c->GetBindY(),
                $c->GetBindZ(),
                0
            );
        }
    }
}