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
    $this_npc->ModifyNPCStat("min_hit", 9500);
    $this_npc->ModifyNPCStat("max_hit", 13000);
    $this_npc->ModifyNPCStat("atk", 1400);
    $this_npc->ModifyNPCStat("accuracy", 2000);
    $this_npc->ModifyNPCStat("avoidance", 150);
    $this_npc->ModifyNPCStat("attack_delay", 4);
    $this_npc->ModifyNPCStat("attack_speed", 100);
    $this_npc->ModifyNPCStat("slow_mitigation", 90);
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
    $this_npc->ModifyNPCStat("mr", 200);
    $this_npc->ModifyNPCStat("fr", 200);
    $this_npc->ModifyNPCStat("cr", 200);
    $this_npc->ModifyNPCStat("pr", 200);
    $this_npc->ModifyNPCStat("dr", 200);
    $this_npc->ModifyNPCStat("corruption_resist", 200);
    $this_npc->ModifyNPCStat("physical_resist", 1000);
    $this_npc->ModifyNPCStat("runspeed", 5);
    $this_npc->ModifyNPCStat("trackable", 1);
    $this_npc->ModifyNPCStat("see_invis", 1);
    $this_npc->ModifyNPCStat("see_invis_undead", 1);
    $this_npc->ModifyNPCStat("see_hide", 1);
    $this_npc->ModifyNPCStat("see_improved_hide", 1);
    $this_npc->ModifyNPCStat("special_abilities", "1,1,3000,50^2,1,1,1000,2340^3,1,20,0,0,0,0,100,0^4,1,0,100,0,0,0,100,0^6,1^7,1^10,1^11,1,4,150,0,0,5^14,1^21,1^23,1^29,1,50^40,1,10,10,100");

    # Buffs
    my @buffs = (
        5278, 5297, 5488, 10028, 10031, 10013,
        10664, 9414, 300, 15031, 2530, 20147
    );

    foreach my $spell_id (@buffs) {
        $npc->ApplySpellBuff($spell_id);
    }

    # Timers
    quest::settimer("depop_check", 60);  # idle check
    $npc->SetEntityVariable("idle_minutes", 0);

    quest::settimer("cleanse", 5 + int(rand(30)));  # random 30–59 sec start
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        my $idle = $npc->GetEntityVariable("idle_minutes") || 0;

        if ($npc->IsEngaged()) {
            $npc->SetEntityVariable("idle_minutes", 0);
        } else {
            $idle++;
            $npc->SetEntityVariable("idle_minutes", $idle);
            plugin::Debug("Mirror boss idle for $idle minute(s).");
            if ($idle >= 7) {
                plugin::Debug("Mirror boss depopping due to inactivity.");
                quest::stoptimer("depop_check");
                quest::stoptimer("cleanse");
                $npc->Depop();
            }
        }
    }
    elsif ($timer eq "cleanse") {
        plugin::Debug("Mirror boss cleansing itself of debuffs.");
        $npc->BuffFadeDetrimental();
        $npc->Shout("Your magic cannot contain me!");

        quest::stoptimer("cleanse");
        quest::settimer("cleanse", 30 + int(rand(30)));  # re-randomize
    }
}
