# ===========================================================
# Floor 1 Trash Essence Logic
# ===========================================================

sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();

    my $client = plugin::GetKillerClient($npc, $entity_list);
    unless ($client) {
        return;
    }

    my $cid = $client->CharacterID();
    my $ess = "CONV_F1_EssenceCount_${cid}";
    my $count = quest::get_data($ess) || 0;

    if ($count < 50) {
        $count++;
        quest::set_data($ess, $count);
        $client->Message(15, "You have gathered an essence of Floor 1 [$count/50]");
        plugin::HandleEssence($npc, $client);

    }
}