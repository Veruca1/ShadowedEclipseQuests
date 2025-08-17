# Global flag to track if mirror logic has already been triggered
my $checked_mirror = 0;
my $mirror_trigger_hp = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Base stats and combat config
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 90000000); 
    $npc->ModifyNPCStat("hp_regen", 500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 25000);
    $npc->ModifyNPCStat("max_hit", 70000);
    $npc->ModifyNPCStat("atk", 1500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 17);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Stat attributes
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # Resistances
    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # Visibility and special traits
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    $npc->SetHP($npc->GetMaxHP());
    $checked_mirror = 0;
    quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        $checked_mirror = 0;
        quest::stoptimer("mirror_check");
    }
}

sub EVENT_HP {
    if ($hpevent == 80 && !$checked_mirror) {
        $mirror_trigger_hp = int(rand(69)) + 11;
        quest::settimer("mirror_check", 5);
    }
}

sub EVENT_TIMER {
    if ($timer eq "mirror_check") {
        return if $checked_mirror;

        my $hp_pct = int($npc->GetHPRatio());
        return if $hp_pct < 10 || $hp_pct > $mirror_trigger_hp;

        my $found_client = 0;
        my @clients = $entity_list->GetClientList();

        foreach my $client (@clients) {
            next unless $client && $client->GetHP() > 0;

            my $item = $client->GetItemAt(22);  # Ammo slot
            my $item_id = $item ? $item->GetID() : 0;
            my $has_mirror = ($item_id == 49764);

            my $buff_slot = $client->FindBuff(40778);
            my $has_buff = ($buff_slot != -1);

            next unless $has_mirror && $has_buff;
            $found_client = 1;

            my $roll = int(rand(100));
            if ($roll < 25) {
                quest::shout("The mirror cracks... and something darker stirs.");
                quest::settimer("mirror_tint", 1);  # Tint effect delay

                my $new_hp     = int($npc->GetMaxHP() * 1.5);
                my $new_min    = int($npc->GetMinDMG() * 1.5);
                my $new_max    = int($npc->GetMaxDMG() * 1.5);
                my $new_atk    = int($npc->GetATK() * 1.5);
                my $new_hstrik = int($npc->GetNPCStat("heroic_strikethrough") || 0) + 1;

                $npc->ModifyNPCStat("max_hp", $new_hp);
                $npc->ModifyNPCStat("min_hit", $new_min);
                $npc->ModifyNPCStat("max_hit", $new_max);
                $npc->ModifyNPCStat("atk", $new_atk);
                $npc->ModifyNPCStat("attack_delay", 5);
                $npc->ModifyNPCStat("heroic_strikethrough", $new_hstrik);
                $npc->SetHP($npc->GetMaxHP());

                # Cast Mirror Transformation Buff if not already active
                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

                # --- Add title on transform ---
                my $base_name = $npc->GetCleanName();
                my $title_tag = "the Reflected";
                my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
                $npc->TempName($new_name);
                $npc->ModifyNPCStat("lastname", "Reflected");
                # --- end title ---
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }

        if (!$found_client) {
            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
        }
    }

    elsif ($timer eq "mirror_tint") {
        quest::stoptimer("mirror_tint");
        $npc->SetNPCTintIndex(30);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(2182, 0, 0, -148.74, -745.93, -255.94, 94.50);
}