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
    if ($text=~/hail/i) {
        my $char_id = $client->CharacterID();
        my $flag_key = "${char_id}_shadeweaver_flag";

        quest::popup(
            "Echoes Beyond the Void",
            "You stand at the <c \"#9900CC\">end of all things</c>. This place—<c \"#CC00CC\">The Void</c>—is not just forgotten by time... it exists outside of it.<br><br>" .
            "The <c \"#99CCFF\">Lunar Shard</c> that brought you here... <c \"#FF99FF\">you’ve felt it, haven’t you?</c> That subtle hum in your pack? That pull toward something greater, something inevitable? That shard is a remnant of a battle long hidden—a last spark stolen from the corpse of dying divinity.<br><br>" .
            "All around you lie the remnants of <c \"#FF6666\">gods</c>, <c \"#9999FF\">planes</c>, and <c \"#CCCCCC\">forgotten ages</c>. But even in this stillness... forces gather.<br><br>" .
            "Soon, you will be asked to step through a breach to <c \"#FFCC66\">Luclin</c>, a shattered moon steeped in shadow. There, one of <c \"#990000\">Nyseria's</c> most powerful allies stirs: <c \"#CC6666\">Sel’Rheza</c>, master of illusory magic and the architect of a quiet doom.<br><br>" .
            "They are not alone. Whispers speak of <c \"#9966FF\">Lord Seru</c>, <c \"#996666\">Grieg</c>, and worse—twisted echoes of what once was. Entire regions have begun to fracture, revealing terrifying <c \"#9933FF\">mirrored versions</c> of familiar places.<br><br>" .
            "<c \"#660066\">The Mistress of Shadows</c> watches. <c \"#CC00CC\">She knows</c> of your intrusion. She <c \"#FF3399\">does not yet approve</c>... but she is curious. Tread carefully, adventurer. The eyes of a goddess are upon you.",
            1
        );

        if (!quest::get_data($flag_key)) {
            quest::set_zone_flag(165); # Zone ID for Shadeweaver's Thicket
            quest::set_data($flag_key, 1);
            quest::we(15, "$name has earned access to The Shadeweaver's Thicket.");
            quest::whisper("You have been granted access to the Shadeweaver`s Thicket beyond the breach. May your steps be silent, and your mind sharp.");
        } else {
            quest::whisper("You have already been granted access to the the Shadeweaver`s Thicket. There is nothing more for you here.");
        }
    }
}