sub EVENT_SPAWN {
    $npc->SpellFinished(40717, $npc);
}

sub EVENT_DAMAGE_TAKEN {
    my $attacker = $entity_list->GetClientByID($entity_id); # Check if direct client

    if (!$attacker) {
        # If not a client, maybe a bot or pet
        my $entity = $entity_list->GetMobID($entity_id);
        if ($entity) {
            if ($entity->IsBot()) {
                $attacker = $entity->CastToBot()->GetOwner();
            }
            elsif ($entity->IsPet()) {
                $attacker = $entity->GetOwner();
            }
        }
    }

    if ($attacker && $attacker->IsClient()) {
        my $client = $attacker->CastToClient();
        my $finger_item = $client->GetItemIDAt(15); # Slot 15 = finger1
        my $finger2_item = $client->GetItemIDAt(16); # Slot 16 = finger2

        if ($finger_item == 33192 || $finger2_item == 33192) {
            return int($damage); # No mitigation if player has the item
        }
    }

    # Only mitigate if the NPC still has the buff 40717
    if ($npc->FindBuff(40717)) {
        my $reduced_damage = int($damage * 0.05); # Take only 5% damage
        return $reduced_damage;
    }

    return int($damage); # Normal damage otherwise
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::signalwith(1911, 999);
    }
}

sub EVENT_DEATH_COMPLETE {    
    quest::signalwith(1911, 998);
}
