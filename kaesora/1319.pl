# NPCID 1319 - Vampire Lord Chosooth
# Chosooth, the inventor of sarnaks and sokokars, spawns sokokar minions during the fight.

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # When Chosooth enters combat, he shouts about his creations.
        quest::shout("You dare to challenge the creator of beings? My creations will tear you apart!");

        # Set a timer to summon Sokokar Minions every 20 seconds.
        quest::settimer("sokokar_summon", 20);
    } else {
        # Stop summoning if combat ends.
        quest::stoptimer("sokokar_summon");
    }
}

sub EVENT_TIMER {
    if ($timer eq "sokokar_summon") {
        # Every 20 seconds, Chosooth spawns a Sokokar Minion.
        quest::shout("Come forth, my loyal Sokokars!");
        quest::spawn2(1322, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_DEATH {
    # When Chosooth dies, he shouts about his creations.
    quest::shout("No... my Sarnaks and Sokokars... I cannot fail them...!");
}
