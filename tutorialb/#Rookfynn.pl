sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(75);
        #quest::debug("Rookfynn: Combat started, next HP event set to 75%");
    } else {
       # quest::debug("Rookfynn: Combat ended.");
    }
}

sub EVENT_HP {
    #quest::debug("Rookfynn HP Event Triggered: $hpevent%");

    if ($hpevent == 75) {
        $npc->Emote("lets out a guttural roar as chains rattle in the distance.");
        quest::spawn2(189433, 0, 0, $x + 6, $y + 3, $z, $h);
        quest::ze(15, "A Goblin Slave breaks free and rushes to defend its master!");
        quest::setnexthpevent(50);
    }

    elsif ($hpevent == 50) {
        $npc->Emote("snarls, calling out in a harsh tongue.");
        quest::spawn2(189433, 0, 0, $x - 4, $y - 6, $z, $h);
        quest::ze(15, "Another Goblin Slave answers the call, bounding into the fray.");
        quest::setnexthpevent(25);
    }

    elsif ($hpevent == 25) {
        $npc->Emote("screeches in desperation, blood dripping from his wounds.");
        quest::spawn2(189433, 0, 0, $x, $y + 6, $z, $h);
        quest::ze(15, "A final Goblin Slave charges from the shadows, loyal to the bitter end.");
    }
}
