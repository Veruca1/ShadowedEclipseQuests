my $crusader_charge_timer = 0;
my $crusader_charge_spell_id = 36952;
my $crusader_charge_chance = 20;  # 20% chance to stun

sub EVENT_SPAWN {
    quest::settimer("aura", 5);
    quest::settimer("dark_vengeance", 10);
    quest::settimer("shield", 60);
    quest::settimer("crusader_charge", 30);
    quest::settimer("check_engagement", 300);  # 5 minutes for depop if not engaged
    quest::shout("You gotta pay the troll toll!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Only start casting spells if the NPC is in combat
        if (!$aura_active) {
            quest::castspell(36951, $npc->GetID());  # Aura of the Champion
            $aura_active = 1;
        }

        $dark_vengeance_cast = 0;
        $shield_active = 0;
        $crusader_charge_timer = 0;

        quest::settimer("aura", 5);
        quest::settimer("dark_vengeance", 10);
        quest::settimer("shield", 60);
        quest::settimer("crusader_charge", 30);  # Start the charge timer during combat
    } else {
        # Stop timers if out of combat
        quest::stoptimer("aura");
        quest::stoptimer("dark_vengeance");
        quest::stoptimer("shield");
        quest::stoptimer("crusader_charge");
        $aura_active = 0;
        $dark_vengeance_cast = 0;
        $shield_active = 0;
        $crusader_charge_timer = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_engagement") {
        if ($combat_state == 0) {  # If the NPC is not in combat
            quest::shout("Me knew you weak!");
	    quest::depop();  # Depop the NPC after 5 minutes of inactivity
        }
    }

    if ($combat_state == 1) {  # Only execute abilities while in combat
        if ($timer eq "aura") {
            # Aura of the Champion remains active while in combat
        }

        if ($timer eq "dark_vengeance") {
            my $hp_ratio = $npc->GetHPRatio();
            if ($hp_ratio <= 50 && !$dark_vengeance_cast) {
                quest::castspell(36949, $npc->GetID());  # Dark Vengeance II
                $dark_vengeance_cast = 1;
            }
        }

        if ($timer eq "shield") {
            if (!$shield_active) {
                quest::castspell(36950, $npc->GetID());  # Shield of the Guardian II
                $shield_active = 1;
            }
        }

        if ($timer eq "crusader_charge") {
            my $target = $npc->GetHateTop();  # Get the top aggro target
            if ($target) {
                # Check for stun chance
                if (int(rand(100)) < $crusader_charge_chance) {
                    quest::castspell($crusader_charge_spell_id, $target->GetID());  # Cast Crusader’s Charge
                }
            }
            quest::settimer("crusader_charge", 30);  # Restart the charge timer
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("aura");
    quest::stoptimer("dark_vengeance");
    quest::stoptimer("shield");
    quest::stoptimer("crusader_charge");
}
