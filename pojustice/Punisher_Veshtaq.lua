# ===============================================================
# #Punisher_of_Anguish — Boss Stat Template (PoJustice Torture Trial)
# ===============================================================
# - Applies standardized boss-tier stats for Plane of Justice events.
# - Adds dynamic scaling based on raid size.
# - Sends signals to controller and tribunal on death.
# ===============================================================

my $scaled_spawn = 0;

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();
    return if $scaled_spawn;

    # Static boss base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 66);

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

    $npc->ModifyNPCStat("str", 1300);
    $npc->ModifyNPCStat("sta", 1300);
    $npc->ModifyNPCStat("agi", 1300);
    $npc->ModifyNPCStat("dex", 1300);
    $npc->ModifyNPCStat("wis", 1300);
    $npc->ModifyNPCStat("int", 1300);
    $npc->ModifyNPCStat("cha", 1000);

    $npc->ModifyNPCStat("mr", 450);
    $npc->ModifyNPCStat("fr", 450);
    $npc->ModifyNPCStat("cr", 450);
    $npc->ModifyNPCStat("pr", 450);
    $npc->ModifyNPCStat("dr", 450);
    $npc->ModifyNPCStat("corruption_resist", 600);
    $npc->ModifyNPCStat("physical_resist", 1100);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

    # Apply dynamic raid scaling
    plugin::RaidScaling($entity_list, $npc);

    # Force HP to max after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    $scaled_spawn = 1;
}

sub EVENT_DEATH_COMPLETE {
    # Signal the Torture Trial controller
    quest::signalwith(201450, 1, 0); # NPC: #Event_Torture_Control

    # Signal the Tribunal that the boss has died
    quest::signalwith(201438, 1, 0); # NPC: The_Tribunal Torture Trial
}