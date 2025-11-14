# ===========================================================
# The_Acolyte_of_Affliction.pl — PoTorment Mini Boss
# Shadowed Eclipse Progression: Key Flag Gating + Add Spawns
# ===========================================================

sub EVENT_SPAWN {
    $npc->SetInvul(1);
    quest::settimer("flag_check", 5);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        spawn_adds();                    # Initial spawn on aggro
        quest::settimer("adds", 50);     # Continue spawning every 50 seconds
        quest::stoptimer("reset");       # Cancel reset if active
    } else {
        quest::settimer("reset", 300);   # 5-minute cleanup if fight ends
        quest::stoptimer("adds");
    }
}

sub EVENT_TIMER {
    if ($timer eq "flag_check") {
        quest::stoptimer("flag_check");

        my @client_list = $entity_list->GetClientList();
        foreach my $ent (@client_list) {
            my $cid = $ent->CharacterID();
            my $flag = quest::get_data("potor_saryrn_key_complete_$cid");
            if (defined $flag && $flag == 1) {
                $npc->SetInvul(0);
                last;
            }
        }
    }

    if ($timer eq "adds") {
        spawn_adds();
    }

    if ($timer eq "reset") {
        quest::depopall(207068); # despawn adds
        quest::stoptimer("reset");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::depopall(207068);
}

sub spawn_adds {
    my $num = int(rand(2)) + 1;
    for (my $i = 0; $i < $num; $i++) {
        quest::spawn2(
            207068, 0, 0,
            $x + int(rand(11)) - 5,
            $y + int(rand(11)) - 5,
            $z + 5,
            $h
        );
    }
    $entity_list->MessageClose($npc, 0, 100, 263, "A new chilling presence emerges from the shadows...");
}