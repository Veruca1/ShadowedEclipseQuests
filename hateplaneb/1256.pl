my $minions_spawned = 0;
my $boss = $npc;

sub EVENT_SPAWN {
    $minions_spawned = 0;
    quest::setnexthpevent(75);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("The Welcome Wagon has arrived! Hahahaha, you were very foolish to have come this far!");
        quest::settimer("spell_cast", 10);

        # Defensive: ensure HP event always resets at combat start
        if ($minions_spawned == 0) {
            quest::setnexthpevent(75);
        }

    } else {
        quest::stoptimer("spell_cast");
    }
}

sub EVENT_HP {

    if ($hpevent == 75 && $minions_spawned < 1) {
        Summon_Minions(1);
        $minions_spawned = 1;
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50 && $minions_spawned < 2) {
        Summon_Minions(2);
        $minions_spawned = 2;
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25 && $minions_spawned < 3) {
        Summon_Minions(3);
        $minions_spawned = 3;
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        quest::castspell(931, $npc->GetID());
    }
}

sub Summon_Minions {
    my ($count) = @_;
    quest::shout("Minions, assist me in battle!");

    my $boss = $npc;
    return unless $boss;

    my $top_target = $boss->GetHateTop();
    unless ($top_target) {
        quest::shout("No top hate target found!");
        return;
    }

    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        my $minion_id = quest::spawn2(1257, 0, 0, $x, $y, $z, $npc->GetHeading());

        my $minion = $entity_list->GetNPCByID($minion_id);
        next unless $minion;

        $minion->AddToHateList($top_target, 1);  # Works for any entity on the hate list
    }
}



sub EVENT_DEATH_COMPLETE {
    quest::shout("Welcome to the Plane of Xyron's Hate, for all of you!");
    quest::stoptimer("spell_cast");
}
