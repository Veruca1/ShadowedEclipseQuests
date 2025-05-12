sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::setnexthpevent(75);
       # quest::debug("Combat started, next HP event set to 75%");
    } else {
      #  quest::debug("Combat ended.");
    }
}

sub EVENT_HP {
   # quest::debug("HP Event Triggered: $hpevent%");

    if ($hpevent == 75) {
        quest::emote("lets out a piercing screech as the shadows above begin to stir.");
        quest::spawn2(189450, 0, 0, $x + 5, $y + 5, $z, $h);
        quest::ze(15, "A Gloom Spider drops from the ceiling, rushing to aid their queen.");
        quest::setnexthpevent(50);
    }

    elsif ($hpevent == 50) {
        quest::emote("thrashes wildly, her mandibles clacking in rage.");
        quest::spawn2(189450, 0, 0, $x - 5, $y + 5, $z, $h);
        quest::ze(15, "Another Gloom Spider scuttles from the darkness, hissing in defense.");
        quest::setnexthpevent(25);
    }

    elsif ($hpevent == 25) {
        quest::emote("howls in desperation, her cries echoing through the tunnels.");
        quest::spawn2(189450, 0, 0, $x, $y - 5, $z, $h);
        quest::ze(15, "A final Gloom Spider lunges into the fray from a hidden crevice above.");
    }
}
