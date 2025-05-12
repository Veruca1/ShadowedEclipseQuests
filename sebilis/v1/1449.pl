sub EVENT_SPAWN {
    # List of spells to cast as buffs
    my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each spell as a buff on spawn
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer for recasting the buffs
    quest::settimer("recast_buffs", 90);

    quest::shout("You fools have no idea what you are meddling with!");
    quest::setnexthpevent(90);
}

sub EVENT_HP {
    if ($hpevent == 90 || $hpevent == 70 || $hpevent == 50 || $hpevent == 30) {
        quest::emote("shouts in anger as his magic dissipates");
        ApplyDirectDamage(4000);
        my $size_reduction = ($hpevent == 30) ? 2 : 1;
        $npc->ChangeSize($npc->GetSize() - $size_reduction);
        quest::setnexthpevent($hpevent - 20) if $hpevent > 30;
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged
        quest::settimer("bonesplinter", 25);  # Every 25 seconds
        quest::settimer("spawn_minion", 90);  # Spawns minion every 90 seconds
    } else { # Combat ends
        quest::setnexthpevent(90);
        $npc->SetHP($npc->GetMaxHP());
        quest::stoptimer("bonesplinter");
        quest::stoptimer("spawn_minion");
        $npc->ChangeSize(7);
    }
}

sub EVENT_TIMER {
    if ($timer eq "bonesplinter") {
        ApplyDoTDamage(2000, 4);  # 2000 initial + 2000 per tick for 4 ticks
    } elsif ($timer eq "spawn_minion") {
        quest::spawn2(1452, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    } elsif ($timer eq "recast_buffs") {
        # Recast each spell as a buff
        my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    } elsif ($timer =~ /^dot_tick_(\d+)$/) {
        foreach my $entity ($npc->GetHateList()) {
            next unless defined $entity;
            my $target = $entity->GetEnt();
            next unless $target && ($target->IsClient() || $target->IsBot());

            # Apply tick damage to player/bot and their pet
            $target->Damage($npc, 2000, 0, 1, false);
            $npc->DoKnockback($target, 1000, 1000);  # Apply knockback to player/bot

            my $pet = $target->GetPet();
            if ($pet) {
                $pet->Damage($npc, 2000, 0, 1, false);
                $npc->DoKnockback($pet, 1000, 1000);  # Apply knockback to pet
            }
        }
        quest::stoptimer($timer);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("bonesplinter");
    quest::stoptimer("spawn_minion");
    quest::stoptimer("recast_buffs");
}

sub ApplyDirectDamage {
    my ($damage) = @_;
    foreach my $entity ($npc->GetHateList()) {
        next unless defined $entity;
        my $target = $entity->GetEnt();
        next unless $target && ($target->IsClient() || $target->IsBot());

        # Apply damage to the player/bot
        $target->Damage($npc, $damage, 0, 1, false);
        $npc->DoKnockback($target, 1000, 1000);  # Apply knockback to player/bot

        # Apply damage to their pet if they have one
        my $pet = $target->GetPet();
        if ($pet) {
            $pet->Damage($npc, $damage, 0, 1, false);
            $npc->DoKnockback($pet, 1000, 1000);  # Apply knockback to pet
        }
    }
}

sub ApplyDoTDamage {
    my ($initial_damage, $ticks) = @_;
    foreach my $entity ($npc->GetHateList()) {
        next unless defined $entity;
        my $target = $entity->GetEnt();
        next unless $target && ($target->IsClient() || $target->IsBot());

        # Initial hit
        $target->Damage($npc, $initial_damage, 0, 1, false);
        $npc->DoKnockback($target, 1000, 1000);  # Apply knockback to player/bot

        # Apply periodic damage to player/bot and their pet
        for (my $i = 1; $i <= $ticks; $i++) {
            quest::settimer("dot_tick_$i", 6 * $i);
        }

        my $pet = $target->GetPet();
        if ($pet) {
            $pet->Damage($npc, $initial_damage, 0, 1, false);
            $npc->DoKnockback($pet, 1000, 1000);  # Apply knockback to pet
        }
    }
}
