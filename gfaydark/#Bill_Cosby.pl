sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(0);

    $npc->ModifyNPCStat("level", 100);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 9000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 100000);
    $npc->ModifyNPCStat("max_hit", 200000);
    $npc->ModifyNPCStat("atk", 3000);
    $npc->ModifyNPCStat("accuracy", 1900);
    $npc->ModifyNPCStat("avoidance", 105);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 90);
    $npc->ModifyNPCStat("aggro", 57);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1100);
    $npc->ModifyNPCStat("int", 1100);
    $npc->ModifyNPCStat("cha", 900);

    $npc->ModifyNPCStat("mr", 350);
    $npc->ModifyNPCStat("fr", 350);
    $npc->ModifyNPCStat("cr", 350);
    $npc->ModifyNPCStat("pr", 350);
    $npc->ModifyNPCStat("dr", 350);
    $npc->ModifyNPCStat("corruption_resist", 400);
    $npc->ModifyNPCStat("physical_resist", 900);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "12,1^13,1^14,1^15,1^16,1^17,1^31,1^18,1^35,1^26,1^28,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^46,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my $forget_link = quest::silent_saylink("forget my spells and disciplines");
        my $teach_link = quest::silent_saylink("I can teach you a thing or two");
        quest::whisper("Greetings, $name! You can $forget_link or $teach_link?");
    } elsif ($text =~ /forget my spells and disciplines/i) {
        quest::whisper("You have chosen to forget all your spells and disciplines.");

        # Forget all spells
        quest::unscribespells();
        quest::untraindiscs();

        quest::whisper("Here you go, drink up.");
    } elsif ($text =~ /I can teach you a thing or two/i) {
        # Max out all skills the player can have
        $client->MaxSkills();

        # Scribe all spells from level 1 up to current level
        quest::scribespells($ulevel);

        # Train all disciplines from level 1 up to current level
        quest::traindiscs($ulevel);

        quest::whisper("All your skills, spells, and disciplines from level 1 to your current level have been learned.");
    }
}