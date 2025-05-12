my $minions_spawned = 0;

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 15);       # Life drain now triggers every 15 seconds
        quest::settimer("spell_cast", 30);      # Spell cast timer
        quest::settimer("minion_check", 1);     # Minion logic
        quest::settimer("check_hp", 1);         # Health-based immunity logic
        
        # Display message only once when combat begins
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness spreads as the Envoy of Nyseria begins to sap your life force!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness spreads as the Envoy of Nyseria begins to sap your life force!");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");         # Stop life drain
        quest::stoptimer("spell_cast");         # Stop spell casting
        quest::stoptimer("minion_check");       # Stop minion logic
        quest::stoptimer("check_hp");           # Stop health checks
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around the NPC

        # Drain 1000 HP from players, bots, and their pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 1000, 0, 1, false); # False to avoid hate modification
            }
            # Drain from pets of the client
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 1000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 1000, 0, 1, false);
            }
            # Drain from pets of the bot
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 1000, 0, 1, false);
            }
        }
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(40604, $npc->GetID());
        $npc->Attack($npc->GetHateTop());  # Re-engage attack after casting
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        # Summon 3 minions at each health threshold
        if ($hp_ratio <= 75 && $minions_spawned < 1) {
            Summon_Minions(3);
            $minions_spawned = 1;
        } elsif ($hp_ratio <= 50 && $minions_spawned < 2) {
            Summon_Minions(3);
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(3);
            $minions_spawned = 3;
        }
    }

    if ($timer eq "check_hp") {
        # Check if NPC's health is at or below 50%
        if ($npc->GetHPRatio() <= 50) {
            # Make the NPC immune to ranged and magic attacks
            $npc->SetSpecialAbility(46, 1); # Ranged immunity            
            # Stop further checks to prevent re-triggering
            quest::stoptimer("check_hp");
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1733, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("life_drain");
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
    quest::stoptimer("check_hp");
}
