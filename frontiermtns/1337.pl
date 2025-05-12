sub EVENT_SPAWN {
    # No timers are started here since she should not perform any actions until combat begins
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Engaged in combat - start the ability timers
        quest::shout("Your suffering has only just begun!");
        quest::settimer("call_of_vazaelle", 20);  # Summons skeletons every 20 seconds
        quest::settimer("ritual_of_despair", 40); # Casts Ritual of Despair every 40 seconds
        quest::settimer("cazics_embrace", 60);    # Casts Cazic's Embrace every 60 seconds
    } else {
        # Out of combat - stop all ability timers
        quest::stoptimer("call_of_vazaelle");
        quest::stoptimer("ritual_of_despair");
        quest::stoptimer("cazics_embrace");
    }
}

sub EVENT_TIMER {
    if ($timer eq "call_of_vazaelle") {
        # Ensure $npc is defined before calling GetID
        if ($npc) {
            quest::doanim(62);  # Optional animation for summoning
            quest::castspell(36862, $npc->GetID());  # Summons skeletons to assist
        }
    }

    if ($timer eq "ritual_of_despair") {
        # Ensure $npc and its target are defined before proceeding
        if ($npc && $npc->GetTarget()) {
            quest::shout("You cannot escape the madness! I will tear your souls apart with these blades of despair!");
            quest::doanim(41);  # Optional animation for ritual casting
            quest::castspell(36863, $npc->GetTarget()->GetID());  # Cast on target
        }
    }

    if ($timer eq "cazics_embrace") {
        # Ensure $npc and its target are defined before proceeding
        if ($npc && $npc->GetTarget()) {
            quest::doanim(53);  # Optional animation for casting
            quest::castspell(36864, $npc->GetTarget()->GetID());  # Debuff on target
        }
    }
}

sub EVENT_DEATH {
    quest::emote("collapses, her body disintegrating as the madness dissipates.");
    quest::shout("You may have defeated me, but the madness will consume you all!");
    
    # You can add any post-death events, such as spawning loot or further encounters
}
