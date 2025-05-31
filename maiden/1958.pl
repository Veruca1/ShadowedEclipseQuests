my $is_invul = 0;  # Manual tracker since IsInvul() doesn't exist
my $check_invul_count = 0;

sub EVENT_SPAWN {
    quest::shout("The secrets of Akheva grow restless once more.");

    if (defined $npc) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 40000);
        $npc->ModifyNPCStat("max_hp", 12000000);
        $npc->SetHP($npc->GetMaxHP());
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8500);
        $npc->ModifyNPCStat("max_hit", 13000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 150);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 30);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("mr", 200);
        $npc->ModifyNPCStat("fr", 200);
        $npc->ModifyNPCStat("cr", 200);
        $npc->ModifyNPCStat("pr", 200);
        $npc->ModifyNPCStat("dr", 200);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 0);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5^7,1^8,1^13,1^14,1^17,1^21,1^31,1^33,1");

        if ($npc->IsEngaged()) {
            quest::settimer("spirit_spawn", 60);
        }
    }

    quest::settimer("check_invul", 5);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("combat_shout", 45);
    } else {
        quest::stoptimer("combat_shout");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_invul") {
        $check_invul_count++;

        if ($check_invul_count % 6 == 0) {
            # Optional: do something every 30 seconds
        }

        # Simulate random invul/vuln toggle
        if (rand() < 0.05) {
            if ($is_invul == 0) {
                $npc->SetInvul(1);
                $is_invul = 1;
                quest::shout("The power of dust grants me invulnerability!");
            } else {
                $npc->SetInvul(0);
                $is_invul = 0;
                quest::shout("My defenses fall — the dust's power fades!");
            }
        }
    }

    if ($timer eq "combat_shout") {
        my @shouts = (
            "You trespass on sacred ground! The Umbral Chorus will see your soul extinguished!",
            "Luclin's gaze pierces even the deepest shadow...",
            "The Coven chants still echo through the halls of Ka Va Xakra!",
            "The hieroglyphs in this room burn with the knowledge of gods — knowledge you will not survive to understand.",
            "Sel`Rheza's vision foretold this bloodshed. She will be pleased.",
            "Nyseria offers no mercy to intruders. Nor do I.",
            "You walk in the wake of forgotten gods... and their wrath is not forgotten.",
            "This ruin is no longer dead — it remembers, and it hates.",
            "The Akheva do not forgive. They endure. And now, you will endure... pain."
        );
        quest::shout($shouts[int(rand(@shouts))]);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The spirits scatter... but their echoes remain...");
    quest::signalwith(1352, 4); # Signal controller to respawn Sanctum of Dust 7 mins later

    # Clean up
    quest::depop(1960);
    quest::depop(1961);
    quest::depop(1962);
    quest::depop(1963);
    quest::stoptimer("check_invul");
    quest::stoptimer("combat_shout");

    if (int(rand(100)) < 20) {
        quest::spawn2(1976, 0, 0, $x, $y, $z, $h);
    }
}