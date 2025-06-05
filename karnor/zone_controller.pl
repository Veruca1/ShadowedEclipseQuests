sub EVENT_SPAWN {
    # Spawn NPC 1427 at the specified location and heading
    my $existing = $entity_list->GetNPCByNPCTypeID(1427);
    $existing->Depop(1) if $existing;

    quest::spawn2(1427, 0, 0, -501.12, -77.05, 31.80, 383.00);
}