# NPC: #Paradigm_of_Reflection (NPCID: 2178)
# Access gate to the Cave of Reflection
# Interaction is gated by SSRA_AllFlags_${cid}

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Custom plugin: exclusion list (assumed present per user environment)
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Base stats
    $npc->SetNPCFactionID(0);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 900000000);
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 12000);
    $npc->ModifyNPCStat("max_hit", 20000);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 22);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "12,1^13,1^14,1^15,1^16,1^17,1^18,1^35,1^39,1^42,1^26,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^41,1^45,1^46,1");

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Delay tint to ensure it applies
    quest::settimer("apply_tint", 1);
}

sub EVENT_TIMER {
    if ($timer eq "apply_tint") {
        quest::stoptimer("apply_tint");
        # Black tint (index 30) — custom env method provided by user
        $npc->SetNPCTintIndex(30);
    }
}

sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $cid = $client->CharacterID();
    return unless defined $cid;

    my $final_flag = "SSRA_AllFlags_${cid}";
    my $has_flag   = quest::get_data($final_flag) ? 1 : 0;

    # If the player doesn't have the final SSRA flag, the NPC ignores them.
    return unless $has_flag;

    if ($text =~ /hail/i) {
        my $ready = quest::saylink("READY", 1);
        $npc->Say(
            "Ahead lies the Cave of Reflection — a crucible of all that you are and all you hide. " .
            "It tests patience, skill, and might, and it turns your inner darkness back upon you. " .
            "If you are $ready, step forward and face what stares back."
        );
        return;
    }

    if ($text =~ /^READY$/i) {
    my @locs = (
        [ 217.89,  -643.63, -255.94, 122.75 ],
        [ 116.48,  -663.79, -255.94, 125.25 ],
        [ 104.96,  -710.75, -255.94,  12.75 ],
        [ 146.13,  -727.80, -255.94, 490.50 ],
        [   4.49,  -676.16, -255.94, 100.00 ],
        [ -45.19,  -696.22, -255.94,  90.50 ],
        [ -48.85,  -770.88, -255.94,  20.00 ],
        [ -94.84,  -743.27, -255.94, 121.25 ],
        [   0.11,  -880.88, -255.94, 462.00 ],
        [  -8.83,  -947.41, -255.94,  60.25 ],
        [  42.77,  -899.75, -255.94, 381.25 ],
        [ -58.21, -1002.85, -255.94, 115.25 ],
        [ -122.43, -1032.45, -255.94,  67.25 ],
        [  -80.02, -1086.81, -255.94, 396.75 ],
        [   -4.22, -1152.58, -255.94, 432.25 ],
        [   62.33, -1146.90, -255.94, 377.50 ],
        [  111.75, -1116.50, -255.94, 284.25 ],
        [   84.42, -1105.95, -255.94, 300.50 ],
        [ -159.78,  -978.73, -255.94, 250.25 ],
        [ -208.76,  -998.14, -255.94, 108.75 ],
    );

    # Loop through every location
    foreach my $loc (@locs) {
        my $npc_id = (rand() < 0.5) ? 2179 : 2180; # 50/50 random choice
        quest::spawn2($npc_id, 0, 0, @$loc);
    }

    # Always spawn 2181 at fixed location
    quest::spawn2(2181, 0, 0, 125.15, -760.66, -255.94, 14.50);

    $npc->Say("Then let the mirror turn.");
    return;
}
}