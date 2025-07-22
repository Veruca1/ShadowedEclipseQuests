# ✅ Tint cycle setup — final chosen tints
my @tints = (33);

my $wrath_triggered = 0;  # Tracks if frenzy phase has fired
my $current = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ Boss stats — base boost
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", int(20000 * 1.15));
    $npc->ModifyNPCStat("max_hp", int(75500000 * 1.15));
    $npc->ModifyNPCStat("hp_regen", int(1000 * 1.15));
    $npc->ModifyNPCStat("mana_regen", int(10000 * 1.15));
    $npc->ModifyNPCStat("min_hit", int(20000 * 1.15));
    $npc->ModifyNPCStat("max_hit", int(40000 * 1.15));
    $npc->ModifyNPCStat("atk", int(1400 * 1.15));
    $npc->ModifyNPCStat("accuracy", int(2000 * 1.15));
    $npc->ModifyNPCStat("avoidance", int(90 * 1.15));
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 33);
    $npc->ModifyNPCStat("aggro", 400);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", int(1200 * 1.15));
    $npc->ModifyNPCStat("sta", int(1200 * 1.15));
    $npc->ModifyNPCStat("agi", int(1200 * 1.15));
    $npc->ModifyNPCStat("dex", int(1200 * 1.15));
    $npc->ModifyNPCStat("wis", int(1200 * 1.15));
    $npc->ModifyNPCStat("int", int(1200 * 1.15));
    $npc->ModifyNPCStat("cha", int(1000 * 1.15));

    $npc->ModifyNPCStat("mr", int(300 * 1.15));
    $npc->ModifyNPCStat("fr", int(300 * 1.15));
    $npc->ModifyNPCStat("cr", int(300 * 1.15));
    $npc->ModifyNPCStat("pr", int(300 * 1.15));
    $npc->ModifyNPCStat("dr", int(300 * 1.15));
    $npc->ModifyNPCStat("corruption_resist", int(500 * 1.15));
    $npc->ModifyNPCStat("physical_resist", int(1000 * 1.15));

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    $wrath_triggered = 0;

    quest::setnexthpevent(10);   # ✅ Set HP event for 10%
    quest::settimer("tintcycle", 5);
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 10 && !$wrath_triggered) {
        $wrath_triggered = 1;

        quest::shout("The Regent enters a bloodthirsty frenzy!");

        # Reapply with an additional 30% boost
        $npc->ModifyNPCStat("ac", int(20000 * 1.15 * 1.3));
        $npc->ModifyNPCStat("min_hit", int(20000 * 1.15 * 1.3));
        $npc->ModifyNPCStat("max_hit", int(40000 * 1.15 * 1.3));
        $npc->ModifyNPCStat("atk", int(1400 * 1.15 * 1.3));

        $npc->ModifyNPCStat("str", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("sta", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("agi", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("dex", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("wis", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("int", int(1200 * 1.15 * 1.3));
        $npc->ModifyNPCStat("cha", int(1000 * 1.15 * 1.3));

        $npc->ModifyNPCStat("mr", int(300 * 1.15 * 1.3));
        $npc->ModifyNPCStat("fr", int(300 * 1.15 * 1.3));
        $npc->ModifyNPCStat("cr", int(300 * 1.15 * 1.3));
        $npc->ModifyNPCStat("pr", int(300 * 1.15 * 1.3));
        $npc->ModifyNPCStat("dr", int(300 * 1.15 * 1.3));
        $npc->ModifyNPCStat("corruption_resist", int(500 * 1.15 * 1.3));
        $npc->ModifyNPCStat("physical_resist", int(1000 * 1.15 * 1.3));
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "tintcycle") {
        $npc->SetNPCTintIndex($tints[$current]);
        $current = ($current + 1) % scalar(@tints);
    }
}

sub EVENT_DEATH_COMPLETE {
    if (int(rand(100)) < 25) {
        quest::shout("The Umbral Chorus stirs... Luclin’s gaze falls upon you all...");
    }
}