sub EVENT_SPAWN {
    return unless $npc && $npc->IsNPC();

    my $this_npc = $npc->CastToNPC();

    $this_npc->AddNimbusEffect(466);

    # Boss stats
    $this_npc->ModifyNPCStat("level", 63);
    $this_npc->ModifyNPCStat("ac", 40000);
    $this_npc->ModifyNPCStat("max_hp", 12000000);
    $this_npc->SetHP($this_npc->GetMaxHP());
    $this_npc->ModifyNPCStat("hp_regen", 1000);
    $this_npc->ModifyNPCStat("mana_regen", 10000);
    $this_npc->ModifyNPCStat("min_hit", 8500);
    $this_npc->ModifyNPCStat("max_hit", 13000);
    $this_npc->ModifyNPCStat("atk", 1400);
    $this_npc->ModifyNPCStat("accuracy", 2000);
    $this_npc->ModifyNPCStat("avoidance", 150);
    $this_npc->ModifyNPCStat("attack_delay", 4);
    $this_npc->ModifyNPCStat("attack_speed", 100);
    $this_npc->ModifyNPCStat("slow_mitigation", 90);
    $this_npc->ModifyNPCStat("attack_count", 100);
    $this_npc->ModifyNPCStat("heroic_strikethrough", 30);
    $this_npc->ModifyNPCStat("aggro", 60);
    $this_npc->ModifyNPCStat("assist", 1);
    $this_npc->ModifyNPCStat("str", 1200);
    $this_npc->ModifyNPCStat("sta", 1200);
    $this_npc->ModifyNPCStat("agi", 1200);
    $this_npc->ModifyNPCStat("dex", 1200);
    $this_npc->ModifyNPCStat("wis", 1200);
    $this_npc->ModifyNPCStat("int", 1200);
    $this_npc->ModifyNPCStat("cha", 1000);
    $this_npc->ModifyNPCStat("mr", 500);
    $this_npc->ModifyNPCStat("fr", 500);
    $this_npc->ModifyNPCStat("cr", 500);
    $this_npc->ModifyNPCStat("pr", 500);
    $this_npc->ModifyNPCStat("dr", 500);
    $this_npc->ModifyNPCStat("corruption_resist", 500);
    $this_npc->ModifyNPCStat("physical_resist", 1000);
    $this_npc->ModifyNPCStat("runspeed", 0);
    $this_npc->ModifyNPCStat("trackable", 1);
    $this_npc->ModifyNPCStat("see_invis", 1);
    $this_npc->ModifyNPCStat("see_invis_undead", 1);
    $this_npc->ModifyNPCStat("see_hide", 1);
    $this_npc->ModifyNPCStat("see_improved_hide", 1);
    $this_npc->ModifyNPCStat("special_abilities", "2,1^3,1^5^7,1^8,1^14,1^21,1^31,1");

    # Buffs
    my @buffs = (
        5278, 5297, 5488, 10028, 10031, 10013,
        10664, 9414, 300, 15031, 2530, 20147
    );

    foreach my $spell_id (@buffs) {
        $npc->ApplySpellBuff($spell_id);
    }

    # Start out-of-combat depop check
    quest::settimer("depop_check", 60);  # every 60 seconds
    $npc->SetEntityVariable("idle_minutes", 0);
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        my $idle = $npc->GetEntityVariable("idle_minutes") || 0;

        if ($npc->IsEngaged()) {
            $npc->SetEntityVariable("idle_minutes", 0);  # reset if in combat
        } else {
            $idle++;
            $npc->SetEntityVariable("idle_minutes", $idle);
            plugin::Debug("Mirror boss idle for $idle minute(s).");
            if ($idle >= 7) {
                plugin::Debug("Mirror boss depopping due to inactivity.");
                quest::stoptimer("depop_check");
                $npc->Depop();
            }
        }
    }
}