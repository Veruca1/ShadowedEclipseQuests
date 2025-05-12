# NPCID 1297 - General Kurn Machta
# Kurn yells about the fall of the Iksar empire and his twisted experiments

sub EVENT_SPAWN {
    # No shout on spawn
    quest::setglobal("npc_in_combat", 0, 7, "F"); # Global flag to track combat state
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # When NPC engages in combat (on aggro)
        quest::shout("The empire... fallen! But my work here continues. These experiments... they will make me stronger than any emperor.");

        # Spawn Hi-Sminions and announce it
        quest::shout("Time to test my experiments further! Witness the power of my Necromancy!");
        quest::spawn2(1318, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

        # Set a repeating timer to shout about experiments and spawn minions every 10 seconds
        quest::settimer("experiment_shout_and_spawn", 10);
        quest::settimer("special_attack", 20);

        quest::setglobal("npc_in_combat", 1, 7, "F"); # Set combat flag to true
    } else {
        # Combat ends, stop timers and depop all minions
        quest::stoptimer("experiment_shout_and_spawn");
        quest::stoptimer("special_attack");

        # Depop all minions when combat ends
        quest::depopall(1318); # Assuming 1318 is the NPC ID for the minions

        quest::setglobal("npc_in_combat", 0, 7, "F"); # Reset combat flag
    }
}

sub EVENT_TIMER {
    if ($timer eq "experiment_shout_and_spawn") {
        # Ensure minions only spawn if in combat
        if ($qglobals{"npc_in_combat"} == 1) {
            quest::spawn2(1318, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
            quest::shout("Feel the wrath of my experiments!");
        }
    } elsif ($timer eq "special_attack") {
        # Use a custom spell or special attack
        my $client = $npc->GetHateTop();
        if ($client) {
            $npc->CastSpell(500, $client->GetID()); # Example spell ID 500
            $client->Message(14, "Feel the wrath of my experiments!");
        }
    }
}

sub EVENT_DEATH {
    # Stop all timers and depop minions upon death
    quest::stoptimer("experiment_shout_and_spawn");
    quest::stoptimer("special_attack");
    quest::depopall(1318);

    # Get the player who is top on the hate list
    my $client = $npc->GetHateTop();
    if ($client) {
        $client->Message(14, "I may fall... but my work... it will continue. The empire may be lost, but the Iksar will rise again through me...");
    }
    quest::ze(14, "As General Kurn Machta falls, his last words echo: 'The Iksar shall rise again...'");
}
