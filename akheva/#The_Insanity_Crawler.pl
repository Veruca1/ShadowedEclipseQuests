my $last_target_id;
my $last_target_name;

sub EVENT_SPAWN {
    return unless defined $npc;

    $npc->AddNimbusEffect(466);

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
    $npc->ModifyNPCStat("mr", 500);
    $npc->ModifyNPCStat("fr", 500);
    $npc->ModifyNPCStat("cr", 500);
    $npc->ModifyNPCStat("pr", 500);
    $npc->ModifyNPCStat("dr", 500);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 1000);
    $npc->ModifyNPCStat("runspeed", 0);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    my @buffs = (5278, 5297, 5488, 10028, 10031, 10013, 10664, 9414, 300, 15031, 2530, 20147);
    foreach my $spell_id (@buffs) {
        $npc->ApplySpellBuff($spell_id);
    }
}

sub EVENT_ATTACK {
    my $target = $npc->GetTarget();
    if (defined $target) {
        $last_target_id = $target->GetID();
        $last_target_name = $target->GetCleanName();
    }
}

sub EVENT_NPC_SLAY {
    my $victim = shift;

    my $victim_id;
    my $victim_name;
    my $is_pet = 0;
    my $is_bot = 0;
    my $owner_name = "Unknown";
    my $owner_id;

    # Attempt to recover victim if undefined
    if (!defined $victim && defined $last_target_id) {
        $victim_id = $last_target_id;
        $victim_name = $last_target_name;
    } elsif (!defined $victim) {
        my $top = $npc->GetHateTop();
        if ($top) {
            $victim = $top;
            $victim_id = $top->GetID();
            $victim_name = $top->GetCleanName();
        }
    } else {
        $victim_id = $victim->GetID();
        $victim_name = $victim->GetCleanName();
    }

    # Detect if victim is pet or bot and get owner
    if (defined $victim) {
        if ($victim->IsPet()) {
            $is_pet = 1;
            my $owner = $victim->GetOwner();
            if ($owner) {
                $owner_name = $owner->GetCleanName();
                $owner_id = $owner->GetID();
            }
        } elsif ($victim->IsBot()) {
            $is_bot = 1;
            my $owner = $entity_list->GetBotOwnerByBot($victim);
            if ($owner) {
                $owner_name = $owner->GetCleanName();
                $owner_id = $owner->GetID();
            }
        }
    }

    # Spawn adds regardless of victim
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    quest::spawn2(179136, 0, 0, $x - 10, $y, $z, $h);
    quest::spawn2(179136, 0, 0, $x + 10, $y, $z, $h);
    quest::spawn2(179136, 0, 0, $x, $y - 10, $z, $h);
    quest::spawn2(179136, 0, 0, $x, $y + 10, $z, $h);
    quest::spawn2(179136, 0, 0, $x, $y + 15, $z, $h);
}