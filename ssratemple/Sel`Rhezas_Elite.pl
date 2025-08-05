my $checked_dark_reflection = 0; # Tracks if we've already checked this fight

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Apply base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 20000000); 
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 20000);
    $npc->ModifyNPCStat("max_hit", 40000);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 25);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 500);
    $npc->ModifyNPCStat("fr", 500);
    $npc->ModifyNPCStat("cr", 500);
    $npc->ModifyNPCStat("pr", 500);
    $npc->ModifyNPCStat("dr", 500);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Default tint (white)
    quest::settimer("apply_tint", 1);
}

sub EVENT_COMBAT {
    my ($combat_state) = @_;
    if ($combat_state == 1) { # Engaged
        $checked_dark_reflection = 0; # Reset per fight
        quest::settimer("check_dark_reflection", 2); # Check every 2 seconds until triggered
    } elsif ($combat_state == 0) { # Disengaged
        quest::stoptimer("check_dark_reflection");
    }
}

sub EVENT_TIMER {
    if ($timer eq "apply_tint") {
        quest::stoptimer("apply_tint");
        $npc->SetNPCTintIndex(0); # White tint default
    }
    elsif ($timer eq "check_dark_reflection") {
        return if $checked_dark_reflection;

        my $hp_pct = $npc->GetHPRatio() || 0;

        if ($hp_pct <= 75 && $hp_pct >= 25) {
            my $target = $npc->GetHateTop();
            if ($target && $target->IsClient()) {
                # Check if player has the debuff spell 40778
                if ($target->FindBuff(40778)) {
                    if (int(rand(100)) < 50) {
                        $npc->SetNPCTintIndex(30); # Change to black tint
                        $target->Message(15, "The black mirror turns… and your shadow steps forward.");
                    }
                }
            }
            $checked_dark_reflection = 1;
            quest::stoptimer("check_dark_reflection"); # Stop further checks
        }
    }
}