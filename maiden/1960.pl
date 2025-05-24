sub EVENT_SPAWN {
    # Permanently invulnerable, still attackable
    $npc->SetInvul(1);
}

sub EVENT_SPELL_EFFECT_NPC {
    my $debuff_id = 40732;

    if ($spell_id == $debuff_id) {
        quest::set_data("wmu_has_debuff_$npcid", 1);
        plugin::wmu_check_all_debuffed();
    }
}

sub EVENT_SPELL_EFFECT_FADE {
    my $debuff_id = 40732;

    if ($spell_id == $debuff_id) {
        quest::set_data("wmu_has_debuff_$npcid", 0);
        plugin::wmu_check_all_debuffed();
    }
}