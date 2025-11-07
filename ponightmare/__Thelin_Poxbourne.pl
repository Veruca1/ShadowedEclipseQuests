#__Thelin_Poxbourne

sub EVENT_SPAWN {
    quest::settimer(7, 600);
    quest::settimer("emote1", 6);
    quest::settimer("emote2", 12);
    quest::settimer("emote3", 18);
}

sub EVENT_TIMER {
    if ($timer eq "7") {
        quest::stoptimer(7);
        quest::depop();
    }

    if ($timer eq "emote1") {
        quest::stoptimer("emote1");
        quest::say("Terris, hear me now!  I have done as you asked.  My beloved dagger is whole once again!  Now keep up your part of the bargain.");
        quest::signalwith(204065, 1, 0); # #Terris_Thule emote 1
    }

    if ($timer eq "emote2") {
        quest::stoptimer("emote2");
        quest::say("Vile wench, I knew in the end it would come to this.  You shall pay dearly for your injustice here.");
        quest::signalwith(204065, 2, 0); # #Terris_Thule emote 2
    }

    if ($timer eq "emote3") {
        quest::stoptimer("emote3");
        quest::say("So then my hope is nearly lost.  Take my dagger with you and make use of it to somehow enter her lair and destroy her.  If I cannot escape from this forsaken plane under her rules, I shall make my own!");
    }
}

sub EVENT_SAY {
    if ($text =~ /Hail/i) {
        my $current_level = $client->GetLevel();

        if ($current_level < 63) {
            $client->Message(0, "Thelin Poxbourne tells you, 'Please destroy her for subjecting me to her hideous visions.'");
            $client->Message(15, "You feel a surge of clarity and power as Thelin’s torment fades from this realm!");
            $client->SetLevel(63);
            $npc->CastSpell(1195, $userid); # Waking Moment
            quest::we(15, "$name has reached level 63!"); # World message
        }
        else {
            $client->Message(0, "Thelin Poxbourne regards you solemnly. 'You have already surpassed the strength I could offer.'");
        }
    }

    if ($text =~ /return/i) {
        quest::movepc(204, -1520, 1104, 125); # Zone: ponightmare
    }
}