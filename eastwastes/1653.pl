sub EVENT_SPAWN {
    # Add all players in the zone to the hate list
    my @players = $entity_list->GetClientList();
    foreach my $player (@players) {
        $npc->AddToHateList($player, 1, 1000);  # Add hate to each player in the zone
    }
}
