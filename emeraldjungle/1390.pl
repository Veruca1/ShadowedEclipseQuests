sub EVENT_SPAWN {
    $npc->SetEntityVariable("parry_triggered", 0);
    $npc->SetEntityVariable("chrono_fury_triggered", 0);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("chrono_fury", 120);
    } else {
        quest::stoptimer("chrono_fury");
    }
}

sub EVENT_TIMER {
    if ($timer eq "chrono_fury") {
        if (!$npc->GetEntityVariable("chrono_fury_triggered")) {
            $npc->SetEntityVariable("chrono_fury_triggered", 1);
            quest::emote("becomes furious, attacking even faster as time presses in!");
            $npc->ModifyNPCStat("attack_speed", "-40");  # Increase attack speed by 40%
            $npc->ModifyNPCStat("damage", "50");  # Increase base damage
        }
    }
}

sub EVENT_HP {
    if ($npc->GetHPRatio() <= 50 && !$npc->GetEntityVariable("parry_triggered")) {
        $npc->SetEntityVariable("parry_triggered", 1);
        quest::emote("gains a temporal awareness, preparing to parry incoming strikes!");
        $npc->ModifyNPCStat("parry", "200");  # Increase parry value
        quest::settimer("remove_parry", 10);  # Set timer to remove parry after 10 seconds
    }
    
    if ($npc->GetHPRatio() <= 30) {
        quest::settimer("heal", 10);  # Heal every 10 seconds if below 30% health
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_parry") {
        $npc->ModifyNPCStat("parry", "0");
        quest::stoptimer("remove_parry");
    }

    if ($timer eq "heal") {
        $npc->SetHP($npc->GetHP() + 500);  # Heal for 500 HP
        quest::emote("regains some strength!");
    }
}

sub EVENT_DEATH {
    quest::stoptimer("chrono_fury");
    quest::stoptimer("remove_parry");
    quest::stoptimer("heal");
}
