# ===========================================================
# 2261.pl — #The_Dreamforged_Horror
# Shadowed Eclipse: Custom Boss Logic (Debug Version)
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;
    quest::debug("DEBUG: 2261 (#The_Dreamforged_Horror) spawned at (" . $npc->GetX() . ", " . $npc->GetY() . ", " . $npc->GetZ() . ")");

    # === Base stats (boss-tier from default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level",       66);
    $npc->ModifyNPCStat("ac",          35000);
    $npc->ModifyNPCStat("max_hp",      200000000);
    $npc->ModifyNPCStat("hp_regen",    4000);
    $npc->ModifyNPCStat("min_hit",     60000);
    $npc->ModifyNPCStat("max_hit",     110000);
    $npc->ModifyNPCStat("atk",         2700);
    $npc->ModifyNPCStat("accuracy",    2200);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 40);
    $npc->ModifyNPCStat("slow_mitigation", 95);
    $npc->ModifyNPCStat("aggro",       65);
    $npc->ModifyNPCStat("assist",      1);

    # === Resistances & attributes ===
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
    $npc->ModifyNPCStat("corrup", 600);
    $npc->ModifyNPCStat("phresist", 1100);

    # === Special abilities ===
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^33,1");

    # === HP set to full ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

# ===========================================================
# Signal Handling
# ===========================================================
sub EVENT_SIGNAL {
    quest::debug("DEBUG: 2261 received signal $signal");

    if ($signal == 9) {
        quest::stoptimer("spawn_2260");
        quest::settimer("spawn_2260", 30);
        quest::we(15, "[DEBUG] #The_Dreamforged_Horror: signal 9 received — spawning adds every 30s");
    }
    elsif ($signal == 10) {
        quest::stoptimer("spawn_2260");
        quest::we(15, "[DEBUG] #The_Dreamforged_Horror: signal 10 received — stopping add spawns");
    }
}

# ===========================================================
# Timed Spawning — 4x #2260 each interval
# ===========================================================
sub EVENT_TIMER {
    if ($timer eq "spawn_2260") {
        quest::debug("DEBUG: 2261 spawning four 2260 adds");
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        for (my $i = 0; $i < 4; $i++) {
            my $offset_x = $x + int(rand(60)) - 30;
            my $offset_y = $y + int(rand(60)) - 30;
            my $spawn_id = quest::spawn2(2260, 0, 0, $offset_x, $offset_y, $z, $h);
            quest::debug("DEBUG: 2261 spawned 2260 ID $spawn_id at ($offset_x, $offset_y, $z)");
        }
    }
}