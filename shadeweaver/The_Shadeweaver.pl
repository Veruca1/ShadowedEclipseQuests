my $wrath_triggered = 0;

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("You step into the woven shadows... now unravel them if you dare!");

        quest::settimer("weaver_wiggle", 1);
        quest::settimer("shade_shout", 20);
        quest::settimer("silence_sk", 30);

        # Start HP event chain
        quest::setnexthpevent(80);
    } else {
        quest::stoptimer("weaver_wiggle");
        quest::stoptimer("shade_shout");
        quest::stoptimer("silence_sk");

        if (!$npc->IsEngaged()) {
            $npc->SetHP($npc->GetMaxHP());
            $wrath_triggered = 0;  # Reset wrath trigger for next fight
            quest::setnexthpevent(80);
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 80) {
        spawn_minions();
        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        spawn_minions();
        quest::setnexthpevent(10);
    } elsif ($hpevent == 10) {
        spawn_minions();
        # No further HP events
    }
}

sub spawn_minions {
    quest::shout("Threads tear open—witness the lesser weave!");
    my @minions = (1461, 1461, 1461);  # Replace with actual NPC IDs
    for (1..2) {
        my $minion_id = $minions[int(rand(@minions))];
        quest::spawn2($minion_id, 0, 0, $x + int(rand(40)) - 20, $y + int(rand(40)) - 20, $z, $h);
    }
}

sub EVENT_TIMER {
    if ($timer eq "weaver_wiggle") {
        $npc->CastSpell(40721, $npc->GetID());

        foreach my $client ($entity_list->GetClientList()) {
            $client->Message(14, $npc->GetCleanName() . " is surrounded by a vortex of unraveling energy!");
        }

        my $heal_amt = int(rand(40001)) + 20000;
        $npc->HealDamage(-$heal_amt);

        quest::shout("The Shadeweaver pulses with unraveling energy!");
        quest::settimer("weaver_wiggle", 40);
    }

    if ($timer eq "shade_shout") {
        my @shouts = (
            "The strands are breaking!",
            "Your minds cannot hold the weave!",
            "From shadow, the next cycle awakens!"
        );
        quest::shout($shouts[int(rand(@shouts))]);
        quest::settimer("shade_shout", 45);
    }

    if ($timer eq "silence_sk") {
        my @hate_list = $npc->GetHateList();
        foreach my $hate_entry (@hate_list) {
            my $ent = $hate_entry->GetEnt();
            if ($ent && $ent->IsClient()) {
                my $pc = $ent->CastToClient();
                if ($pc->GetClass() == 5) {  # Shadowknight
                    $npc->CastSpell(12431, $pc->GetID()); # Silence
                    $npc->Shout("Your dark magic falters, Shadowknight!");
                }
            }
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    my $attacker = $entity_list->GetMobByID($clientid);
    if ($attacker && $attacker->IsClient()) {
        my $pc = $attacker->CastToClient();
        if ($pc->GetClass() == 5) {  # Shadowknight
            $damage = int($damage * 0.5);
        }
    }

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;
        if (quest::ChooseRandom(1..100) <= 70) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my $npc_x = $npc->GetX();
            my $npc_y = $npc->GetY();
            my $npc_z = $npc->GetZ();
            my $radius = 50;
            my $wrath_dmg = 35000;

            foreach my $entity ($entity_list->GetClientList()) {
                if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $entity->Damage($npc, $wrath_dmg, 0, 1, false);
                }

                my $pet = $entity->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, false);
                }
            }

            foreach my $bot ($entity_list->GetBotList()) {
                if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $bot->Damage($npc, $wrath_dmg, 0, 1, false);
                }

                my $pet = $bot->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The weave frays... and from its tangle, *She* shall emerge...");
}