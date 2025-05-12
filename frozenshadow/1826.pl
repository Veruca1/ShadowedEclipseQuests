sub EVENT_SPAWN {
    quest::shout("How predictable... this is simply the inevitable.");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start combat-related timers
        quest::settimer("wand_shot", int(rand(6)) + 5);
        quest::settimer("first_spawn", 30);
        quest::settimer("second_spawn", 120);
        quest::settimer("third_spawn", 240);
        quest::settimer("fear_cast", 30);  # Cast Fear every 30 seconds
        quest::settimer("swarm_check", 1); # Check for swarm pets every second
    } elsif ($combat_state == 0) {
        # Stop all timers when combat ends
        quest::stoptimer("wand_shot");
        quest::stoptimer("first_spawn");
        quest::stoptimer("second_spawn");
        quest::stoptimer("third_spawn");
        quest::stoptimer("fear_cast");
        quest::stoptimer("swarm_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "wand_shot") {
        quest::shout("Professor Snape raises his wand, preparing to fire a shot. Duck to avoid it!");
        quest::settimer("execute_wand_shot", 5);
        quest::settimer("wand_shot", int(rand(6)) + 10);
    }

    if ($timer eq "execute_wand_shot") {
        my $chosen = $npc->GetHateRandom();
        if (defined $chosen && $chosen->IsClient()) {  # ✅ Check it's defined and a valid client
            if (defined $chosen->GetAppearance() && $chosen->GetAppearance() == 2) {
                quest::shout("Snape aims his wand but misses, the spell zipping past you.");
            } else {
                quest::shout("Snape casts a powerful spell that strikes you directly! You feel a surge of pain!");
                my $maxhp = $chosen->GetMaxHP();
                my $damage = $maxhp > 0 ? $maxhp * 0.5 : 1000;  # ✅ Fallback damage
                $chosen->Damage($npc, $damage, 10, false);
            }
        } else {
            quest::shout("Snape flicks his wand, but no target is there!");
        }
        quest::stoptimer("execute_wand_shot");
    }

    if ($timer eq "fear_cast") {
        quest::shout("Professor Snape's eyes glow with malice as he unleashes a wave of fear!");

        # Cast Fear (36896) on all clients
        my @targets = $entity_list->GetClientList();
        foreach my $target (@targets) {
            if (defined $target) {
                $npc->CastSpell(36896, $target->GetID());
            }
        }

        # And on all bots
        my @bots = $entity_list->GetBotList();
        foreach my $bot (@bots) {
            if (defined $bot) {
                $npc->CastSpell(36896, $bot->GetID());
            }
        }
    }

    if ($timer eq "swarm_check") {
        my @npcs = $entity_list->GetNPCList();
        foreach my $swarm (@npcs) {
            if (defined $swarm && $swarm->GetNPCTypeID() == 681) {
                $swarm->Depop();
            }
        }
    }

    # Spawning adds only when Snape is in combat
    if ($npc && $npc->IsEngaged()) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();

        if ($timer eq "first_spawn") {
            quest::spawn2(1827, 0, 0, $x + 10, $y + 10, $z, 0);
        }
        if ($timer eq "second_spawn") {
            quest::spawn2(1827, 0, 0, $x + 10, $y + 10, $z, 0);
            quest::spawn2(1827, 0, 0, $x - 10, $y - 10, $z, 0);
        }
        if ($timer eq "third_spawn") {
            quest::spawn2(1827, 0, 0, $x + 15, $y + 15, $z, 0);
            quest::spawn2(1827, 0, 0, $x - 15, $y - 15, $z, 0);
            quest::spawn2(1827, 0, 0, $x + 20, $y - 20, $z, 0);

            # Stop spawning after the third wave
            quest::stoptimer("first_spawn");
            quest::stoptimer("second_spawn");
            quest::stoptimer("third_spawn");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Professor Snape collapses, his face a mixture of relief and resignation.");
    quest::signalwith(1816, 1);
}