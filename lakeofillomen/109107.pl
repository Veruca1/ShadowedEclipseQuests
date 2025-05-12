sub EVENT_SPAWN {
    quest::shout("Who dares interfere with my attack on Veksar!");
    quest::settimer("cast_flame_of_veksar", 15);
}

sub EVENT_AGGRO {
    quest::settimer("cast_flame_of_veksar", 15);
}

sub EVENT_TIMER {
    if ($timer eq "cast_flame_of_veksar") {
        if ($client) {
            quest::castspell(36897, $client->GetID());  # Cast Flame of Veksar on player
        }
        quest::settimer("cast_infernal_rupture", 20);
        quest::settimer("cast_flame_of_veksar", 25);
    }
    elsif ($timer eq "cast_infernal_rupture") {
        if ($client) {
            quest::castspell(36898, $client->GetID());  # Cast Infernal Rupture
        }
        quest::settimer("cast_scorching_shadows", 30);  # Fixed Scorching Shadows
        quest::settimer("cast_infernal_rupture", 40);
    }
    elsif ($timer eq "cast_scorching_shadows") {  # Fixed Scorching Shadows
        if ($client) {
            quest::castspell(36899, $client->GetID());  # Cast Scorching Shadows
        }
        quest::settimer("cast_flame_of_veksar", 45);
    }
}

sub EVENT_DEATH {
    quest::stoptimer("cast_flame_of_veksar");
    quest::stoptimer("cast_infernal_rupture");
    quest::stoptimer("cast_scorching_shadows");  # Fixed Scorching Shadows
    quest::shout("Veksar will still sink along with all those within!");
}
