# ===========================================================
# 2215.pl - Tower of Shattered Lanterns
# Mini Boss 2 (Lantern Mini) Essence Logic
# ===========================================================

sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();

    my $client = plugin::GetKillerClient($npc, $entity_list);
    unless ($client) {
        return;
    }

    my $cid   = $client->CharacterID();
    my $name  = $client->GetCleanName();
    my $mob   = $npc->GetCleanName();
    my $m2key = "CONV_F1_Mini2215_${cid}";
    my $done  = quest::get_data($m2key) || 0;

    if (!$done) {
        quest::set_data($m2key, 1);
        $client->Message(13, "✨ You have absorbed the essence of Mini Boss 2215!");
    } else {
    }

    # ✅ Always call the plugin to check for key unlocks
    plugin::HandleEssence($npc, $client);
}