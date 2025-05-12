sub EVENT_SPAWN {
    quest::shout("Neh`Ashiir betrayed me, my daughter lost to eternal torment, and now you dare to stand before me! I will make you suffer as I have!");
    quest::setnexthpevent(75);  # Start first phase at 75% health
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::shout("You are nothing but insects! Feel my wrath!");
        quest::modifynpcstat("attack_delay", 4);  # Adjust attack speed for the NPC (faster)
        quest::spawn2(1395, 0, 0, $x + 10, $y, $z, $h);  # Summon an enraged add to assist the NPC
        quest::setnexthpevent(50);  # Set the next HP event at 50%
    } elsif ($hpevent == 50) {
        quest::shout("The pain of betrayal burns within me! I will destroy everything in my path!");
        quest::modifynpcstat("AC", 3000);  # Increase armor class for the NPC (tougher defense)
        quest::setnexthpevent(25);  # Set the next HP event at 25%
    } elsif ($hpevent == 25) {
        quest::shout("You think this will end my suffering? My rage is eternal!");
        quest::modifynpcstat("min_hit", 600);  # Increase the NPC's minimum damage
        quest::modifynpcstat("max_hit", 1300);  # Increase the NPC's maximum damage
        quest::setnexthpevent(10);  # Set the next HP event at 10%
    } elsif ($hpevent == 10) {
        quest::shout("I will see you all dead, just like the rest of my family! You will pay for this!");
        quest::modifynpcstat("attack_delay", 4);  # Attack faster for the final phase
        # Spawn multiple helper NPCs for the final phase
        quest::spawn2(1395, 0, 0, $x + 5, $y + 5, $z, $h);  
        quest::spawn2(1395, 0, 0, $x - 5, $y - 5, $z, $h);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("My suffering... will never end... not even in death.");
    # Optionally trigger events or spawn additional NPCs upon death
}
