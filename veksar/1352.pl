my $signal_count_1_8 = 0;
my $signal_count_10_15 = 0;
my $signal_count_20_23 = 0;

sub EVENT_SPAWN {
    # Set NPC 1352 to never depop
    quest::setnexthpevent(0);  # Makes it persistent (never depop)

    # Despawn any possible lingering NPCs from zone state
    my @npc_ids_to_check = (1402, 1404, 109108);
    foreach my $npcid (@npc_ids_to_check) {
        my $mob = $entity_list->GetNPCByNPCTypeID($npcid);
        $mob->Depop(1) if $mob;
    }
}

sub EVENT_SIGNAL {
    if ($signal == 30) {
        quest::shout("A menacing laughter echoes throughout the zone. All of this messing around with time will be Zarrin's undoing! Hahahaha!");
    }

    if ($signal >= 1 && $signal <= 8) {
        $signal_count_1_8++;
    }

    if ($signal_count_1_8 == 8) {
        my $npc_id = 1402;
        my $existing = $entity_list->GetNPCByNPCTypeID($npc_id);
        quest::spawn2($npc_id, 0, 0, 259.49, -506.31, -28.75, 491.50) unless $existing;
        $signal_count_1_8 = 0;
    }

    if ($signal >= 10 && $signal <= 15) {
        $signal_count_10_15++;
    }

    if ($signal_count_10_15 == 6) {
        my $npc_id = 1404;
        my $existing = $entity_list->GetNPCByNPCTypeID($npc_id);
        quest::spawn2($npc_id, 0, 0, 363.54, -123.73, -12.25, 122.50) unless $existing;
        $signal_count_10_15 = 0;
    }

    if ($signal >= 20 && $signal <= 23) {
        $signal_count_20_23++;
    }

    if ($signal_count_20_23 == 4) {
        my $npc_id = 109108;
        my $existing = $entity_list->GetNPCByNPCTypeID($npc_id);
        quest::spawn2($npc_id, 0, 0, -261.28, -483.97, 24.91, 2.50) unless $existing;
        $signal_count_20_23 = 0;
    }
}