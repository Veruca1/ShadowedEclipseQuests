# NPCID 1324 - Atrebe Sathir
# Spawns royal guards (NPCID 1325) 40 seconds after combat begins, then every 1 minute

sub EVENT_SPAWN {
    # Reset any existing timers
    quest::stoptimer("spawn_guards");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("Fools! You dare challenge the might of Atrebe Sathir? I crafted the Sarnak to be the ultimate warriors, and I will not fall to mere mortals!");
        # Start a 40-second timer for the first guard spawn
        quest::settimer("first_spawn", 40);
    } else {
        quest::stoptimer("first_spawn");
        quest::stoptimer("spawn_guards");
    }
}

sub EVENT_TIMER {
    if ($timer eq "first_spawn") {
        # Spawn the guards after 40 seconds and start the repeating timer for every minute
        quest::shout("Guards! Protect your emperor!");
        quest::spawn2(1325, 0, 0, 526.26, -64.31, -294.48, 0);
        quest::spawn2(1325, 0, 0, 534.96, -134.74, -291.64, 0);
        quest::spawn2(1325, 0, 0, 589.10, -53.16, -297.17, 0);
        quest::spawn2(1325, 0, 0, 586.72, -136.55, -291.47, 0);
        
        # Start a repeating timer for every 60 seconds after the first spawn
        quest::settimer("spawn_guards", 60);
        quest::stoptimer("first_spawn");
    }

    if ($timer eq "spawn_guards") {
        quest::shout("Guards! Reinforce my defenses!");
        # Spawn 4 more guards every 60 seconds
        quest::spawn2(1325, 0, 0, 526.26, -64.31, -294.48, 0);
        quest::spawn2(1325, 0, 0, 534.96, -134.74, -291.64, 0);
        quest::spawn2(1325, 0, 0, 589.10, -53.16, -297.17, 0);
        quest::spawn2(1325, 0, 0, 586.72, -136.55, -291.47, 0);
    }
}

sub EVENT_DEATH {
    quest::shout("My legacy... shall live on... through the Sarnak...");
    quest::stoptimer("spawn_guards");
    quest::stoptimer("first_spawn");
}
