my $spell_timer_active = 0;
my $last_spell_target_id = 0;

sub EVENT_SPAWN {
    quest::debug("NPC spawned. Starting hunt timer.");
    quest::settimer("hunt", 1);  # Start the hunt timer immediately
}

sub EVENT_COMBAT {
    if ($combat_state == 1 && !$spell_timer_active) {
        quest::debug("Combat engaged. Attempting to cast initial spell.");
        my $target = $npc->GetHateTop();
        if ($target && $target->IsClient()) {
            my $client = $target->CastToClient();
            quest::debug("Casting spell 9413 on " . $client->GetCleanName() . " (ID: " . $client->GetID() . ")");
            $npc->CastSpell(9413, $client->GetID());
            $last_spell_target_id = $client->GetID();
            quest::settimer("periodic_spell", 20);
            $spell_timer_active = 1;
        } else {
            quest::debug("No valid client target found on hate list.");
        }
    }
    elsif ($combat_state == 0) {
        quest::debug("Combat ended. Stopping periodic spell timer.");
        quest::stoptimer("periodic_spell");
        $spell_timer_active = 0;
        $last_spell_target_id = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {       
        quest::debug("Hunt timer triggered.");
        my @clients = $entity_list->GetClientList();
        @clients = grep { !$_->GetGM() } @clients;
        
        quest::debug("Found " . scalar(@clients) . " non-GM clients.");

        if (@clients) {
            my $target = $clients[rand @clients];
            quest::debug("Hunting " . $target->GetCleanName() . " (ID: " . $target->GetID() . ")");
            $target->Message(15, "You feel like you are being watched");
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), true); 
        }

        quest::settimer("hunt", 5);
    }
    elsif ($timer eq "periodic_spell") {
        quest::debug("Periodic spell timer triggered.");
        my $target = $entity_list->GetClientByID($last_spell_target_id);
        if ($target) {
            quest::debug("Recasting spell 9413 on " . $target->GetCleanName() . " (ID: " . $target->GetID() . ")");
            $npc->CastSpell(9413, $target->GetID());
        } else {
            quest::debug("Target no longer valid. Stopping periodic spell timer.");
            quest::stoptimer("periodic_spell");
            $spell_timer_active = 0;
            $last_spell_target_id = 0;
        }
    }
}

sub EVENT_DEATH_COMPLETE {  
    quest::debug("NPC died. Stopping all timers.");
    quest::stoptimer("hunt");
    quest::stoptimer("periodic_spell");
    quest::signalwith(1937, 500);
}