sub EVENT_SPAWN {
    # Always cast spell 689 to summon the enchanter pet
    $npc->CastSpell(689, $npc->GetID());
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start casting Gravity Flux every 15 seconds during combat
        quest::settimer("gflux", 15);
    } elsif ($combat_state == 0) {
        # Stop casting spells when combat ends
        quest::stoptimer("gflux");
    }
}

sub EVENT_TIMER {
    if ($timer eq "gflux") {
        # Get the list of players in the zone
        my @player_list = $entity_list->GetClientList();
        
        # Loop through each player and cast Gravity Flux unresisted
        foreach my $player (@player_list) {
            if (!$player->IsBot()) {
                $npc->SpellFinished(73, $player, 1, -1000);  # 1 indicates unresisted, -1000 is a placeholder for duration
            }
        }

        # Shout "etaH seviG eM rewoP!" upon casting the spell
        $npc->Shout("etaH seviG eM rewoP!");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Shout "lymA lliW hsurC uoY" upon death
    quest::shout("lymA lliW hsurC uoY");
    quest::spawn2(1245, 0, 0, 6.44, 330.91, -6.44, 2.16);
}