# File: The_Big_Cheese.pl

# Ensure the plugin is loaded
require "plugins/boss_damage_lightning.pl";  # This calls in your lightning plugin

# Set initial variables for timers and intervals
my $last_lightning_time = 0;
my $desperate_lightning_triggered = 0;

# Handle when the combat state starts or stops
sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Combat starts
        quest::shout("You dare challenge me? Prepare to get *shredded*!");
        plugin::ApplyBossBuffs($npc, [167, 2177, 161, 649, 2178]);  # Apply initial buffs
        
        # Set the timer for random special attacks
        quest::settimer("lightning_attack", 30);  # Start the attack timer, 30 seconds interval for lightning_overload
    } else {
        # Combat ends
        quest::shout("This battle isn't over... it's just *brie* for now.");
        quest::stoptimer("lightning_attack");  # Stop lightning attacks when combat ends
    }
}

# Handle HP changes and phase transitions
sub EVENT_HP {
    my $hp_ratio = $npc->GetHPRatio();
    
    if ($hp_ratio < 30 && !$desperate_lightning_triggered) {
        # Cast Desperate Lightning at 30% HP
        plugin::ExecuteSpecialAttack($npc, $client, "desperate_lightning");
        $desperate_lightning_triggered = 1;  # Prevent re-triggering this attack
    } elsif ($hp_ratio < 5) {
        # Cast Desperate Lightning at 5% HP
        plugin::ExecuteSpecialAttack($npc, $client, "desperate_lightning");
    }
}

# Timer-based events (like lightning overload attacks)
sub EVENT_TIMER {
    if ($timer eq "lightning_attack") {
        my $current_time = time();
        
        # Only cast lightning overload if 30 seconds have passed
        if ($current_time - $last_lightning_time >= 30) {
            plugin::ExecuteSpecialAttack($npc, $client, "lightning_overload");
            $last_lightning_time = $current_time;  # Update the last attack time
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Check if NPC 1813 is already spawned
    if (!quest::isnpcspawned(1813)) {
        # Spawn NPC 1813 at the specified location
        quest::spawn2(1813, 0, 0, -288.45, -275.56, -247.24, 384.50);
    } else {
        plugin::Whisper("An entity is already in play. You'll need to wait.");
    }
}