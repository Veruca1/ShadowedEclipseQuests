my $wrath_triggered = 0;

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("You trespass in the bloom of decay... Reishicyben awakens!");

        quest::settimer("spore_surge", 1);
        quest::settimer("mushroom_mutter", 20);

        quest::setnexthpevent(80);
    } else {
        quest::stoptimer("spore_surge");
        quest::stoptimer("mushroom_mutter");

        if (!$npc->IsEngaged()) {
            $npc->SetHP($npc->GetMaxHP());
            $wrath_triggered = 0;
            quest::setnexthpevent(80);
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 80) {
        spawn_minions();
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        # Check if NPC has debuff spell 40745 active
        if ($npc->FindBuff(40745)) {
            plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the cavern, arise and assist me!");

        my $top_hate_target = $npc->GetHateTop();
        return unless $top_hate_target;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob;
            next if $mob->GetID() == $npc->GetID();

            my $distance = $npc->CalculateDistance($mob);
            if (defined $distance && $distance <= 300) {
                $mob->AddToHateList($top_hate_target, 1);
            }
        }

        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        spawn_minions();
        quest::setnexthpevent(10);
    } elsif ($hpevent == 10) {
        spawn_minions();
    }
}

sub spawn_minions {
    quest::shout("Sporelings burst forth from the rotting loam!");
    for (1..2) {
        quest::spawn2(1921, 0, 0, $x + int(rand(40)) - 20, $y + int(rand(40)) - 20, $z, $h);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spore_surge") {
        $npc->CastSpell(40721, $npc->GetID());

        foreach my $client ($entity_list->GetClientList()) {
            $client->Message(14, $npc->GetCleanName() . " glows with a sickly bioluminescence as spores surge!");
        }

        my $heal_amt = int(rand(40001)) + 20000;
        $npc->HealDamage(-$heal_amt);

        quest::shout("The fungal mass writhes and regrows!");
        quest::settimer("spore_surge", 30);  # Changed from 40 to 30
    }

    if ($timer eq "mushroom_mutter") {
        my @shouts = (
            "The caverns breathe with rot!",
            "Inhale... and become one with the spores!",
            "Decay is eternal... embrace the bloom!"
        );
        quest::shout($shouts[int(rand(@shouts))]);
        quest::settimer("mushroom_mutter", 45);
    }
}

sub EVENT_DAMAGE_TAKEN {
    my $attacker = $entity_list->GetMobByID($clientid);
    if ($attacker && $attacker->IsClient()) {
        $damage = int($damage * 0.6);  # Apply 40% damage reduction to all players
    }

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;
        if (quest::ChooseRandom(1..100) <= 70) {
            $npc->Shout("The Sporeburst of Reishicyben consumes all!");

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
    quest::shout("The spores drift... Reishicyben shall bloom again.");
}