# ===============================================================
# Gallows Master Teion — Boss Stat Template (PoJustice Trial)
# ===============================================================
# - Applies standardized boss-tier stats for Plane of Justice events.
# - No plugin dependencies or dynamic scaling.
# - Signals event control and tribunal upon death.
# - Combines legacy 2010 event logic with modern stat template.
# ===============================================================

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();

    # ===========================================================
    # Boss-tier stat configuration
    # ===========================================================
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 66);

    # Core combat stats
    $npc->ModifyNPCStat("ac", 35000);
    $npc->ModifyNPCStat("max_hp", 200000000);
    $npc->ModifyNPCStat("hp_regen", 4000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 60000);
    $npc->ModifyNPCStat("max_hit", 110000);
    $npc->ModifyNPCStat("atk", 2700);
    $npc->ModifyNPCStat("accuracy", 2200);
    $npc->ModifyNPCStat("avoidance", 75);
    $npc->ModifyNPCStat("heroic_strikethrough", 40);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 95);
    $npc->ModifyNPCStat("aggro", 100);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes
    $npc->ModifyNPCStat("str", 1300);
    $npc->ModifyNPCStat("sta", 1300);
    $npc->ModifyNPCStat("agi", 1300);
    $npc->ModifyNPCStat("dex", 1300);
    $npc->ModifyNPCStat("wis", 1300);
    $npc->ModifyNPCStat("int", 1300);
    $npc->ModifyNPCStat("cha", 1000);

    # Resists
    $npc->ModifyNPCStat("mr", 450);
    $npc->ModifyNPCStat("fr", 450);
    $npc->ModifyNPCStat("cr", 450);
    $npc->ModifyNPCStat("pr", 450);
    $npc->ModifyNPCStat("dr", 450);
    $npc->ModifyNPCStat("corruption_resist", 600);
    $npc->ModifyNPCStat("physical_resist", 1100);

    # Special abilities
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

    # Force HP to max
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # ===========================================================
    # Legacy event communication logic (Greenbean 2010)
    # ===========================================================
    my $mob_id = $npc->GetID();
    quest::signalwith(201075, 1, 2); # Notify Agent_of_The_Tribunal: Teion alive
}

sub EVENT_SIGNAL {
    if ($signal == 0) {
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    # Notify Agent: Boss defeated, unlock return
    quest::signalwith(201075, 11, 2); # NPC: Agent_of_The_Tribunal

    # Notify Tribunal: Trial success
    quest::signalwith(201078, 1, 2);  # NPC: The_Tribunal Execution Trial

    # Notify controller: Trial event concluded
    quest::signalwith(201425, 2, 2);  # NPC: #Event_Execution_Control

    # Flavor message to zone
    quest::ze(15, "An unnatural silence falls around you. The justice of the Tribunal has been pronounced once again. The defendants have been found...worthy.");
}