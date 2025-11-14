# ===============================================================
# The Seventh Hammer — Boss Logic with Raid Scaling (Perl)
# ===============================================================
# - Boss-tier stats applied on spawn
# - Raid scaling via plugin
# - Timed spell abilities
# - Signals The Tribunal (201077) if within 200 units
# - Activates Tribunal Guardians (2266–2271) at HP thresholds
# ===============================================================

my $scaled_spawn = 0;
my $last_unflagged_aggro_time = 0;

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();
    return if $scaled_spawn;

    # Default to invulnerable until a valid char with access engages
    $npc->SetInvul(1);

    # Boss base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 68);
    $npc->ModifyNPCStat("ac", 35000);
    $npc->ModifyNPCStat("max_hp", 250000000);
    $npc->ModifyNPCStat("hp_regen", 4000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 65000);
    $npc->ModifyNPCStat("max_hit", 120000);
    $npc->ModifyNPCStat("atk", 2700);
    $npc->ModifyNPCStat("accuracy", 2200);
    $npc->ModifyNPCStat("avoidance", 75);
    $npc->ModifyNPCStat("heroic_strikethrough", 40);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 95);
    $npc->ModifyNPCStat("aggro", 100);
    $npc->ModifyNPCStat("assist", 1);
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
    $npc->ModifyNPCStat("corruption_resist", 600);
    $npc->ModifyNPCStat("physical_resist", 1100);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

    plugin::RaidScaling($entity_list, $npc);
    quest::setnexthpevent(80);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    $scaled_spawn = 1;
}

sub EVENT_AGGRO {
    my $charid = $client ? $client->CharacterID() : undef;
    my $now = time;

    if ($charid && quest::get_data("poj_trial_complete_$charid")) {
        $npc->SetInvul(0);  # Allow damage if flag is set
    } else {
        if ($now - $last_unflagged_aggro_time > 60) {
            $npc->SetInvul(1);
            $npc->Shout("You are not yet worthy to face me. Complete the Tribunal's trials.");
            $last_unflagged_aggro_time = $now;
        }
        $npc->WipeHateList();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("tremor", 20);
        quest::settimer("verdict", 35);
    }
}

sub EVENT_TIMER {
    if ($timer eq "tremor") {
        quest::stoptimer("tremor");
        $npc->CastSpell(41257, $npc->GetTarget()->GetID());

        my $tribunal = $entity_list->GetNPCByNPCTypeID(201077);
        if ($tribunal && $tribunal->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) < 200) {
            quest::signalwith(201077, 1, 0);
        }
        quest::settimer("tremor", 150);

    } elsif ($timer eq "verdict") {
        quest::stoptimer("verdict");
        $npc->CastSpell(41257, $npc->GetTarget()->GetID());

        my $tribunal = $entity_list->GetNPCByNPCTypeID(201077);
        if ($tribunal && $tribunal->CalculateDistance($npc->GetX(), $npc->GetY(), $npc->GetZ()) < 200) {
            quest::signalwith(201077, 1, 0);
        }
        quest::settimer("verdict", 150);

    } elsif ($timer eq "depop") {
        quest::depop();
    }
}

sub EVENT_HP {
    if ($hpevent == 80) {
        $npc->Shout("I call upon the First Tribunal — rise and pass judgment!");
        quest::signalwith(2266, 1, 0);
        quest::setnexthpevent(70);
    }
    elsif ($hpevent == 70) {
        $npc->Shout("The Second Tribunal shall see your crimes!");
        quest::signalwith(2267, 1, 0);
        quest::setnexthpevent(60);
    }
    elsif ($hpevent == 60) {
        $npc->Shout("Third Tribunal, lend me your fury!");
        quest::signalwith(2268, 1, 0);
        quest::setnexthpevent(40);
    }
    elsif ($hpevent == 40) {
        $npc->Shout("Fourth Tribunal, awaken and render your sentence!");
        quest::signalwith(2269, 1, 0);
        quest::setnexthpevent(30);
    }
    elsif ($hpevent == 30) {
        $npc->Shout("Let the Fifth Tribunal rise and bear witness!");
        quest::signalwith(2270, 1, 0);
        quest::setnexthpevent(10);
    }
    elsif ($hpevent == 10) {
        $npc->Shout("Sixth Tribunal, the time of reckoning has come!");
        quest::signalwith(2271, 1, 0);
    }
}