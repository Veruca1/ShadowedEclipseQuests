sub EVENT_SPAWN {
    quest::setnexthpevent(75);
    $npc->ScaleNPC($npc->GetLevel(),1); # This will now scale the NPC's stats per the npc_scale_global_base table
    $npc->ModifyNPCStat("max_hp", $npc->GetMaxHP() *2); # If we want more HP
    $npc->SetHP($npc->GetMaxHP());
    $npc->ModifyNPCStat("min_hit", $npc->GetMinDMG() + 2500);
    $npc->ModifyNPCStat("max_hit", $npc->GetMaxDMG() + 500);
    $npc->ModifyNPCStat($_, 1000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
    $npc->ModifyNPCStat($_, 110) for ("cr", "dr", "fr", "mr", "pr", "phr");
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("avoidance", 30);
    $npc->ModifyNPCStat("ATK", 950);
    $npc->ModifyNPCStat("Accuracy", 950);
    $npc->SetSpecialAbility(2, 1);  # Enrage
    $npc->SetSpecialAbility(3, 1);  # Rampage
    $npc->SetSpecialAbility(5, 1);  # Flurry
    $npc->SetSpecialAbility(7, 1);  # Quad Attack
    $npc->SetSpecialAbility(13, 1); # Unmezable
    $npc->SetSpecialAbility(14, 1); # Uncharmable
    $npc->SetSpecialAbility(16, 1); # Unsnareable
    $npc->SetSpecialAbility(17, 1); # Unfearable
    $npc->SetSpecialAbility(18, 1); # Immune to Dispel
    $npc->SetSpecialAbility(21, 1); # Immune to Fleeing
    $npc->SetSpecialAbility(31, 1); # Unpacifiable

}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("Charm", 180); # Set charm timer to 3 minutes
    } elsif ($combat_state == 0) {
        quest::stoptimer("Charm");
    }
}

sub EVENT_TIMER {
    if ($timer eq "Charm") {
        quest::stoptimer("Charm");
        my $charm_ent = $npc->GetHateRandom();
        $npc->CastSpell(912, $charm_ent->GetID(), 22, -1, -1, 10000);
        if ($charm_ent->IsClient()) {
            plugin::ClientMessage($charm_ent, "VhalSera permeates your psyche, luring you to its bidding.");
        }
        quest::settimer("Charm", 180); # Restart timer after 3 minutes
    }
}

sub EVENT_DEATH_COMPLETE {
    my $chance = quest::ChooseRandom(1..100);
    if ($chance ~~ [1..15]) {
        plugin::ZoneAnnounce("YOU THOUGHT YOU COULD DESTROY ME? I AM ETERNAL!");
        quest::spawn2(1823, 1, 0, $x, $y, $z, $h);
    } elsif ($chance ~~ [46..100]) {
        plugin::ZoneAnnounce("VhalSera is no more! The cold, lifeless form lies in undisturbed tranquility.");
    }
}
