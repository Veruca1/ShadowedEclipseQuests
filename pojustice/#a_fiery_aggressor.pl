# ===============================================================
# Plane of Justice — General Trash Mob Stat & Behavior Template
# ===============================================================
# - Applies standardized trash mob stats across PoJustice.
# - Avoids automatic boss detection (e.g., names starting with "#").
# - Hardcoded stats directly from SE's plugin definitions for trash.
# - Sets PoJustice faction and ensures consistent power scaling.
# - Movement timer and positioning logic included (optional).
# ===============================================================
# Designed for use with standard trash NPCs only. Do not use for:
# - Event controllers
# - Bosses or mini-bosses
# - Named or flagged progression targets
# ===============================================================

my $scaled_spawn = 0;

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();

    # Set PoJustice faction
    $npc->SetNPCFactionID(623);

    # Set default level
    $npc->ModifyNPCStat("level", 63);

    # Trash Stats (from plugin definition)
    $npc->ModifyNPCStat("ac",        22000);
    $npc->ModifyNPCStat("max_hp",    20000000);
    $npc->ModifyNPCStat("hp_regen",  1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   45000);
    $npc->ModifyNPCStat("max_hit",   58000);
    $npc->ModifyNPCStat("atk",       2400);
    $npc->ModifyNPCStat("accuracy",  1900);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 30);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("aggro", 100);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1050);
    $npc->ModifyNPCStat("sta", 1050);
    $npc->ModifyNPCStat("agi", 1050);
    $npc->ModifyNPCStat("dex", 1050);
    $npc->ModifyNPCStat("wis", 1050);
    $npc->ModifyNPCStat("int", 1050);
    $npc->ModifyNPCStat("cha", 850);

    $npc->ModifyNPCStat("mr", 320);
    $npc->ModifyNPCStat("fr", 320);
    $npc->ModifyNPCStat("cr", 320);
    $npc->ModifyNPCStat("pr", 320);
    $npc->ModifyNPCStat("dr", 320);

    $npc->ModifyNPCStat("corruption_resist", 350);
    $npc->ModifyNPCStat("physical_resist",   850);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");

    # Force HP to max after stat change
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Optional Movement
    quest::settimer("pos_check", 1);
    quest::moveto(880, -728, 55, 0, 1);
}

sub EVENT_SIGNAL {
	if ($signal == 1) {
		quest::depop();
	}
}

sub EVENT_TIMER {
	if ($timer eq "pos_check") {
		quest::stoptimer("pos_check");
		if (($x == 880) && ($y == -728)) {
			quest::settimer("kill_me_or_lose", 60);
		}
		else {
			quest::settimer("pos_check", 1);
		}
	}
	
	elsif($timer eq "kill_me_or_lose") {
		quest::stoptimer("kill_me_or_lose");
		quest::signalwith(201417, 2, 5); # NPC: #Event_Burning_Control
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::stoptimer("kill_me_or_lose");
}