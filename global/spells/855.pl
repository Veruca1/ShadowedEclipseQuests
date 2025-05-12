sub EVENT_SPELL_EFFECT_CLIENT {
    if ($client) {
        quest::MovePCInstance(89, $instanceid, -117, -1283, -175, 46);
    }
}
