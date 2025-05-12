my $spawned_1541 = 0;  # Variable to track if NPC 1541 has been spawned
my $spawned_1542 = 0;  # Variable to track if NPC 1542 has been spawned
my $engaged = 0;       # Variable to track if the NPC is engaged in combat

sub EVENT_SPAWN {
    # Shout when the NPC spawns
    quest::shout("The Veil will suffocate you!");
    # Start the timer to depop after 5 minutes if not engaged
    quest::settimer("depop_timer", 300);  # 5 minutes = 300 seconds
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has engaged in combat
        $engaged = 1;
        # Stop the depop timer when in combat
        quest::stoptimer("depop_timer");
        # Start health check timer
        quest::settimer("health_check", 5);  # Check health every 5 seconds during combat
    } else {
        # NPC has disengaged from combat
        $engaged = 0;
        # Stop the health check timer when out of combat
        quest::stoptimer("health_check");
        # Restart the depop timer when out of combat
        quest::settimer("depop_timer", 300);
    }
}

sub EVENT_TIMER {
    if ($timer eq "health_check") {
        my $current_hp = $npc->GetHP();

        # Spawn NPC 1541 only once when health reaches 500,000
        if ($current_hp <= 500000 && !$spawned_1541) {
            quest::spawn2(1541, 0, 0, $x, $y, $z, $h);  # Spawning NPC 1541 at current NPC location
            $spawned_1541 = 1;  # Mark that NPC 1541 has been spawned
        }

        # Spawn NPC 1542 only once when health reaches 250,000
        if ($current_hp <= 250000 && !$spawned_1542) {
            quest::spawn2(1542, 0, 0, $x, $y, $z, $h);  # Spawning NPC 1542 at current NPC location
            $spawned_1542 = 1;  # Mark that NPC 1542 has been spawned
        }
    }

    # Depop the NPC if it's not engaged for 5 minutes
    if ($timer eq "depop_timer") {
        if ($engaged == 0) {
            # Shout before depopping
            quest::shout("As I suspected, unworthy!");
            quest::depop();  # Depop the NPC if not engaged in combat
        }
    }
}
