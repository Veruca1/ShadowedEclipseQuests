sub EVENT_SPAWN {
    quest::setnexthpevent(95);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Entering combat
        quest::settimer("Lifetap", 20);
    } elsif ($combat_state == 0) {  # Exiting combat
        quest::stoptimer("Lifetap");
        $npc->SetHP($npc->GetMaxHP());
        quest::setnexthpevent(95);
    }
}

sub EVENT_TIMER {
    if ($timer eq "Lifetap") {
        if ($npc->GetTarget()) {
            $npc->SpellFinished(quest::ChooseRandom(862, 993), $npc->GetTarget(), 0, -1);
        }
        quest::settimer("Lifetap", 20);
    }
}

sub EVENT_HP {
    if ($hpevent == 95) {
        quest::setnexthpevent(75);
        quest::spawn2(quest::ChooseRandom(1887, 1888), 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading()) for (1..quest::ChooseRandom(1, 2));
    }
    if ($hpevent == 75) {
        quest::setnexthpevent(55);
        quest::spawn2(quest::ChooseRandom(1887, 1888), 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading()) for (1..quest::ChooseRandom(1, 2));
    }
if ($hpevent == 55) {
    quest::shout("Magic? Pfft. I prefer tricks!");
    $npc->BuffFadeAll();
    $npc->ApplySpellBuff(1729); # Spell: Augment (haste)

    if ($npc->GetHateTop()) {  
        $npc->SpellFinished(955, $npc->GetHateTop()); # Casts spell 955 on the top aggro player
    }

    quest::setnexthpevent(50);
}
    if ($hpevent == 50) {
        quest::setnexthpevent(25);
        quest::spawn2(quest::ChooseRandom(1887, 1888), 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading()) for (1..quest::ChooseRandom(2, 3));
    }
    if ($hpevent == 25) {
        quest::spawn2(quest::ChooseRandom(1887, 1888), 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading()) for (1..quest::ChooseRandom(1, 3));
    }
}
