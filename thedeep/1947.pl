my $balancing = 0;
my $demogorgon_engaged = 0;
my $spawned_engage_timer = 20;
my $spawn_add_timer = 2;
my $spawned_npc_id = 0;
my $combat_engaged = 0;
my $in_final_burn = 0;

sub EVENT_SPAWN {
    quest::setnexthpevent(85);
    $npc->SetSpecialAbility(19, 1); # Melee immune
    quest::settimer("balance_check", 1);
}

sub EVENT_HP {
   if ($hpevent == 85) {
    $npc->SetSpecialAbility(19, 0); # Remove melee immunity

    my $clone_id = quest::spawn2(1460, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading());
    my $clone = $entity_list->GetMobByID($clone_id);
    if ($clone) {
        $clone->SetHP($npc->GetHP());
    }

    quest::setnexthpevent(50);
    $balancing = 1;
}
    elsif ($hpevent == 50 && $balancing) {
        $balancing = 0;
        quest::depopall(1460); # End balance
        quest::setnexthpevent(45);
    }
    elsif ($hpevent == 45) {
        $npc->SetHP($npc->GetMaxHP() * 0.45);
        $npc->WipeHateList();
        $npc->SetNPCFactionID(0);
        $npc->SetSpecialAbility(24, 1);
        $npc->SetSpecialAbility(25, 1);
        $npc->SetSpecialAbility(35, 1);
        $npc->SetInvul(1);
        quest::modifynpcstat("hp_regen", 0);
        apply_room_root_spell();
        quest::shout("Feel the grip of the void!");
        quest::shout("Ah, you mortals thought you could defeat me. I planned for a demogorgon to wield my power long ago!");
        $spawned_npc_id = quest::spawn2(1949, 0, 0, 1783.50, 45.45, -72.98, 258.25);
        $spawned_engage_timer = 20;
        quest::settimer("countdown_timer", 1);
    }
    elsif ($hpevent == 20) {
        $npc->SetSpecialAbility(20, 0);
        quest::setnexthpevent(10);
        $spawn_add_timer = 1;
        quest::settimer("spawn_adds", 5);
    }
    elsif ($hpevent == 10) {
        $spawn_add_timer = 2;
        quest::setnexthpevent(2);
    }
    elsif ($hpevent == 2) {
        $in_final_burn = 1;
        quest::stoptimer("spawn_adds");
        $npc->GMMove(1783.50, 45.45, -72.98, 258.25);
        quest::shout("You cannot run... face your end now!");

        $npc->WipeHateList();
        $npc->BuffFadeAll();
        $npc->SetSpecialAbility(20, 1); # Block spell damage during setup

        quest::settimer("start_final_burn_timer", 1); # Delayed actual burn countdown
    }
}

