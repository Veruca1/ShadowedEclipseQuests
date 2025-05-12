# NPCID 1298 - Xiardoth the Time-Lost
# Spawns 2 minions every 25 seconds during the encounter (minions are NPCID 1300)

sub EVENT_SPAWN {
    quest::shout("What? Why am I back here?! The Shissar ruled these lands long before the Iksar empire, and our reign shall return.");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Get the player who is top on the hate list
        my $client = $npc->GetHateTop();
        if ($client) {
            $client->Message(14, "Ah, the Iksar... They were once nothing but slaves, groveling at our feet. And so now all of you shall!.");
        }
        # Set a repeating timer to spawn minions every 25 seconds
        quest::settimer("spawn_minions", 25);
    } else {
        # Stop spawning minions when combat ends
        quest::stoptimer("spawn_minions");

        # Depop all minions (NPCID 1300)
        quest::depopall(1300);

        # Ensure the NPC resets properly
        $npc->WipeHateList();  # Clear the hate list
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_minions") {
        # Check if NPC is in combat to avoid spawning minions when not engaged
        if ($npc->IsEngaged()) {
            # Get the player who is top on the hate list
            my $client = $npc->GetHateTop();
            if ($client) {
                $client->Message(14, "Minions, rise from the echoes of time and serve your master once more!");
            }
            # Spawns 2 minions (NPCID 1300)
            quest::spawn2(1300, 0, 0, $x + 5, $y + 5, $z, $h);
            quest::spawn2(1300, 0, 0, $x - 5, $y - 5, $z, $h);
        } else {
            # If not in combat, stop the timer to prevent spawning
            quest::stoptimer("spawn_minions");
        }
    }
}

sub EVENT_DEATH {
    # Get the player who is top on the hate list
    my $client = $npc->GetHateTop();
    if ($client) {
        $client->Message(14, "Time is a cycle, and though I fall today, the Shissar will rise again. Your defeat is only... inevitable.");
    }
    quest::ze(14, "The ancient magic of Xiardoth fades, but the air is still thick with the weight of time's curse...");
    
    # Depop any remaining minions upon death
    quest::depopall(1300);
}
