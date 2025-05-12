sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Retrieve Xyron (ID: 1266)
        my $xyron = $entity_list->GetMobByNpcTypeID(1266);

        # Check if Xyron is valid and engaged
        if ($xyron && $xyron->IsEngaged()) {
            # Check if Envy is engaged
            if ($npc->IsEngaged()) {
                # Cast Envious Restoration on Xyron
                $npc->CastSpell(36839, $xyron->GetID());
            }
        }
    }
}
