my @illusion_pool = (
    { race => 208, gender => 0, texture => 19, helm_texture => 0 }, 
    { race => 300, gender => 2, texture => 0,  helm_texture => 0 },  
    { race => 122, gender => 2, texture => 0,  helm_texture => 0 },  
    { race => 384, gender => 2, texture => 1,  helm_texture => 0 },  
    { race => 473, gender => 2, texture => 0,  helm_texture => 0 },  
    { race => 549, gender => 2, texture => 4,  helm_texture => 4 },  
    { race => 365, gender => 2, texture => 0,  helm_texture => 0 },  
    { race => 128, gender => 0, texture => 11, helm_texture => 1 }, 
    { race => 128, gender => 0, texture => 3,  helm_texture => 1 }, 
    { race => 522, gender => 1, texture => 11, helm_texture => 3 }, 
    { race => 131, gender => 2, texture => 1,  helm_texture => 1 },
    { race => 95,  gender => 2, texture => 0,  helm_texture => 0 },      
    # Add more illusions here as desired
);

my @shuffled_pool;
my $illusion_index = 0;

sub EVENT_SPAWN {
    @shuffled_pool = _shuffle_array(@illusion_pool);
    $illusion_index = 0;
    quest::settimer("illusion_swap", 5);
}

sub EVENT_TIMER {
    if ($timer eq "illusion_swap") {
        _cycle_illusion();
    }
}

sub _cycle_illusion {
    if ($illusion_index >= scalar(@shuffled_pool)) {
        @shuffled_pool = _shuffle_array(@illusion_pool);
        $illusion_index = 0;
    }

    my $choice = $shuffled_pool[$illusion_index];
    $illusion_index++;

    $npc->SendIllusion($choice->{race}, $choice->{gender}, $choice->{texture}, $choice->{helm_texture});
}

sub _shuffle_array {
    my @array = @_;
    for (my $i = $#array; $i > 0; $i--) {
        my $j = int(rand($i+1));
        @array[$i, $j] = @array[$j, $i];
    }
    return @array;
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 1);
}