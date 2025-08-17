# ---------------------------
# Creeping Blight Spawn Locations
# ---------------------------
my @blight_locs = (
    { x => -86.05,   y => 170.41, z => -222.94, h => 265.75 }, # Guardian 1
    { x => -83.24,   y => -190.16, z => -222.94, h => 2.25 },  # Guardian 2
    { x => -190.21,  y => 44.69,  z => -225.12, h => 165.50 }, # New 1
    { x => 71.28,    y => -7.09,  z => -258.12, h => 385.50 }  # New 2
);

# ---------------------------
# Black Mirror Spawn Location
# ---------------------------
my $mirror_x = 990.0;
my $mirror_y = -325.0;
my $mirror_z = 415.0;
my $mirror_h = 384;

sub EVENT_SPAWN {
    return unless $npc;
    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusion list check
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Spawn intro message
    $npc->CameraEffect(1000, 3);
    quest::shout("I see you... from the other side of the mirror.");

    # Apply base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 29000);
    $npc->ModifyNPCStat("max_hp", 250000000);
    $npc->ModifyNPCStat("hp_regen", 1700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 40000);
    $npc->ModifyNPCStat("max_hit", 90000);
    $npc->ModifyNPCStat("atk", 1800);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 5);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 21);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Buffs & Nimbus timers
    quest::settimer("init_effects", 1);
    quest::settimer("lunar_nimbus_buff", 8);
    quest::settimer("spawn_blight", 10);

    # Set HP event for 25%
    quest::setnexthpevent(25);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("proximity_check", 5); # Check every 5 seconds during combat
    } else {
        quest::stoptimer("proximity_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");
        my @buffs = (
            5278, 5297, 5488, 10028, 10031, 10013,
            10664, 9414, 300, 15031, 2530, 42135
        );
        foreach my $spell_id (@buffs) {
            $npc->SpellFinished($spell_id, $npc);
        }
    }
    elsif ($timer eq "lunar_nimbus_buff") {
        quest::stoptimer("lunar_nimbus_buff");
        $npc->CastSpell(20146, $npc->GetID()) if !$npc->FindBuff(20146);
    }
    elsif ($timer eq "spawn_blight") {
        if ($npc->IsEngaged()) {
            my $loc = $blight_locs[int(rand(@blight_locs))];
            quest::spawn2(2188, 0, 0, $loc->{x}, $loc->{y}, $loc->{z}, $loc->{h});
        }
    }
    elsif ($timer eq "proximity_check") {
        my $nearby_count = 0;
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            next if $client->GetGM();
            my $distance = $npc->CalculateDistance(
                $client->GetX(),
                $client->GetY(),
                $client->GetZ()
            );
            if ($distance <= 100) {
                $nearby_count++;
            }
        }

        if ($nearby_count < 2) {
            quest::shout("The air grows still... the ritual collapses without enough souls present!");
            quest::depopzone(0);
            quest::stoptimer("proximity_check");
        }
    }
}

sub EVENT_HP {
    if ($hpevent == 25) {
        if (int(rand(100)) < 35) { # 35% chance
            quest::spawn2(2189, 0, 0, $mirror_x, $mirror_y, $mirror_z, $mirror_h);
        }
    }
}