sub EVENT_SIGNAL {
    if ($signal == 45) {
        # UNLOCK THO
        $npc->WipeHateList();
        $npc->SetNPCFactionID(623); # Back to normal faction
        $npc->SetSpecialAbility(24, 0);
        $npc->SetSpecialAbility(25, 0);
        $npc->SetSpecialAbility(35, 0);
        $npc->SetInvul(0);
        quest::shout("You have destroyed my vessel... but I am not yet finished!");
        # Become immune to spell damage until 20%
        $npc->SetSpecialAbility(20, 1); # Spell immunity
        quest::setnexthpevent(20);
    }
    elsif ($signal == 999) {
    $combat_engaged = 1;
    quest::stoptimer("countdown_timer");
    #quest::shout("Combat engaged! Countdown stopped.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "balance_check" && $balancing) {
        my $tho = $npc;
        my $host = $entity_list->GetNPCByNPCTypeID(1460);
        return unless $host;

        my $tho_hp = $tho->GetHP() / $tho->GetMaxHP() * 100;
        my $host_hp = $host->GetHP() / $host->GetMaxHP() * 100;

        if (abs($tho_hp - $host_hp) > 5) {
            quest::shout("The balance has failed. The entities retreat!");
            quest::depopall(1947);
            quest::depopall(1460);
            quest::depopall(1948);
            quest::stoptimer("balance_check");
        }
    }
    elsif ($timer eq "countdown_timer") {
        return if $combat_engaged;
        quest::shout("$spawned_engage_timer...");
        $spawned_engage_timer--;

        if ($spawned_engage_timer <= 0) {
            quest::stoptimer("countdown_timer");

            my $npc_obj = $entity_list->GetMobByID($spawned_npc_id);
            if ($npc_obj) {
                $npc_obj->Depop();
                $spawned_npc_id = 0;
            }

            my @clients = $entity_list->GetClientList();
            foreach my $c (@clients) {
                $c->Kill(); # Optional room wipe
            }
        }
    }
    elsif ($timer eq "spawn_adds") {
        for (1..$spawn_add_timer) {
            quest::spawn2(1948, 0, 0, $x + int(rand(15)) - 7, $y + int(rand(15)) - 7, $z, 0);
        }
    }
    elsif ($timer eq "start_final_burn_timer") {
        quest::stoptimer("start_final_burn_timer");

        $spawned_engage_timer = 145; # 2mins 25 secs
        quest::settimer("final_burn_timer", 1);
    }
    elsif ($timer eq "final_burn_timer") {
        if (!$combat_engaged && $npc->IsEngaged()) {
            $combat_engaged = 1;
            quest::stoptimer("final_burn_timer");
            $npc->SetSpecialAbility(20, 0); # Allow spell damage again
            quest::shout("You dare to follow me? Then come, face oblivion! You have 2 minutes!");
            return;
        }

        return if $combat_engaged;

        quest::shout("$spawned_engage_timer...");
        $spawned_engage_timer--;

        if ($spawned_engage_timer <= 0) {
            quest::shout("You took too long... I will return!");
            quest::depopall(1947); # THO
            quest::depopall(1460); # Clone
            quest::depopall(1948); # Adds
            quest::stoptimer("final_burn_timer");
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Start a 3-minute timer to depop if combat doesn't resume
        quest::settimer("depop_check", 180);
    } else {
        # Cancel timer if combat resumes
        quest::stoptimer("depop_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        quest::stoptimer("depop_check");
        if (!$npc->IsEngaged()) {
            quest::shout("The Overfiend vanishes into the void, unchallenged.");
            quest::depop();
        }
    }
}

sub EVENT_AGGRO {
    $combat_engaged = 1;
}

sub EVENT_COMBAT {
    $combat_engaged = ($combat_state == 1) ? 1 : 0;

    if ($combat_state == 1 && $in_final_burn && $spawned_engage_timer > 0) {
        # UNLOCK THO only during final phase
        $npc->WipeHateList();
        $npc->SetNPCFactionID(623); # Back to normal faction
        $npc->SetSpecialAbility(24, 0);
        $npc->SetSpecialAbility(25, 0);
        $npc->SetSpecialAbility(35, 0);
        $npc->SetInvul(0);
        quest::shout("You dare to follow me? Then come, face oblivion!");
        quest::stoptimer("final_burn_timer");
        $in_final_burn = 0; # Reset the flag
    }
}

sub apply_room_root_spell {
    my $cx = $npc->GetX();
    my $cy = $npc->GetY();
    my $cz = $npc->GetZ();

    quest::debug("apply_room_root_spell: Target location = ($cx, $cy, $cz)");

    my @clients = $entity_list->GetClientList();
    quest::debug("apply_room_root_spell: Found " . scalar(@clients) . " clients.");

    foreach my $client (@clients) {
        my $dist = $client->CalculateDistance($cx, $cy, $cz);
        quest::debug("Checking client " . $client->GetCleanName() . " (ID: " . $client->GetID() . ") at distance $dist");
        if ($dist <= 100) {
            quest::debug(" -> In range. NPC casting Deathgrip Roots on " . $client->GetCleanName());
            $npc->CastSpell(17512, $client->GetID()); # NPC casts root spell on client
        } else {
            quest::debug(" -> Out of range. No action on " . $client->GetCleanName());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::depopall(1948); # Adds
}
