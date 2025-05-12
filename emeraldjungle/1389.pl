sub EVENT_SPAWN {
    $npc->SetEntityVariable("evasive_triggered", 0);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("vanish_backstab", 3);  # Vanish every 3 seconds
    } else {
        quest::stoptimer("vanish_backstab");
    }
}

sub EVENT_TIMER {
    if ($timer eq "vanish_backstab") {
        my $target = $entity_list->GetRandomClientInZone();
        if ($target) {
            $npc->GMMove($target->GetX(), $target->GetY(), $target->GetZ(), $target->GetHeading());
            quest::emote("vanishes and reappears behind $target_name!");
            $npc->CastSpell(36878, $target->GetID());  # Backstab spell ID
            # Increase backstab damage
            quest::modifynpcstat("backstab_damage", "1000");  # Set higher backstab damage
        }
    }
}

sub EVENT_HP {
    if ($npc->GetHPRatio() <= 20 && !$npc->GetEntityVariable("evasive_triggered")) {
        $npc->SetEntityVariable("evasive_triggered", 1);
        quest::emote("adopts a more dangerous fighting style, landing critical hits more frequently!");
        $npc->ModifyNPCStat("crit_chance", "70");  # Increase crit chance to 70%
        quest::settimer("remove_evasive", 10);
    }
}

sub EVENT_TIMER {
    if ($timer eq "remove_evasive") {
        $npc->ModifyNPCStat("crit_chance", "0");
        quest::stoptimer("remove_evasive");
    }
}

sub EVENT_DEATH {
    quest::stoptimer("vanish_backstab");
    quest::stoptimer("remove_evasive");
}
