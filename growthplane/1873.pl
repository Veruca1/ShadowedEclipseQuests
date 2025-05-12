sub EVENT_COMBAT {
    if ($combat_state == 1) {  # If the NPC enters combat
        # Start the spawn process for 2 NPCs every 30 seconds while in combat
        quest::settimer("spawn_minions", 30);
    }
    elsif ($combat_state == 0) {  # If the NPC leaves combat
        # Stop the spawn process when out of combat
        quest::stoptimer("spawn_minions");
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_minions") {
        # Spawn 2 NPCs with ID 1832 at the current location of the NPC
        quest::spawn2(1832, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1832, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

        # Send a message to chat (shout) every time the NPCs are spawned
        #quest::shout("Two minions have emerged to fight alongside the boss!");
    }
}

sub EVENT_SIGNAL {
    if($signal == 1337) {
        plugin::MobHealPercentage(15);
        quest::shout("The vines pulse with energy giving their life to heal Tunare!");
    }
}
