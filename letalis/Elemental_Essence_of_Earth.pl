use List::Util qw(max);

my $is_boss = 1;
my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # Boss stats
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 105500000);
    $npc->ModifyNPCStat("hp_regen", 1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 30000);
    $npc->ModifyNPCStat("max_hit", 60000);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);
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
    $npc->ModifyNPCStat("physical_resist", 1000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1^33,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Guaranteed loot
my $veru = plugin::verugems();
my @veru_ids = keys %$veru;
$npc->AddItem($veru_ids[int(rand(@veru_ids))], 1, 0);  # Not equipped

my $letal = plugin::botletal();
my @letal_ids = keys %$letal;
$npc->AddItem($letal_ids[int(rand(@letal_ids))], 1, 0);  # Not equipped

my $gear = plugin::ch6classgear();
my @gear_ids = map { @{$gear->{$_}} } keys %$gear;
$npc->AddItem($gear_ids[int(rand(@gear_ids))], 1, 0);  # Not equipped

# 🎲 30% chance at one of 45479, 45480, 45481
if (int(rand(100)) < 30) {
    my @bonus_ids = (45479, 45480, 45481);
    $npc->AddItem($bonus_ids[int(rand(@bonus_ids))], 1, 0);  # Not equipped
}

# 25% chance to add item ID 45477
if (int(rand(100)) < 25) {
    $npc->AddItem(45477, 1, 0);  # Not equipped
}

    # Depop in 30 minutes
    quest::settimer("depop", 30 * 60);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("avapower", 35); # Avatar Power
        quest::settimer("bury", 30);     # Bury
        quest::settimer("wave", 12);     # Earth Wave
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop();
    } elsif ($timer eq "avapower") {
        my $tgt = $npc->GetTarget();
        $npc->CastSpell(40777, $tgt->GetID()) if $tgt;
    } elsif ($timer eq "bury") {
        my $tgt = $npc->GetTarget();
        $npc->CastSpell(40763, $tgt->GetID()) if $tgt;
    } elsif ($timer eq "wave") {
        my $tgt = $npc->GetTarget();
        $npc->CastSpell(40764, $tgt->GetID()) if $tgt;
    }
}