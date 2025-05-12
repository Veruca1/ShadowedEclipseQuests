sub EVENT_SPAWN {
    quest::shout("I have wronged my family, my daughter... but I will not let you meddle in my affairs! You will pay for my sorrow!");
    quest::setnexthpevent(75);  # Start first phase at 75% health
}

sub EVENT_HP {
    my $target = $npc->GetHateTop();

    if ($hpevent == 75) {
        quest::shout("You will not leave this place alive! My sorrow fuels my power!");
        quest::modifynpcstat("mana_regen", 200);
        quest::castspell(36886, $target->GetID()) if $target;
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        quest::shout("My daughter... forgive me! I will burn everything to avenge your torment!");
        quest::modifynpcstat("AC", 300);
        quest::castspell(36885, $target->GetID()) if $target;
        quest::spawn2(1393, 0, 0, $x + 10, $y + 10, $z, $h);
        quest::setnexthpevent(25);
    } elsif ($hpevent == 25) {
        quest::shout("Cazic-Thule punished us all! You cannot understand this suffering!");
        quest::modifynpcstat("max_hit", 900);
        quest::castspell(36887, $target->GetID()) if $target;
        quest::setnexthpevent(10);
    } elsif ($hpevent == 10) {
        quest::shout("These intruders will share our fate!");
        quest::modifynpcstat("attack_delay", 8);
        quest::spawn2(1393, 0, 0, $x - 10, $y - 10, $z, $h);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Zal...forgive me...");
    quest::spawn2(1396, 0, 0, 207.31, 143.62, 290.99, 388.50);  # Spawn Zal`Ashiir at specified location
}
