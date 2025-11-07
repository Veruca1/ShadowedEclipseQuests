# ===========================================================
# Eastern Wastes Boss — Raid Scaled Encounter
# Shadowed Eclipse Standard Boss Logic
# - Uses custom tuned baseline
# - Applies RaidScaling after stat setup
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline Stats (from default.pl, tuned for this encounter) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 7000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 8500);
    $npc->ModifyNPCStat("max_hit", 11500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("runspeed", 2);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # Announce server-wide message upon spawn
    #quest::we(14, "Frostbane has sent me to destroy you all! You are lucky I'm not him. For the Coven!!!");

    # Set a timer to periodically check for buffs
    quest::settimer("check_buffs", 10); # Check every 10 seconds
    
    # Start a depop timer
    #quest::settimer("depop_check", 1800); # 1800 seconds = 30 minutes
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Only cast the buff if the NPC is not already buffed and not in combat
        if (!$npc->FindBuff(27376) && !$npc->IsEngaged()) {
            $npc->CastSpell(27376, $npc->GetID());
        }
        # Restart the timer
        quest::settimer("check_buffs", 10);
    }
    elsif ($timer eq "spawn_adds") {
        # Get NPC's current location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn 10 adds in a circle around the NPC
        for my $i (0..9) {
            my $angle = $i * (2 * 3.14159 / 10); # Divide 360 degrees into 10 parts
            my $add_x = $x + 10 * cos($angle);
            my $add_y = $y + 10 * sin($angle);
            quest::spawn2(1647, 0, 0, $add_x, $add_y, $z, $h);
        }
    }
    elsif ($timer eq "depop_check") {
        # Depop the NPC if it is not in combat
        if (!$npc->IsEngaged()) {
            quest::signalwith(1407, 1);
            quest::depop();	    
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat
        quest::settimer("spawn_adds", 25); # Spawn adds every 25 seconds
        
        # Reset the depop timer when combat starts
        quest::settimer("depop_check", 1800);
    }
    elsif ($combat_state == 0) {
        # NPC has left combat
        quest::stoptimer("spawn_adds");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Signal NPC ID 1407 (or any other handler) that this NPC has died
    quest::signalwith(1407, 1);
}