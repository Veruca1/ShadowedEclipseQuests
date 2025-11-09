# ===========================================================
# 1758.pl — Overseer_Hragveld_Frostbane (Kael Drakkel)
# Shadowed Eclipse: Velious Tier Boss Scaling
# - Applies Kael baseline boss stats
# - Integrates adaptive RaidScaling system
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Boss Stats (Kael Default) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 2750000);
    $npc->ModifyNPCStat("hp_regen", 3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9500);
    $npc->ModifyNPCStat("max_hit", 12500);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 1200);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    $npc->ModifyNPCStat("mr", 260);
    $npc->ModifyNPCStat("fr", 260);
    $npc->ModifyNPCStat("cr", 260);
    $npc->ModifyNPCStat("pr", 260);
    $npc->ModifyNPCStat("dr", 260);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 650);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    plugin::RaidScaling($entity_list, $npc);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat
        # Remove buffs immediately when the NPC engages in combat
        my $radius = 50;  # Set your desired radius (e.g., 50 units)
        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc);
            if ($distance <= $radius) {
                # Fade each beneficial buff individually
                foreach my $buff_id ($client->GetBuffs()) {
                    $client->BuffFadeBySpellID($buff_id);  # Fades each buff individually
                }

                # Message to the client (player, bot, or pet)
                $client->Message(14, "Overseer Hragveld bashes you so hard that a buff fades from your body!");
            }
        }

        # Start the 40-second timer to continue removing buffs periodically
        quest::settimer("life_drain", 40);
    }
    elsif ($combat_state == 0) {
        # NPC has left combat, stop the life drain timer
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        # Drain buffs from players, pets, and bots in the radius every 40 seconds
        my $radius = 50;  # Set your desired radius (e.g., 50 units)
        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc);
            if ($distance <= $radius) {
                # Fade each beneficial buff individually
                foreach my $buff_id ($client->GetBuffs()) {
                    $client->BuffFadeBySpellID($buff_id);  # Fades each buff individually
                }

                # Message to the client (player, bot, or pet)
                $client->Message(14, "Overseer Hragveld bashes you so hard that a buff fades from your body!");
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1764, 7);
}