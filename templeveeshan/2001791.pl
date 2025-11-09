# ===========================================================
# #Lord_Kreizenn
# Temple of Veeshan — Shadowed Eclipse Raid Boss
# - Applies ToV boss baseline stats
# - Integrates RaidScaling for adaptive raid power
# - Casts initial effect (40717) on spawn
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline ToV Boss Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 3000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 8750);
    $npc->ModifyNPCStat("max_hit", 11000);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
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

    # === Immunities and Behavior ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Raid Scaling Integration ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Cast Initial Effect ===
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
