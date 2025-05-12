

my %spawned = ();  # Track spawned sentries

sub EVENT_SPAWN {
    quest::setnexthpevent(80);
}

sub EVENT_HP {
    my %hp_to_next = (
        80 => 60,
        60 => 40,
        40 => 15,
        15 => 1,
    );

    if ($npc->IsEngaged()) {  # Ensure the boss is in combat
        if ($hpevent == 80 && !$spawned{80}) {
            SpawnAdds();
            $spawned{80} = 1;
        }
        elsif ($hpevent == 60 && !$spawned{60}) {
            SpawnAdds();
            $spawned{60} = 1;
        }
        elsif ($hpevent == 40 && !$spawned{40}) {
            SpawnAdds();
            $spawned{40} = 1;
        }
        elsif ($hpevent == 15 && !$spawned{15}) {
            SpawnAdds();
            $spawned{15} = 1;
        }

        quest::setnexthpevent($hp_to_next{$hpevent}) if exists $hp_to_next{$hpevent};
    }
}

sub SpawnAdds {
    quest::spawn2(128063, 0, 0, $x, $y, $z, $h);
}

sub EVENT_DEATH_COMPLETE {
	quest::spawn2(128041, 0, 0, -1073.49, -1961.97, -988.87, 383.50);
	quest::spawn2(128042, 0, 0, -1905.96, -1968.76, -991.27, 257.00);
	quest::spawn2(128043, 0, 0, -1896.34, -2799.74, -991.63, 129.75);
	quest::spawn2(128044, 0, 0, -1070.40, -2767.78, -992.50, 7.00);
}