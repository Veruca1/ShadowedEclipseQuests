# zone_controller.pl

sub EVENT_SPAWN {
    # Depop existing instance to avoid duplication on zone resume
    my $existing = $entity_list->GetNPCByNPCTypeID(1352);
    $existing->Depop(1) if $existing;

    quest::spawn2(1352, 0, 0, 329.57, -1780.87, 303.47, 176.75);
}