sub EVENT_SAY {
    if ($text =~ /hail/i) {
        my %aa_rewards = (
            18000 => "Experienced Rebirther granted - you gain a 25%% experience bonus.",
            18001 => "Gelid Nimbus unlocked - your attacks may now unleash frost damage.",
            18002 => "Pyro Nimbus unlocked - your damage shield power increases.",
            18003 => "Hardened Veteran unlocked - your attacks now deal 20% more damage.",
            18004 => "Brutal Efficiency unlocked - your critical strikes have a 10% chance to deal 500% damage.",
            18005 => "Unyielding Will granted - you gain passive damage mitigation.",
            18006 => "Echoing Onslaught unlocked - your attacks may now strike multiple enemies.",
            18007 => "Enduring Spirit unlocked - you gain +10,000 HP, +10,000 Mana, and +5,000 Endurance.",
            18008 => "Perfect Execution unlocked - unleash a flawless strike that scales with your rebirths.",
        );

        foreach my $aa_id (sort keys %aa_rewards) {
            $client->GrantAlternateAdvancementAbility($aa_id, 1);
            $client->GrantAlternateAdvancementAbility(28, 1);
            
        }
    }
}
