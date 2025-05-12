sub EVENT_SIGNAL {
    if ($signal == 1) {
        my $xyron = $entity_list->GetMobByNpcTypeID(1266);
        if ($xyron && $xyron->IsEngaged()) {
            my $target = $xyron->GetHateTop();
            if ($target) {
                if ($target->IsClient() || $target->IsBot()) {
                    $npc->CastSpell(36836, $target->GetID());
                }
            }
        }
    }
}
