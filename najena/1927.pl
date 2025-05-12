my @illusion_pool = (
    { race => 208, gender => 0, texture => 0, helm_texture => 0 },  # Male Erudite with robe
    { race => 300, gender => 2, texture => 0,  helm_texture => 0 },  # Shade
    { race => 122, gender => 2, texture => 0,  helm_texture => 0 },  # Ghost
    { race => 384, gender => 2, texture => 1,  helm_texture => 0 },  # Banshee
    # Add more illusions here as desired
);

sub EVENT_SPAWN {
    quest::debug("An_Echo_of_the_Past spawned, starting illusion timer.");
    $npc->SetEntityVariable("illusion_index", 0);
    quest::settimer("illusion_swap", 5);
}

sub EVENT_TIMER {
    quest::debug("EVENT_TIMER fired: $timer");
    if ($timer eq "illusion_swap") {
        _cycle_illusion();
    }
}

sub _cycle_illusion {
    my $index = $npc->GetEntityVariable("illusion_index") || 0;
    my $choice = $illusion_pool[$index];

    $npc->SendIllusion($choice->{race}, $choice->{gender}, $choice->{texture}, $choice->{helm_texture});
    quest::debug("Echo illusion cycled to index $index: race $choice->{race}, gender $choice->{gender}, texture $choice->{texture}, helm_texture $choice->{helm_texture}");

    $index = ($index + 1) % scalar(@illusion_pool);
    $npc->SetEntityVariable("illusion_index", $index);
}
