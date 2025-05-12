sub cast_fear {
    quest::emote("begins casting a fearsome roar!");
    my @players = $entity_list->GetClientList();
    foreach my $player (@players) {
        $npc->CastSpell(32940, $player->GetID());  # Use high-level fear spell ID
    }
}

sub EVENT_SPAWN {
    quest::shout("BEWARE! I LIVE");
    $npc->CameraEffect(3000, 6);
    quest::setnexthpevent(75);  # Trigger the next HP event at 75% health
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::shout("RUN COWARD!");
        cast_fear();
        quest::setnexthpevent(50);  # Set the next HP event at 50%
    }
    elsif ($hpevent == 50) {
        quest::shout("RUN!");
        cast_fear();
        quest::setnexthpevent(25);  # Set the next HP event at 25%
    }
    elsif ($hpevent == 25) {
        quest::shout("RUN RUN RUN!");
        cast_fear();
    }
}

sub EVENT_DEATH {
    quest::signalwith(77027, 1, 2); # Notify NPC with ID 77027 with a 2-second delay when NPC 1227 dies
    quest::shout("I AM THE PRETTY HATE MACHINE!");
}
