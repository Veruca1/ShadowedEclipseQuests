sub EVENT_ITEM {
    my %to_2hander = (
        # SK conversions
        27622  => 41142,
        600071 => 41143,
        600072 => 41144,
        600073 => 41145,
        600390 => 41146,

        # PAL conversions
        27621  => 41147,
        600068 => 41148,
        600069 => 41149,
        600070 => 41150,
    );

    my %to_1hander = reverse %to_2hander;

    foreach my $item_id (keys %to_2hander) {
        if (plugin::check_handin(\%itemcount, $item_id => 1)) {
            quest::summonitem($to_2hander{$item_id});
            quest::say("Here is your two-handed version. Use it wisely.");
            return;
        }
    }

    foreach my $item_id (keys %to_1hander) {
        if (plugin::check_handin(\%itemcount, $item_id => 1)) {
            quest::summonitem($to_1hander{$item_id});
            quest::say("Here is your one-handed version. Use it wisely.");
            return;
        }
    }

    plugin::return_items(\%itemcount);
}