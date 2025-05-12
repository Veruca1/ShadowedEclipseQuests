sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::popup("Items of Temporal Flux",
            "Greetings, traveler. I have been sent back in time from the <c \"#F0D700\">Plane of Innovation</c> to assist in correcting the many <c \"#F0D700\">time anomalies</c> "
            . "that have been appearing due to the <c \"#F0D700\">Chronomancer's</c> meddlesome behavior. His manipulation of time has caused disruptions throughout the realms.<br><br>"
            . "During your journey, you may come across items in a state of <c \"#F0D700\">temporal flux</c>. These are items that exist both here and in other times, caught in the flow of time itself.<br><br>"
            . "I need you to bring such items back to me for further study. However, be aware, some of these items may be <c \"#F0D700\">attracted</c> to similar objects in our time.<br><br>"
            . "By <c \"#F0D700\">fusing</c> them together, you may be able to create something far more valuable. Proceed with caution, but know that the rewards could be <c \"#F0D700\">lucrative</c>.");
    }
}

sub EVENT_ITEM {
    my $wrist_turn_in_item = 31709;                   # General flux item
    my $helm_turn_in_item = 31712;
    my $melee_arm_turn_in_item = 32353;
    my $caster_arm_turn_in_item = 32354;
    my $caster_glove_turn_in_item = 32472;
    my $melee_glove_turn_in_item = 32469;
    my $caster_shoe_turn_in_item = 32473;
    my $melee_boots_turn_in_item = 32474;
    my $int_caster_pants_turn_in_item = 33110;
    my $chain_and_leather_pants_turn_in_item = 33111;
    my $plate_pants_turn_in_item = 33112;

    my %wrist_reward = (
        147814 => 600083, 147835 => 600084, 147856 => 600085, 147877 => 600086,
        147898 => 600087, 147919 => 600088, 147940 => 600089, 147961 => 600090,
        147982 => 600091, 148003 => 600092, 148024 => 600093, 147796 => 600094,
        147709 => 600095, 147730 => 600096, 147754 => 600097, 147772 => 600098,
    );
    my %helm_reward = (
        147715 => 32266, 147736 => 32267, 147763 => 32268, 147778 => 32269,
        147802 => 32270, 147823 => 32255, 147844 => 32256, 147865 => 32261,
        147886 => 32257, 147907 => 32262, 147928 => 32263, 147949 => 32264,
        147970 => 32265, 147991 => 32258, 148012 => 32259, 148033 => 32260,
    );

    my %caster_arm_reward = (
        147751 => 32381, 147826 => 32355, 147847 => 32356, 147868 => 32357,
        147889 => 32358, 147910 => 32359, 148015 => 32376, 148036 => 32377,
    );

    my %melee_arm_reward = (
        147727 => 32379, 147748 => 32380, 147787 => 32452, 147811 => 32378,
        147931 => 32360, 147952 => 32361, 147973 => 32374, 147994 => 32375,
    );

    my %caster_glove_reward = (
        147817 => 32485, 147838 => 32486, 147859 => 32487, 147880 => 32488,
        147901 => 32489, 148006 => 33001, 148027 => 33002, 147757 => 33006,
    );

    my %melee_glove_reward = (
        147922 => 32490, 147943 => 32532, 147964 => 32533, 147985 => 33000,
        147808 => 33003, 147724 => 33004, 147745 => 33005, 147784 => 33007,
    );

    my %caster_shoe_reward = (
        147820 => 33008, 147841 => 33009, 147862 => 33010, 147883 => 33011,
        147904 => 33012, 148009 => 33013, 148030 => 33014, 147760 => 33022,
    );

    my %melee_boots_reward = (
        147925 => 33015, 147946 => 33016, 147967 => 33017, 147988 => 33018,
        147799 => 33019, 147712 => 33020, 147733 => 33021, 147775 => 33023,
    );

    my %int_caster_pants_reward = (
        147829 => 33168, 147850 => 33169, 147871 => 33170, 147892 => 33171,
    );

    my %chain_and_leather_pants_reward = (
        147913 => 33161, 147934 => 33162, 147955 => 33163, 147976 => 33164,
        147997 => 33165, 148018 => 33166, 148039 => 33167,
    );

    my %plate_pants_reward = (
        147805 => 33172, 147718 => 33173, 147739 => 33174,
        147766 => 33175, 147781 => 33176,
    );

    # Custom combine: 28366 + 33105 = 33106 (Aegis of Burning Hate +2)
    if (plugin::check_handin(\%itemcount, 28366 => 1, 33105 => 1)) {
        quest::summonitem(33106);
        $client->Message(14, "The items resonate with each other and fuse into something far more powerful.");
        quest::exp(2500);
        quest::ding();
        return;
    }

    # Custom combine: Grand Ornate Bow of Flux + Cursed Flame +2 = Cursed Flame +3
    if (plugin::check_handin(\%itemcount, 257 => 1, 28624 => 1)) {
        quest::summonitem(261);  # Cursed Flame +3
        $client->Message(14, "The flames intensify as the bow absorbs the cursed energy.");
        quest::exp(3000);
        quest::ding();
        return;
    }

    # Universal check logic
   foreach my $item_id (keys %helm_reward) {
    if (plugin::check_handin(\%itemcount, $helm_turn_in_item => 1, $item_id => 1)) {
        quest::summonitem($helm_reward{$item_id});
        $client->Message(14, "Here is your helm reward!");
        quest::exp(1000);
        quest::ding();
        return;
    }
}

 foreach my $item_id (keys %wrist_reward) {
        if (plugin::check_handin(\%itemcount, $wrist_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($wrist_reward{$item_id});
            $client->Message(14, "Here is your wrist reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %caster_arm_reward) {
        if (plugin::check_handin(\%itemcount, $caster_arm_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($caster_arm_reward{$item_id});
            $client->Message(14, "Here is your caster arm reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %melee_arm_reward) {
        if (plugin::check_handin(\%itemcount, $melee_arm_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($melee_arm_reward{$item_id});
            $client->Message(14, "Here is your melee arm reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %caster_glove_reward) {
        if (plugin::check_handin(\%itemcount, $caster_glove_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($caster_glove_reward{$item_id});
            $client->Message(14, "Here is your caster glove reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %melee_glove_reward) {
        if (plugin::check_handin(\%itemcount, $melee_glove_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($melee_glove_reward{$item_id});
            $client->Message(14, "Here is your melee glove reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %caster_shoe_reward) {
        if (plugin::check_handin(\%itemcount, $caster_shoe_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($caster_shoe_reward{$item_id});
            $client->Message(14, "Here is your caster shoe reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %melee_boots_reward) {
        if (plugin::check_handin(\%itemcount, $melee_boots_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($melee_boots_reward{$item_id});
            $client->Message(14, "Here is your melee boots reward!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %int_caster_pants_reward) {
        if (plugin::check_handin(\%itemcount, $int_caster_pants_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($int_caster_pants_reward{$item_id});
            $client->Message(14, "Here are your caster pants!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %chain_and_leather_pants_reward) {
        if (plugin::check_handin(\%itemcount, $chain_and_leather_pants_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($chain_and_leather_pants_reward{$item_id});
            $client->Message(14, "Here are your chain/leather pants!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    foreach my $item_id (keys %plate_pants_reward) {
        if (plugin::check_handin(\%itemcount, $plate_pants_turn_in_item => 1, $item_id => 1)) {
            quest::summonitem($plate_pants_reward{$item_id});
            $client->Message(14, "Here are your plate pants!");
            quest::exp(1000);
            quest::ding();
            return;
        }
    }

    plugin::return_items(\%itemcount);
}
