sub EVENT_SPAWN {
    # No timers on spawn, they start in combat
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat starts
        quest::settimer("blade_slap", 1);  # Blade Slap right at the start
        quest::settimer("stormwheel_blades", 50);  # Stormwheel Blades after 50 seconds
        quest::settimer("phantom_aggressor", 80);  # Phantom Aggressor after 80 seconds
    } elsif ($combat_state == 0) {  # Combat ends
        quest::stoptimer("blade_slap");
        quest::stoptimer("stormwheel_blades");
        quest::stoptimer("phantom_aggressor");
    }
}

sub EVENT_TIMER {
    if ($timer eq "blade_slap") {
        quest::castspell(36889, $npc->GetID());  # Cast Blade Slap every 60 seconds
        quest::settimer("blade_slap", 60);  # Repeat Blade Slap every 60 seconds
    } elsif ($timer eq "stormwheel_blades") {
        quest::castspell(36888, $npc->GetID());  # Cast Stormwheel Blades every 50 seconds
        quest::settimer("stormwheel_blades", 50);  # Repeat Stormwheel Blades every 50 seconds
    } elsif ($timer eq "phantom_aggressor") {
        quest::castspell(40012, $npc->GetID());  # Cast Phantom Aggressor every 80 seconds
        quest::settimer("phantom_aggressor", 80);  # Repeat Phantom Aggressor every 80 seconds
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("blade_slap");
    quest::stoptimer("stormwheel_blades");
    quest::stoptimer("phantom_aggressor");
}
