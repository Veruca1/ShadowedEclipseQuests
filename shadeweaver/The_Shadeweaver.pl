my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Boss Stats (from Sleeper's default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 15000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 8000);
    $npc->ModifyNPCStat("max_hit", 9700);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 30);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes & Resistances ===
    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    # === Vision & AI Traits ===
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);

    # === Special Abilities (Immunities) ===
    # 3: immune to fleeing | 5: immune to mez | 7: immune to charm
    # 8: immune to fear | 9: immune to root
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Adaptive Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Finalize HP ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    return unless defined $npc;   # Safety check

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

        # Check $npc is defined and engaged method exists
        if (defined $npc && !$npc->IsEngaged()) {
            $npc->SetHP($npc->GetMaxHP());
            $wrath_triggered = 0;  # Reset wrath trigger for next fight
            quest::setnexthpevent(80);
        }
    }
}

sub EVENT_HP {
    return unless defined $npc;   # Safety check

    if ($hpevent == 80) {
        spawn_minions();
        quest::setnexthpevent(40);
    } 
    elsif ($hpevent == 40) {
        spawn_minions();
        quest::setnexthpevent(10);
    } 
    elsif ($hpevent == 10) {
        spawn_minions();
        # No further HP events
    }
}

sub spawn_minions {
    return unless defined $npc;

    quest::shout("Threads tear open—witness the lesser weave!");
    my @minions = (1983, 1983, 1983);  # Replace with actual NPC IDs

    # Defensive coords: fallback to 0 if undefined
    my $x = defined $npc ? $npc->GetX() : 0;
    my $y = defined $npc ? $npc->GetY() : 0;
    my $z = defined $npc ? $npc->GetZ() : 0;
    my $h = defined $npc ? $npc->GetHeading() : 0;

    for (1..2) {
        my $minion_id = $minions[int(rand(@minions))];
        quest::spawn2($minion_id, 0, 0, $x + int(rand(40)) - 20, $y + int(rand(40)) - 20, $z, $h);
    }
}

sub EVENT_TIMER {
    return unless defined $npc;

    if ($timer eq "weaver_wiggle") {
        $npc->CastSpell(40721, $npc->GetID());

        foreach my $client ($entity_list->GetClientList()) {
            next unless defined $client;
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
            next unless defined $hate_entry;
            my $ent = $hate_entry->GetEnt();
            if ($ent && $ent->IsClient()) {
                my $pc = $ent->CastToClient();
                if ($pc && $pc->GetClass() == 5) {  # Shadowknight
                    $npc->CastSpell(12431, $pc->GetID()); # Silence
                    $npc->Shout("Your dark magic falters, Shadowknight!");
                }
            }
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless defined $npc;
    my $damage = $_[1]; # ensure $damage is properly scoped or passed in, if available

    my $attacker = $entity_list->GetMobByID($clientid);
    if ($attacker && $attacker->IsClient()) {
        my $pc = $attacker->CastToClient();
        if ($pc && $pc->GetClass() == 5) {  # Shadowknight
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
                next unless defined $entity;
                if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $entity->Damage($npc, $wrath_dmg, 0, 1, 0);
                }

                my $pet = $entity->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, 0);
                }
            }

            foreach my $bot ($entity_list->GetBotList()) {
                next unless defined $bot;
                if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $bot->Damage($npc, $wrath_dmg, 0, 1, 0);
                }

                my $pet = $bot->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, 0);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The weave frays... and from its tangle, *She* shall emerge...");
}