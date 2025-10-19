 my $is_boss         = 0;
my $checked_mirror  = 0;

my @reflected_loot = ();

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $is_boss = ($raw_name =~ /^#/ || $raw_name =~ /Bertoxxulous/i) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    if ($is_boss) {
        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 250000000);
        $npc->ModifyNPCStat("hp_regen", 3000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 65000);
        $npc->ModifyNPCStat("max_hit", 85000);
        $npc->ModifyNPCStat("atk", 2500);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 75);
        $npc->ModifyNPCStat("attack_delay", 5);
        $npc->ModifyNPCStat("heroic_strikethrough", 36);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        # Attributes
        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        # Resists
        $npc->ModifyNPCStat("mr", 400);
        $npc->ModifyNPCStat("fr", 400);
        $npc->ModifyNPCStat("cr", 400);
        $npc->ModifyNPCStat("pr", 900);
        $npc->ModifyNPCStat("dr", 900);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        # Traits
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);
        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^12,1^13,1^14,1^15,1^17,1^21,1");
        plugin::RaidScaling($entity_list, $npc);
    }

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    quest::setnexthpevent(35);
}

sub EVENT_COMBAT {
    my ($combat_state) = @_;

    if ($combat_state == 1) {
        quest::settimer("OOBcheck", 6000);
        $checked_mirror = 0;
    } else {
        quest::stoptimer("OOBcheck");
        $checked_mirror = 0;
    }
}

sub EVENT_TIMER {
    my ($timer) = @_;

    if ($timer eq "OOBcheck") {
        quest::stoptimer("OOBcheck");

        if ($npc->GetX() < 1800) {
            $npc->GotoBind();
            $npc->WipeHateList();
        } else {
            quest::settimer("OOBcheck", 6000);
        }
    }
}