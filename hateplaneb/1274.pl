# Maestro of Rancor Encounter Script (ID 1274)

my $phase = 1;

sub EVENT_SPAWN {
    quest::setnexthpevent(95); # Set HP event at 95%
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Combat started
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Maestro of Rancor lets out a dissonant chord, echoing through the halls!");
        }
    }
}

sub EVENT_HP {
    my @client_list = $entity_list->GetClientList();
    
    if ($hpevent == 95) {
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Maestro begins his grim symphony, accompanied by shrill wails and ghostly notes.");
        }
        $phase = 1;
        quest::setnexthpevent(75); # Set next HP event at 75%
    }
    elsif ($hpevent == 75) {
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "With a shriek, the Maestro summons spectral accompanists to join his macabre performance.");
        }
        Summon_Minions(2);  # Spawn 2 minions
        $phase = 2;
        quest::setnexthpevent(50); # Set next HP event at 50%
    }
    elsif ($hpevent == 50) {
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The tempo quickens as the Maestro's mournful melody draws forth more undead hands.");
        }
        Summon_Minions(2);  # Spawn 2 more minions
        $phase = 3;
        quest::setnexthpevent(40); # Set next HP event at 40%
    }
    elsif ($hpevent == 40) {
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Maestro hits a piercing note! Banshees arise, wailing in twisted harmony with his dirge!");
        }
        quest::spawn2(186192, 0, 0, -291, -421, 23, $npc->GetHeading()); # Spawn Banshee 1
        quest::spawn2(186193, 0, 0, -333, -480, 23, $npc->GetHeading()); # Spawn Banshee 2
        quest::spawn2(186194, 0, 0, -293, -541, 23, $npc->GetHeading()); # Spawn Banshee 3
        $npc->ModifyNPCStat("hp_regen", "500"); # Increase HP regen
        $phase = 4;
        quest::setnexthpevent(25); # Set next HP event at 25%
    }
    elsif ($hpevent == 25) {
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Maestro crescendos, a final discordant cry calls forth all his spectral allies!");
        }
        quest::spawn2(186192, 0, 0, -291, -421, 23, $npc->GetHeading()); # Additional banshee
        quest::spawn2(186193, 0, 0, -333, -480, 23, $npc->GetHeading());
        quest::spawn2(186194, 0, 0, -293, -541, 23, $npc->GetHeading());
        $npc->ModifyNPCStat("hp_regen", "1000"); # Further increase HP regen
    }
}

sub Summon_Minions {
    my ($count) = @_;
    foreach my $client ($entity_list->GetClientList()) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Spectral accompanists emerge to join the Maestro's eerie melody.");
    }
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(186191, 0, 0, $x, $y, $z, $npc->GetHeading());  # Spawn the minion NPC
    }
}

sub EVENT_DEATH_COMPLETE {
    foreach my $client ($entity_list->GetClientList()) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Maestro's melody fades into silence, his cursed symphony forever unfinished...");
    }
    quest::depopall(186191); # Cleanup minions
    quest::depopall(186192);
    quest::depopall(186193);
    quest::depopall(186194);
}
