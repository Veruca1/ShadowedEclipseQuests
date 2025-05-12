my %spawned = (1864 => 0, 1867 => 0, 1866 => 0, 1865 => 0, 1872 => 0);  # Track which NPCs have spawned
my $harry_npc_id = 0;  # Track the ID of Harry Potter (NPC 1872)

sub EVENT_SPAWN {
    quest::shout("Fools! You dare challenge the Dark Lord? You will know pain before the end!");
    quest::setnexthpevent(80);
}

sub EVENT_HP {
    my %hp_to_next = (
        80 => 60,
        60 => 40,
        40 => 20,
        20 => 1,
    );

    if ($hpevent == 80 && !$spawned{1864}) {
        quest::spawn2(1864, 0, 0, $x, $y, $z, $h);
        quest::shout("You cannot stop me! I have conquered death itself!");
        $npc->SetInvul(1);
        $spawned{1864} = 1;
    }
    elsif ($hpevent == 60 && !$spawned{1867}) {
        quest::spawn2(1867, 0, 0, $x, $y, $z, $h);
        quest::shout("Your feeble spells mean nothing to me!");
        $npc->SetInvul(1);
        $spawned{1867} = 1;
    }
    elsif ($hpevent == 40 && !$spawned{1866}) {
        quest::spawn2(1866, 0, 0, $x, $y, $z, $h);
        quest::shout("I have slain wizards far greater than you!");
        $npc->SetInvul(1);
        $spawned{1866} = 1;
    }
    elsif ($hpevent == 20 && !$spawned{1865}) {
        quest::spawn2(1865, 0, 0, $x, $y, $z, $h);
        quest::shout("You will suffer before you die!");
        $npc->SetInvul(1);
        $spawned{1865} = 1;
    }
    elsif ($hpevent == 1 && !$spawned{1872}) {
        my $harry = quest::spawn2(1872, 0, 0, $x, $y, $z, $h);  # Spawns Harry Potter
        $harry_npc_id = $harry;  # Save the NPC ID of Harry Potter
        $npc->SetInvul(1);  # Makes Voldemort invulnerable
        $spawned{1872} = 1;  # Tracks that Harry has spawned

        quest::settimer("shout_you", 5);
        quest::settimer("shout_avada", 7);
    }

    # Set the next HP event threshold
    if (exists $hp_to_next{$hpevent}) {
        quest::setnexthpevent($hp_to_next{$hpevent});
    }
}

sub EVENT_TIMER {
    if ($timer eq "shout_you") {
        quest::shout("You!");
        quest::stoptimer("shout_you");
    }
    if ($timer eq "shout_avada") {
        quest::shout("Avada Kedavra!");
        if ($harry_npc_id) {
            quest::depop($harry_npc_id);  # Depop (kill) Harry Potter
        }
        quest::stoptimer("shout_avada");

        # Now Voldemort dies after shouting
        $npc->Kill();  # This will cause Voldemort to die
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        $npc->SetInvul(0);  # Makes Voldemort vulnerable again
    }
}

sub EVENT_DEATH_COMPLETE {
    # Reset tracking variables so the event can function correctly on respawn
    %spawned = (1864 => 0, 1867 => 0, 1866 => 0, 1865 => 0, 1872 => 0);
    $harry_npc_id = 0;

    quest::depop();  # Depop Voldemort, effectively killing him
}
