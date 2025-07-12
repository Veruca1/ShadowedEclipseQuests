sub EVENT_SPAWN {
    return unless $npc;

    quest::setnexthpevent(70);  # Start HP event chain
    quest::shout("I am Lcea Katta, Warden of this city. Even under their shadows, my blade remembers the light!");
}

sub EVENT_HP {
    return unless $npc;

    my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
    my $radius = 60;
    my $dmg = 50000;

    if ($hpevent == 70) {
        quest::shout("Their whispers grow louder — but I am the voice that answers! The Coven will not bend my knee!");
        do_aoe_damage($x, $y, $z, $radius, $dmg);
        call_for_help();
        quest::setnexthpevent(40);

    } elsif ($hpevent == 40) {
        quest::shout("Umbral Chorus — your songs falter here! Katta stands while I stand!");
        do_aoe_damage($x, $y, $z, $radius, $dmg);
        quest::setnexthpevent(20);

    } elsif ($hpevent == 20) {
        quest::shout("Strike if you must — my final cut will be my own, not theirs!");
        do_aoe_damage($x, $y, $z, $radius, $dmg);
        call_for_help();
    }
}

# ✅ Halve all spell damage
sub EVENT_DAMAGE {
    my ($damage, $spell_id, $attacker) = @_;
    return int($damage * 0.5);
}

# ✅ Wrath of Luclin chance at 10%, 5%, 1%
sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    our $wrath_triggered ||= {};

    my $hp_ratio = $npc->GetHP() / $npc->GetMaxHP();

    my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
    my $radius = 50;
    my $dmg = 60000;

    if (!$wrath_triggered->{10} && $hp_ratio <= 0.10) {
        $wrath_triggered->{10} = 1;
        do_wrath($x, $y, $z, $radius, $dmg, "The Wrath of Luclin cracks the veil!");

    } elsif (!$wrath_triggered->{5} && $hp_ratio <= 0.05) {
        $wrath_triggered->{5} = 1;
        do_wrath($x, $y, $z, $radius, $dmg, "The Wrath of Luclin tears reality!");

    } elsif (!$wrath_triggered->{1} && $hp_ratio <= 0.01) {
        $wrath_triggered->{1} = 1;
        do_wrath($x, $y, $z, $radius, $dmg, "The Wrath of Luclin consumes all!");
    }

    return $_[0]; # pass damage through
}

sub do_wrath {
    my ($x, $y, $z, $radius, $dmg, $msg) = @_;

    if (quest::ChooseRandom(1..100) <= 15) {
        quest::shout($msg);

        # Clients
        foreach my $c ($entity_list->GetClientList()) {
            if ($c->CalculateDistance($x, $y, $z) <= $radius) {
                $c->Damage($npc, $dmg, 0, 1, false);
            }
            my $pet = $c->GetPet();
            if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                $pet->Damage($npc, $dmg, 0, 1, false);
            }
        }

        # Bots
        foreach my $b ($entity_list->GetBotList()) {
            if ($b->CalculateDistance($x, $y, $z) <= $radius) {
                $b->Damage($npc, $dmg, 0, 1, false);
            }
            my $pet = $b->GetPet();
            if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                $pet->Damage($npc, $dmg, 0, 1, false);
            }
        }
    }
}

sub do_aoe_damage {
    my ($x, $y, $z, $radius, $dmg) = @_;

    # Clients and pets
    foreach my $c ($entity_list->GetClientList()) {
        if ($c->CalculateDistance($x, $y, $z) <= $radius) {
            $c->Damage($npc, $dmg, 0, 1, false);
        }
        my $pet = $c->GetPet();
        if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
            $pet->Damage($npc, $dmg, 0, 1, false);
        }
    }

    # Bots and pets
    foreach my $b ($entity_list->GetBotList()) {
        if ($b->CalculateDistance($x, $y, $z) <= $radius) {
            $b->Damage($npc, $dmg, 0, 1, false);
        }
        my $pet = $b->GetPet();
        if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
            $pet->Damage($npc, $dmg, 0, 1, false);
        }
    }
}

sub call_for_help {
    my $top = $npc->GetHateTop();
    return unless $top;

    quest::shout("Surrounding minions of the castle, arise and assist me!");
    foreach my $mob ($entity_list->GetNPCList()) {
        next unless $mob && $mob->GetID() != $npc->GetID();
        my $dist = $npc->CalculateDistance($mob);
        $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
    }
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;

    if (quest::ChooseRandom(1..100) <= 25) {
        my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(159691, 0, 0, $x, $y, $z, $h);
    }
}