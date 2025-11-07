#a_dark_visage

my @curses = (41236, 41237, 41239, 41240);

sub EVENT_SPAWN {
    return unless $npc;

    # === Faction & Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 15000000);
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("min_hit", 44000);
    $npc->ModifyNPCStat("max_hit", 55000);
    $npc->ModifyNPCStat("attack_speed", 30);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes ===
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # === Resists ===
    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # === Immunities ===
    $npc->SetSpecialAbility(3, 1);
    $npc->SetSpecialAbility(5, 1);
    $npc->SetSpecialAbility(7, 1);
    $npc->SetSpecialAbility(8, 1);
    $npc->SetSpecialAbility(9, 1);
    $npc->SetSpecialAbility(10, 1);
    $npc->SetSpecialAbility(14, 1);

    $npc->SetHP($npc->GetMaxHP());
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("curse_bots", 2);
    } else {
        quest::stoptimer("curse_bots");
    }
}

sub EVENT_TIMER {
    return unless $timer eq "curse_bots";

    foreach my $bot ($entity_list->GetBotList()) {
        next unless $bot;

        my $already_cursed = 0;
        foreach my $curse_id (@curses) {
            if ($bot->FindBuff($curse_id)) {
                $already_cursed = 1;
                last;
            }
        }

        unless ($already_cursed) {
            my $chosen = $curses[rand @curses];
            $npc->SpellFinished($chosen, $bot);
            $bot->Message(15, "A dark curse takes hold of you from the shadows!");
        }
    }
}