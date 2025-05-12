sub EVENT_SPAWN {
    my @all_loot = (
        644, 1377, 1378, 1800, 1801, 1802, 2827, 2828, 2829, 2830,
        2854, 2855, 2856, 2857, 4038, 4039, 4040, 4041, 4042, 4043,
        4044, 4045, 4046, 4062, 4063, 4064, 4065, 4078, 4079, 4644,
        4645, 9538, 11010
    );

    quest::addloot(quest::ChooseRandom(@all_loot), 1);

    # 70% chance for 17726, 30% for 17728
    my $special_item = (rand() < 0.7) ? 17726 : 17728;
    quest::addloot($special_item, 1);
}

sub EVENT_DEATH_COMPLETE {
    return if int(rand(100)) >= 15; # 30% chance to spawn mimic

    my $killer_mob = $entity_list->GetMobByID($killer_id);
    my $client;

    if ($killer_mob) {
        if ($killer_mob->IsClient()) {
            $client = $killer_mob->CastToClient();
        } elsif ($killer_mob->IsPet() || $killer_mob->IsBot()) {
            my $owner = $killer_mob->GetOwner();
            $client = $owner->CastToClient() if $owner && $owner->IsClient();
        }
    }

    return unless $client;

    my %gear_by_material = (
        0 => [644, 4046, 4062, 4063, 4064, 4065, 4078, 4644, 4645, 9538, 11010],
        1 => [4039, 4040, 4041, 4042, 4043, 4044, 4045, 4644],
        2 => [2829, 2830, 2854, 2855, 2856, 2857, 4038, 4644, 9538],
        3 => [1377, 1378, 1800, 1801, 1802, 2827, 2828, 4644, 9538],
    );

    my %needed_materials;
    my $group = $entity_list->GetGroupByClient($client);

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member && ($member->IsClient() || $member->IsBot());

            my $class = $member->GetClass();
            if ($class =~ /^(1|3|5|7|9|10)$/)  { $needed_materials{3} = 1; }
            if ($class =~ /^(2|4|6|8)$/)       { $needed_materials{2} = 1; }
            if ($class == 11)                 { $needed_materials{1} = 1; }
            if ($class >= 12 && $class <= 16) { $needed_materials{0} = 1; }
        }
    } else {
        my $class = $client->GetClass();
        if ($class =~ /^(1|3|5|7|9|10)$/)  { $needed_materials{3} = 1; }
        if ($class =~ /^(2|4|6|8)$/)       { $needed_materials{2} = 1; }
        if ($class == 11)                 { $needed_materials{1} = 1; }
        if ($class >= 12 && $class <= 16) { $needed_materials{0} = 1; }
    }

    my @valid_loot_pool;
    foreach my $mat (keys %needed_materials) {
        push @valid_loot_pool, @{ $gear_by_material{$mat} };
    }

    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    my $spawn_id = quest::spawn2(501001, 0, 0, $x, $y, $z, $h);
    my $mimic = $entity_list->GetNPCByID($spawn_id);
    return unless $mimic;

    $mimic->ClearItemList();

    my $num_loot = quest::ChooseRandom(2, 3);
    for (1 .. $num_loot) {
        my $item = quest::ChooseRandom(@valid_loot_pool);
        $mimic->AddItem($item);
    }

    # 70% chance for 17726, 30% for 17728
    my $special_item = (rand() < 0.7) ? 17726 : 17728;
    $mimic->AddItem($special_item);

    $mimic->AddToHateList($client, 500);
}
