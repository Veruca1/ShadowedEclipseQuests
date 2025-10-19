# ===========================================================
# 2214.pl - Tower of Shattered Lanterns
# Mini Boss 1 (Lantern Mini) Essence Logic
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
    my $m1key = "CONV_F1_Mini2214_${cid}";
    my $done  = quest::get_data($m1key) || 0;

    if (!$done) {
        quest::set_data($m1key, 1);
        $client->Message(13, "✨ You have absorbed the essence of Mini Boss 2214!");
    } else {
    }

    # ✅ Always call the plugin to check for key unlocks
    plugin::HandleEssence($npc, $client);
}