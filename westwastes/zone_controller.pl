sub EVENT_SIGNAL {
    if ($signal == 1) {
        #quest::shout("Zone Controller received SIGNAL 1! Processing...");

        my $remaining_dragons = quest::get_data("remaining_dragons");

        if (!$remaining_dragons || $remaining_dragons <= 0) {
            $remaining_dragons = plugin::RandomRange(5, 9);
            quest::set_data("remaining_dragons", $remaining_dragons);
            #quest::shout("New wave size set: $remaining_dragons dragons!");
        } else {
            #quest::shout("Continuing wave, $remaining_dragons dragons left.");
        }

        # Define fixed spawn coordinates
        my $spawn_x = 576.76;
        my $spawn_y = 154.01;
        my $spawn_z = -277.41;
        my $spawn_h = 0.0;

        if ($remaining_dragons > 1) {
            # Regular dragon selection
            my @dragons = (120061, 120065, 120041, 120048, 120130, 120046, 120122, 120015,
                           120004, 120100, 120014, 120019, 120018, 120024, 120120, 120007,
                           120057, 120043, 120053, 120017, 120056, 120134, 120055, 120016,
                           120106, 120073, 120126, 120087, 120114, 120107, 120006, 120123,
                           120117, 120135, 120042, 120008, 120025);

            my $dragon_id = $dragons[int(rand(@dragons))];
            #quest::shout("Spawning regular dragon ID: $dragon_id");

            quest::spawn2($dragon_id, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
        } elsif ($remaining_dragons == 1) {
            # Last dragon from boss list
            my @boss_dragons = (120086, 120084, 120005);
            my $boss_id = $boss_dragons[int(rand(@boss_dragons))];

            #quest::shout("Final spawn! Boss dragon ID: $boss_id");

            quest::spawn2($boss_id, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
        }

        # Decrease count and store it
        $remaining_dragons--;
        quest::set_data("remaining_dragons", $remaining_dragons);
        #quest::shout("Remaining dragons after spawn: $remaining_dragons");
    }
}
