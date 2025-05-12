sub EVENT_DEATH_COMPLETE {

    quest::shout("Hahahahaha, your corpse will make a nice decoration in the Hate Plane!");
    
    quest::signalwith(77027,5,2); # Notify NPC with ID 77027 with a 2-second delay when NPC 1232 dies
    
}


