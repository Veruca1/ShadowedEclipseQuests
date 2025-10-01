# === Nyseria Guard Glitch Illusion Boss Script (20% chance at spawn, guaranteed poppet if glitchy) ===

my $scaled_spawn   = 0;   # block double scaling
my $glitch_enabled = 0;   # determines if this NPC glitches
my %initial_appearance;
my %nyseria_guard = (
    race         => 566,
    gender       => 1,
    texture      => 6,
    helm_texture => 6,
);
my $using_guard = 0;  # track illusion state

sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(623);

    # === Boss baseline stats ===
    $npc->ModifyNPCStat("level",     65);
    $npc->ModifyNPCStat("ac",        30000);
    $npc->ModifyNPCStat("max_hp",    3000000);
    $npc->ModifyNPCStat("hp_regen",  3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   45000);
    $npc->ModifyNPCStat("max_hit",   55000);
    $npc->ModifyNPCStat("atk",       2500);
    $npc->ModifyNPCStat("accuracy",  2000);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 28);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1200);
    $npc->ModifyNPCStat("sta", 1200);
    $npc->ModifyNPCStat("agi", 1200);
    $npc->ModifyNPCStat("dex", 1200);
    $npc->ModifyNPCStat("wis", 1200);
    $npc->ModifyNPCStat("int", 1200);
    $npc->ModifyNPCStat("cha", 1000);

    $npc->ModifyNPCStat("mr", 400);
    $npc->ModifyNPCStat("fr", 400);
    $npc->ModifyNPCStat("cr", 400);
    $npc->ModifyNPCStat("pr", 400);
    $npc->ModifyNPCStat("dr", 400);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist",   1000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8^13,1^14,1^15,1^17,1^21,1");

    # Scale for raid/group size
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    # Ensure HP is set after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Record initial appearance ===
    $initial_appearance{race}         = $npc->GetRace();
    $initial_appearance{gender}       = $npc->GetGender();
    $initial_appearance{texture}      = $npc->GetTexture();
    $initial_appearance{helm_texture} = $npc->GetHelmTexture();

    # === Roll chance for glitching ===
    if (rand() <= 0.20) {  # 20% chance
        $glitch_enabled = 1;

        # ✅ Guarantee drop of Shadowed Coven Poppet (56496)
        $npc->AddItem(56496, 1);

        # Start glitch illusion timer
        _set_random_glitch_timer();
    }
}

sub EVENT_TIMER {
    return unless $glitch_enabled;  # only run if glitching enabled

    if ($timer eq "glitch") {
        if ($using_guard) {
            # Restore initial look
            $npc->SendIllusion(
                $initial_appearance{race},
                $initial_appearance{gender},
                $initial_appearance{texture},
                $initial_appearance{helm_texture}
            );
            $using_guard = 0;
        } else {
            # Apply Nyseria Guard illusion
            $npc->SendIllusion(
                $nyseria_guard{race},
                $nyseria_guard{gender},
                $nyseria_guard{texture},
                $nyseria_guard{helm_texture}
            );
            $using_guard = 1;
        }
        # Reset with new random glitch time
        _set_random_glitch_timer();
    }
}

sub _set_random_glitch_timer {
    my $interval = (rand(2.99) + 0.01); # between 0.01s and 3s
    quest::stoptimer("glitch");
    quest::settimer("glitch", $interval);
}