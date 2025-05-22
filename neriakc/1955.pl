sub EVENT_SPAWN {
    my $main_item = 39671;
    my $bonus_item = 40454;

     quest::shout("Catch me if you can!");

    # Always add one of the main item
    $npc->AddItem($main_item);

    # 10% chance to add a second copy
    if (int(rand(100)) < 25) {
        $npc->AddItem($main_item);
    }

    # 25% chance to add a third copy
    if (int(rand(100)) < 10) {
        $npc->AddItem($main_item);
    }

    # 10% chance to add one bonus item
    if (int(rand(100)) < 10) {
        $npc->AddItem($bonus_item);
    }
}