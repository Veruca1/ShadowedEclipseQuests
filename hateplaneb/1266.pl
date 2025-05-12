my $phase = 1;
my $copy_id = 0;

sub EVENT_SPAWN {
    quest::settimer("phase_change", 5 * 60); # Check for phase change every 5 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Combat started
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 3000, "You dare challenge time itself? Witness the true power of Doom, Gloom, Malice, and Envy!");
        }

        # Spawn the four manifestations at the specified locations
        quest::spawn2(1272, 0, 0, -389.24, -1344.48, 24.50, 470); # Doom
        quest::spawn2(1271, 0, 0, -473.81, -1345.69, 24.50, 63.75); # Gloom
        quest::spawn2(1270, 0, 0, -472.18, -1246.65, 24.50, 198.50); # Malice
        quest::spawn2(1269, 0, 0, -388.99, -1246.74, 24.50, 311.25); # Envy

        quest::settimer("manifest_cast", 12);
        quest::setnexthpevent(75);
    }
    elsif ($combat_state == 0) { # Combat ended
        quest::stoptimer("phase_change");
        quest::stoptimer("environmental_hazard");
        quest::stoptimer("manifest_cast");
        quest::stoptimer("phase3_abilities");
    }
}

sub EVENT_TIMER {
    if ($npc->IsEngaged()) {
        if ($timer eq "phase_change") {
            if ($npc->GetHP() < 74 && $phase == 1) {
                $phase = 2;
                quest::settimer("environmental_hazard", 20); # Hazard more frequent
            }
            elsif ($npc->GetHP() < 33 && $phase == 2) {
                $phase = 3;
                quest::settimer("environmental_hazard", 10); # Hazard even more frequent
                quest::settimer("phase3_abilities", 20); # Start Phase 3 abilities
            }
        }
        elsif ($timer eq "environmental_hazard") {
            my $hazard_spell = quest::ChooseRandom(36834, 4162, 36835);
            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                if ($hazard_spell == 36834) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The ground erupts in flames!");
                }
                elsif ($hazard_spell == 4162) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A toxic cloud spreads across the battlefield!");
                }
                elsif ($hazard_spell == 36835) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The ground beneath you starts to freeze!");
                }
            }
            my @target_list = $entity_list->GetClientList();
            foreach my $target (@target_list) {
                quest::castspell($hazard_spell, $target->GetID());
            }
        }
        elsif ($timer eq "manifest_cast") {
            quest::signalwith(1272, 1); # Signal Doom
            quest::signalwith(1271, 1); # Signal Gloom
            quest::signalwith(1270, 1); # Signal Malice
            quest::signalwith(1269, 1); # Signal Envy
        }
        elsif ($timer eq "phase3_abilities") {
            if (!$copy_id) {
                # Spawn the copy NPC
                $copy_id = quest::spawn2(1273, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

                # Adjust the copy's HP to match the original NPC's current HP percentage
                my $copy_mob = $entity_list->GetMobID($copy_id);
                if ($copy_mob) {
                    my $copy_npc = $copy_mob->CastToNPC();
                    if ($copy_npc) {
                        my $current_hp = $npc->GetHP();
                        my $current_max_hp = $npc->GetMaxHP();
                        my $hp_percent = ($current_hp / $current_max_hp) * 100;
                        my $copy_max_hp = $copy_npc->GetMaxHP();
                        my $copy_hp = int(($hp_percent / 100) * $copy_max_hp);
                        $copy_npc->SetHP($copy_hp);
                    }
                }
            }

            # Cast Time Warp and Chronoblast
            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                if (rand() < 0.3) { # 30% chance to cast Chronoblast on a random player
                    quest::castspell(36842, $client->GetID()); # Chronoblast
                }
            }
            quest::castspell(36845, $npc->GetID()); # Time Warp
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::shout("I will draw upon the power of those manifestations!");

        quest::depopall(1272); # Doom
        quest::depopall(1271); # Gloom
        quest::depopall(1270); # Malice
        quest::depopall(1269); # Envy

        $npc->CastSpell(36840, $npc->GetID()); # Cast Power of Manifestation

        quest::settimer("environmental_hazard", 30);
        my $CurSize = $npc->GetSize();
        $npc->ChangeSize($CurSize - 2);
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50) {
        my $CurSize = $npc->GetSize();
        $npc->ChangeSize($CurSize - 2);
        quest::settimer("phase3_abilities", 20);
        quest::setnexthpevent(30);
    }
    elsif ($hpevent == 30) {
        my $CurSize = $npc->GetSize();
        $npc->ChangeSize($CurSize - 3);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Impossible… The Abyss… will not forget… this insult!");
    quest::spawn2(1268, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

    # Depop all instances of NPC 1273
    quest::depopall(1273);

    # Depop all instances of NPC 186198
    quest::depopall(186198);
}
