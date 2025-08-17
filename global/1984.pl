sub EVENT_SPAWN {
    return unless $npc;

    # Delay tint and buff to ensure visual consistency
    quest::settimer("init_effects", 1);

    # Apply stats
    my %stats = (
        ac                   => 20000,
        max_hp               => 14000000,
        min_hit              => 9000,
        max_hit              => 11000,
        accuracy             => 2000,
        avoidance            => 90,
        slow_mitigation      => 90,
        attack               => 1400,
        str                  => 1200,
        sta                  => 1200,
        dex                  => 1200,
        agi                  => 1200,
        int                  => 1200,
        wis                  => 1200,
        cha                  => 1000,
        physical_resist      => 1000,
        hp_regen_rate        => 1000,
        hp_regen_per_second  => 500,
        special_attacks      => "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1",
    );

    while (my ($stat, $value) = each %stats) {
        $npc->ModifyNPCStat($stat, "$value");
    }

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Item drop logic
    my $item_id = 33208;

    # Always drop 1 item
    $npc->AddItem($item_id);

    # 27% chance to drop a second
    if (int(rand(100)) < 27) {
        $npc->AddItem($item_id);
    }

    # 12% chance to drop a third
    if (int(rand(100)) < 12) {
        $npc->AddItem($item_id);
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("heat_aura", 1);  # Heat damage every second

        # One-time heat warning shout
        #quest::shout("The searing heat surges outward — step too close and you will burn!");

        # Optional: Client message for more subtle notice
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(13, "The air around the enemy ignites — waves of searing heat ripple outward!");
        }
    } elsif ($combat_state == 0) {
        quest::stoptimer("heat_aura");
        quest::stoptimer("heat_message");  # In case it was previously set
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        # Apply visual tint
        $npc->SetNPCTintIndex(53);

        # Apply single buff (13378)
        $npc->CastSpell(13378, $npc->GetID()) if !$npc->FindBuff(13378);
    }

    elsif ($timer eq "heat_aura") {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $radius = 50;
        my $damage = 4000;

        # Clients
        foreach my $c ($entity_list->GetClientList()) {
            next unless $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $damage, 0, 1, false);
        }

        # Bots
        foreach my $b ($entity_list->GetBotList()) {
            next unless $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $damage, 0, 1, false);
        }

        # Player pets
        foreach my $c ($entity_list->GetClientList()) {
            my $pet = $c->GetPet();
            next unless $pet && $pet->CalculateDistance($x, $y, $z) <= $radius;
            $pet->Damage($npc, $damage, 0, 1, false);
        }

        # Bot pets
        foreach my $b ($entity_list->GetBotList()) {
            my $pet = $b->GetPet();
            next unless $pet && $pet->CalculateDistance($x, $y, $z) <= $radius;
            $pet->Damage($npc, $damage, 0, 1, false);
        }
    }

    }