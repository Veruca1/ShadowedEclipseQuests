# ===========================================================
# Tunare.pl — Wakening Lands
# Shadowed Eclipse Encounter: Tunare, The Reborn Aspect
# - Uses Wakening Lands boss baseline stats
# - Applies RaidScaling for adaptive difficulty
# - Includes HP-event shouts and Nature Blast pulse
# ===========================================================

my $shout_75 = 0;
my $shout_50 = 0;
my $shout_25 = 0;
my $depop_triggered = 0; # Ensures depop only happens once

# ===========================================================
# On Spawn — Apply Wakening Lands Boss Baseline + RaidScaling
# ===========================================================
sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline (from wakening default.pl) ===
    $npc->SetNPCFactionID(623);

    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 1800000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 7700);
    $npc->ModifyNPCStat("max_hit", 8700);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes / Resists
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

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply Raid Scaling (adaptive to raid size) ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

# ===========================================================
# Combat Logic — HP Events, Shouts, and Depop Triggers
# ===========================================================
sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("nature_blast", 50); # Timer for Nature Blast before depop
        quest::settimer("life_drain", 35);   # Optional: for another timed ability
        quest::settimer("drain_message", 35);# Optional: message sync with life drain

        # HP Events for Shouts and Depop
        $shout_75 = 0;
        $shout_50 = 0;
        $shout_25 = 0;
        $depop_triggered = 0;
        quest::setnexthpevent(75);
    }
    elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("nature_blast");
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_HP {
    my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

    if ($hpevent == 75 && !$shout_75) {
        quest::shout("The Coven has shown me the true path. The Plane of Growth no longer serves the weak. It is time for a new order.");
        $shout_75 = 1;
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50 && !$shout_50) {
        quest::shout("The Mother of All has been deceived for too long. I am the one who will reshape this realm, and you will not stop me.");
        $shout_50 = 1;
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25 && !$shout_25) {
        quest::shout("The Arm will rise, and the Plane of Growth will serve the Coven. There is no turning back now. This is the will of Nyseria.");
        $shout_25 = 1;
        quest::setnexthpevent(15);
    }
    elsif ($hpevent == 15 && !$depop_triggered) {
        quest::shout("The world is already shifting. You cannot undo what has been set in motion. Farewell, mortals. You will understand in time.");
        quest::spawn2(1753, 0, 0, $x + 5, $y, $z, $h); # Left Bramble Thorn
        quest::spawn2(1753, 0, 0, $x - 5, $y, $z, $h); # Right Bramble Thorn
        quest::depop();
        $depop_triggered = 1;
    }
}

# ===========================================================
# Nature Blast (AOE pulse)
# ===========================================================
sub EVENT_TIMER {
    if ($timer eq "nature_blast") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50; # Effect range
        my $damage_amount = 20000;

        # Clients
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        # Bots
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        # Pets (clients + bots)
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
    }
}