sub EVENT_SPAWN {
    quest::shout("Fools! Rak`Ashiir was too weak to hold onto what was his! Neh`Ashiir belongs to me now!");
    quest::setnexthpevent(50);  # Trigger something at 50% health for added difficulty
}

sub EVENT_HP {
    if ($hpevent == 50) {
        quest::shout("You think you've won? I'll never let her go!");  
        # Add difficulty here, like summoning helpers or enraging briefly
        quest::spawn2(123456, 0, 0, $x + 5, $y + 5, $z, $h);  # Spawning a helper NPC
        quest::modifynpcstat("attack_delay", 8);  # Temporary attack speed boost
        quest::setnexthpevent(10);  # Next phase at 10% health
    } elsif ($hpevent == 10) {
        quest::shout("I will not fall so easily! Prepare for my final strike!");
        quest::modifynpcstat("min_hit", 400);  # Temporary damage increase
        quest::modifynpcstat("max_hit", 800);  
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("This... wasn't supposed to happen. Neh... forgive me.");
    # Optionally drop special loot or trigger something
}

