my $crusader_charge_timer = 0;
my $crusader_charge_spell_id = 36833;
my $crusader_charge_chance = 20;  # 20% chance to stun

sub EVENT_SPAWN {
    # Set timers, but spells won't cast until combat starts
    quest::settimer("aura", 5);
    quest::settimer("dark_vengeance", 10);
    quest::settimer("shield", 60);
    quest::settimer("crusader_charge", 30);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Only start casting spells if the NPC is in combat
        if (!$aura_active) {
            quest::castspell(36830, $npc->GetID());  # Aura of the Champion
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Insidious Champion radiates an aura of unparalleled might!");
            }
            $aura_active = 1;
        }

        $dark_vengeance_cast = 0;
        $shield_active = 0;
        $crusader_charge_timer = 0;

        quest::settimer("aura", 5);
        quest::settimer("dark_vengeance", 10);
        quest::settimer("shield", 60);
        quest::settimer("crusader_charge", 30);  # Start the charge timer during combat
    } else {
        # Stop timers if out of combat
        quest::stoptimer("aura");
        quest::stoptimer("dark_vengeance");
        quest::stoptimer("shield");
        quest::stoptimer("crusader_charge");
        $aura_active = 0;
        $dark_vengeance_cast = 0;
        $shield_active = 0;
        $crusader_charge_timer = 0;
    }
}

sub EVENT_TIMER {
    if ($combat_state == 1) {  # Only execute abilities while in combat
        if ($timer eq "aura") {
            # Aura of the Champion remains active while in combat
        }

        if ($timer eq "dark_vengeance") {
            my $hp_ratio = $npc->GetHPRatio();
            if ($hp_ratio <= 50 && !$dark_vengeance_cast) {
                quest::castspell(36831, $npc->GetID());  # Dark Vengeance
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Insidious Champion invokes Dark Vengeance, punishing all who defy him!");
                }
                $dark_vengeance_cast = 1;
            }
        }

        if ($timer eq "shield") {
            if (!$shield_active) {
                quest::castspell(36832, $npc->GetID());  # Shield of the Guardian
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Insidious Champion raises his shield, blocking a portion of your attacks!");
                }
                $shield_active = 1;
            }
        }

        if ($timer eq "crusader_charge") {
            my $target = $npc->GetHateTop();  # Get the top aggro target
            if ($target) {
                # Check for stun chance
                if (int(rand(100)) < $crusader_charge_chance) {
                    quest::castspell($crusader_charge_spell_id, $target->GetID());  # Cast Crusader’s Charge
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Insidious Champion charges forward with righteous fury, delivering a devastating blow!");
                    }
                }
            }
            quest::settimer("crusader_charge", 30);  # Restart the charge timer
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Insidious Champion has fallen. The path to the final boss is now open!");
    }
    quest::stoptimer("aura");
    quest::stoptimer("dark_vengeance");
    quest::stoptimer("shield");
    quest::stoptimer("crusader_charge");
}
