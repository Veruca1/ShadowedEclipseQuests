sub EVENT_AGGRO {
    quest::shout("Who dares disturbs my rest?!");  # Shout when the NPC engages in combat
    quest::settimer("army_of_the_dead", 50);  # Summon minions every 50 seconds
    quest::settimer("soul_crush", 120);  # Cast Soul Crush every 120 seconds
}

sub EVENT_TIMER {
    if ($timer eq "army_of_the_dead") {
        # Summon 1 minions (NPC 1406)
        quest::spawn2(1406, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
      
    } elsif ($timer eq "soul_crush") {
        # Check if there is a top hate target before casting Soul Crush
        my $target = $npc->GetHateTop();
        if ($target) {
            $npc->CastSpell(36890, $target->GetID());
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {  # NPC leaves combat
        quest::stoptimer("army_of_the_dead");
        quest::stoptimer("soul_crush");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("army_of_the_dead");
    quest::stoptimer("soul_crush");
}
