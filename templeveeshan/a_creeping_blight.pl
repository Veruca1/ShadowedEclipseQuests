# ===========================================================
# a_creeping_blight (1355)
# Temple of Veeshan — Shadowed Eclipse Trash Mob
# - Applies custom ToV trash baseline stats
# - Integrates RaidScaling for adaptive group/raid scaling
# - Hunts random players periodically
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline ToV Trash Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 56);
    $npc->ModifyNPCStat("ac", 9500);
    $npc->ModifyNPCStat("max_hp", 500000);
    $npc->ModifyNPCStat("hp_regen", 700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 6500);
    $npc->ModifyNPCStat("max_hit", 8000);
    $npc->ModifyNPCStat("atk", 850);
    $npc->ModifyNPCStat("accuracy", 850);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 4);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("slow_mitigation", 60);
    $npc->ModifyNPCStat("aggro", 45);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 750);
    $npc->ModifyNPCStat("sta", 750);
    $npc->ModifyNPCStat("agi", 750);
    $npc->ModifyNPCStat("dex", 750);
    $npc->ModifyNPCStat("wis", 750);
    $npc->ModifyNPCStat("int", 750);
    $npc->ModifyNPCStat("cha", 550);

    $npc->ModifyNPCStat("mr", 160);
    $npc->ModifyNPCStat("fr", 160);
    $npc->ModifyNPCStat("cr", 160);
    $npc->ModifyNPCStat("pr", 160);
    $npc->ModifyNPCStat("dr", 160);
    $npc->ModifyNPCStat("corruption_resist", 130);
    $npc->ModifyNPCStat("physical_resist", 320);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");
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

    # === Begin Hunt Routine ===
    quest::settimer("hunt", 1);
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();
        @clients = grep { !$_->GetGM() } @clients;

        if (@clients) {
            my $target = $clients[rand @clients];
            $target->Message(15, "You feel like you are being watched...");
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), true);
        }

        quest::settimer("hunt", 5);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");
    quest::signalwith(1911, 500);
}