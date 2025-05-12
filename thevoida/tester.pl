my @illusion_pool = (
    { race => 223,  texture => 0, gender => 2 }, 
    { race => 224, texture => 0, gender => 0 },  
    { race => 226, texture => 0, gender => 2 },  
    { race => 230, texture => 0, gender => 0 },  
    # Add more illusions here as desired
);

sub EVENT_SPAWN {
    quest::debug("An_Echo_of_the_Past spawned, starting illusion timer.");
    quest::settimer("illusion_swap", 2);
}

sub EVENT_TIMER {
    quest::debug("EVENT_TIMER fired: $timer");
    if ($timer eq "illusion_swap") {
        _set_random_illusion();
    }
}

sub _set_random_illusion {
    my $choice = $illusion_pool[int(rand(@illusion_pool))];
    $npc->SendIllusion($choice->{race}, $choice->{texture}, $choice->{gender}, 0);
    quest::debug("Echo illusion changed: race $choice->{race}, texture $choice->{texture}, gender $choice->{gender}");
}
