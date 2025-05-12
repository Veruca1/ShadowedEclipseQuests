sub EVENT_SPAWN {
    quest::delglobal("tserrina_slow_casted");  # Reset global on spawn
    quest::delglobal("tserrina_charm_timer");  # Reset charm timer on spawn
    quest::shout("Foolish mortals, you climb my tower only to meet your doom! The Coven has shown me true power—your suffering will amuse me!");
    spawn_random_adds();  # Spawn random adds at the start of the fight
    quest::setnexthpevent(75);  # Set the first HP event for 75%
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When entering combat
        quest::shout("Did you really think you could reach me unscathed? Nyseria has blessed me with dominion over this wretched place. Now, you will learn what it means to despair!");

        # Cast Glyphdust Slow AE (40672) once per fight
        if (!defined $qglobals{"tserrina_slow_casted"}) {
            $npc->CastSpell(40672, $npc->GetHateTop()->GetID());  # Cast on top aggro player
            quest::setglobal("tserrina_slow_casted", 1, 5, "F");  # Prevent recast in same fight
        }

        # Start timer for charm spell
        quest::settimer("tserrina_charm", 5);  # First cast after 5 seconds
    } 
    else {  # When exiting combat
        quest::delglobal("tserrina_slow_casted");
        quest::stoptimer("tserrina_charm");  # Stop charm timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "tserrina_charm") {
        cast_charm_spell();
        quest::settimer("tserrina_charm", 30);  # Recast charm every 30 seconds
    }
}

sub cast_charm_spell {
    my @hate_list = $npc->GetHateList();  # Get all targets on the hate list
    if (scalar @hate_list > 0) {
        my $target = $hate_list[int(rand(@hate_list))]->GetEnt();  # Pick a random target
        if ($target && $target->IsClient() || $target->IsBot()) {  # Ensure it's a valid player or bot
            $npc->CastSpell(40674, $target->GetID());  # Cast charm spell
            quest::shout("You belong to the Coven now!");
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 75) {
        spawn_random_adds();  # Spawn random adds at 75%
        quest::setnexthpevent(50);  # Set next add spawn event at 50%
    }
    elsif ($hpevent == 50) {
        spawn_random_adds();  # Spawn random adds at 50%
        quest::setnexthpevent(25);  # Set next add spawn event at 25%
    }
    elsif ($hpevent == 25) {
        spawn_random_adds();  # Spawn random adds at 25%
    }
}

sub spawn_random_adds {
    if ($npc->IsEngaged()) {  # Only spawn adds if the NPC is still in combat
        my $num_adds = int(rand(3)) + 1;  # Randomly spawn 1 to 3 adds
        for (my $i = 0; $i < $num_adds; $i++) {
            quest::spawn2(1863, 0, 0, $npc->GetX() + rand(10) - 5, $npc->GetY() + rand(10) - 5, $npc->GetZ(), $npc->GetHeading());
        }
        quest::shout("Rise, my servants! Feast upon their fear!");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("No... this was not foreseen... The Coven will not forget this treachery...! You may have defeated me, but you will not escape her grasp! Nyseria will make you hers!");
}