

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
    quest::spawn2(1878, 0, 0, -720.15,-2386.09, -989.08, 127.05);  # Spawn NPC 1878 at the specified location
}
