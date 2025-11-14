# ===============================================================
# #Saryrn.pl — Plane of Torment (potorment)
# Shadowed Eclipse: Mistress of Anguish Encounter
# ---------------------------------------------------------------
# - Coordinates minion and Sorrowsong spawns at HP thresholds
# - Resets event if not engaged for 5 minutes
# - Spawns Sorrowsong support NPC on event start and at 25%
# - Respawns Sorrowsong if event resets
# - Prevents Z-axis exploit by returning to bind point
# - Spawns Planar Projection on death
# ===============================================================

sub EVENT_SPAWN {
    # Apply baseline boss stats directly
    $npc->ModifyNPCStat("level", 70);
    $npc->ModifyNPCStat("ac", 35000);
    $npc->ModifyNPCStat("max_hp", 202000000);     # 200m + 1% for potorment
    $npc->ModifyNPCStat("hp_regen", 4000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 65600);        # 60k + 1%
    $npc->ModifyNPCStat("max_hit", 121100);       # 110k + 1%
    $npc->ModifyNPCStat("atk", 2700);
    $npc->ModifyNPCStat("accuracy", 2200);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 40);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 95);
    $npc->ModifyNPCStat("aggro", 100);
    $npc->ModifyNPCStat("assist", 1);

    # Primary stats
    $npc->ModifyNPCStat("str", 1300);
    $npc->ModifyNPCStat("sta", 1300);
    $npc->ModifyNPCStat("agi", 1300);
    $npc->ModifyNPCStat("dex", 1300);
    $npc->ModifyNPCStat("wis", 1300);
    $npc->ModifyNPCStat("int", 1300);
    $npc->ModifyNPCStat("cha", 1000);

    # Resists
    $npc->ModifyNPCStat("mr", 450);
    $npc->ModifyNPCStat("fr", 450);
    $npc->ModifyNPCStat("cr", 450);
    $npc->ModifyNPCStat("pr", 450);
    $npc->ModifyNPCStat("dr", 450);
    $npc->ModifyNPCStat("corruption_resist", 600);
    $npc->ModifyNPCStat("physical_resist", 1100);

    # Special abilities (same as other bosses)
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1");

    # Set HP to max after stat update
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Apply raid scaling
    plugin::RaidScaling($entity_list, $npc);

    # Start HP event and sorrow timer
    quest::setnexthpevent(98);
    quest::settimer("spawnsorrow", 5 * 10);
}


sub EVENT_HP {
    if ($hpevent == 98) {
        quest::signalwith(207052, 1, 0); # Sorrowsong
        $npc->Say("Sorrowsong, sing for us. We want these wretches to enjoy their stay, don't we?");
        quest::setnexthpevent(90);
        quest::setnextinchpevent(99); # reset if event fails

    } elsif ($hpevent == 90 || $hpevent == 80 || $hpevent == 70 || $hpevent == 60 ||
             $hpevent == 50 || $hpevent == 40 || $hpevent == 30 || $hpevent == 20 || $hpevent == 10) {
        # Spawn waves of torment adds
        foreach my $offset (-12, -1, 10) {
            my $mob = (rand() < 0.5) ? 207085 : 207086; # random add type
            quest::spawn2($mob, 0, 0, $offset, -72, 579, 1);
        }
        my %next_event = (
            90 => 80, 80 => 70, 70 => 60, 60 => 50,
            50 => 40, 40 => 30, 30 => 25, 20 => 10
        );
        quest::setnexthpevent($next_event{$hpevent}) if exists $next_event{$hpevent};

    } elsif ($hpevent == 25) {
        # Sorrowsong joins the battle
        quest::spawn2(207065, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        $npc->Say("This filth is proving to be a challenge! Sorrowsong, attack these mortals!");
        quest::depop(207052);
        quest::setnexthpevent(20);
    }

    if ($inchpevent == 99) {
        quest::setnexthpevent(98);
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::stoptimer("reset");
        quest::settimer("zcheck", 6 * 1000);
    } else {
        quest::settimer("reset", 300 * 1000); # 5 min reset timer
        quest::stoptimer("zcheck");
    }
}

sub EVENT_ATTACK {
    return unless $client;

    my $cid = $client->CharacterID();
    my $flag = quest::get_data("potor_saryrn_final_$cid");

    if (defined $flag && $flag == 1) {
        $npc->SetInvul(0);
    } else {
        $npc->SetInvul(1);
        $client->Message(13, "Saryrn's aura of torment rejects your assault. You must overcome her prior horrors.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "reset") {
        quest::stoptimer("reset");
        quest::setnextinchpevent(99); # reset fail flag
        quest::depop(207052);
        quest::depop(207065);
        quest::settimer("spawnsorrow", 5 * 1000);

    } elsif ($timer eq "spawnsorrow") {
        quest::stoptimer("spawnsorrow");
        quest::unique_spawn(207052, 0, 0, 1, 2, 579, 247); # Sorrowsong initial spawn

    } elsif ($timer eq "zcheck") {
        if ($npc->GetZ() < 520) {
            $npc->Emote("dissolves into a swirling mist and moves back across the room.");
            $npc->GotoBind();
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::unique_spawn(218068, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading()); # Planar Projection
}