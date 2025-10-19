my $is_boss = 0;
my $scaled_spawn = 0;

sub EVENT_SPAWN {
    return unless $npc;
    my $raw_name = $npc->GetName() || '';
    my $npc_id = $npc->GetNPCTypeID() || 0;

    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    my $base_stats = $is_boss ? {
        level       => 65,
        ac          => 30000,
        max_hp      => 125000000,
        hp_regen    => 3000,
        min_hit     => 50000,
        max_hit     => 100000,
        atk         => 2500,
        accuracy    => 2000,
        hst         => 38,
        slow_mit    => 90,
        aggro       => 60,
        assist      => 1,
        str         => 1200,
        sta         => 1200,
        agi         => 1200,
        dex         => 1200,
        wis         => 1200,
        int         => 1200,
        cha         => 1000,
        mr          => 400,
        fr          => 400,
        cr          => 400,
        pr          => 400,
        dr          => 400,
        corr        => 500,
        phys        => 1000,
        sa          => "2,1^3,1^5,1^7,1^8^13,1^14,1^15,1^17,1^21,1",
    } : {
        level       => 62,
        ac          => 20000,
        max_hp      => 10000000,
        hp_regen    => 800,
        min_hit     => 44000,
        max_hit     => 55000,
        atk         => 2500,
        accuracy    => 1800,
        hst         => 30,
        slow_mit    => 80,
        aggro       => 55,
        assist      => 1,
        str         => 1000,
        sta         => 1000,
        agi         => 1000,
        dex         => 1000,
        wis         => 1000,
        int         => 1000,
        cha         => 800,
        mr          => 300,
        fr          => 300,
        cr          => 300,
        pr          => 300,
        dr          => 300,
        corr        => 300,
        phys        => 800,
        sa          => "3,1^5,1^7,1^8,1^9,1^10,1^14,1",
    };

    _apply_baseline($base_stats);

    # Explicitly set attack_delay based on boss flag
    $npc->ModifyNPCStat("attack_delay", $is_boss ? 6 : 7);

    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    $npc->ModifyNPCStat("heroic_strikethrough", $base_stats->{hst});

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    quest::setnexthpevent(75) if $is_boss;
}

sub _apply_baseline {
    my ($s) = @_;

    $npc->ModifyNPCStat($_, $s->{$_}) for qw(level ac max_hp hp_regen min_hit max_hit atk accuracy hst slow_mit aggro assist str sta agi dex wis int cha mr fr cr pr dr);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("corruption_resist", $s->{corr});
    $npc->ModifyNPCStat("physical_resist", $s->{phys});
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", $s->{sa});
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        if (!$scaled_spawn) {
            plugin::RaidScaling($entity_list, $npc);
            $scaled_spawn = 1;
        }

        my $hst = $is_boss ? 33 : 28;
        $npc->ModifyNPCStat("heroic_strikethrough", $hst);
        my $max_hp = $npc->GetMaxHP();
        $npc->SetHP($max_hp) if $max_hp > 0;
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
        quest::settimer("reset_hp_event", 75) if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain" && $is_boss) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;
        my $radius = 50;
        my $dmg = 30000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }
    }

    if ($timer eq "reset_hp_event" && $is_boss) {
        quest::setnexthpevent(75);
        quest::stoptimer("reset_hp_event");
    }
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;
    return if $npc->IsPet();

    my $npc_id = $npc->GetNPCTypeID() || 0;
    my $raw_name = $npc->GetName() || '';
    my $exclusion_list = plugin::GetExclusionList();

    return if $raw_name =~ /^#/;
    return if exists $exclusion_list->{$npc_id};

    my $client;
    my $ent = $entity_list->GetMobID($killer_id);
    if ($ent) {
        if ($ent->IsClient()) {
            $client = $ent->CastToClient();
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            $client = $owner->IsClient() ? $owner->CastToClient() : $owner->CastToBot()->GetOwner()->CastToClient() if $owner;
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            $client = $owner->CastToClient() if $owner && $owner->IsClient();
        }
    }

    unless ($client) {
        my $hate = $npc->GetHateTop();
        if ($hate) {
            if ($hate->IsClient()) {
                $client = $hate->CastToClient();
            } elsif ($hate->IsPet()) {
                my $owner = $hate->GetOwner();
                $client = $owner->IsClient() ? $owner->CastToClient() : $owner->CastToBot()->GetOwner()->CastToClient() if $owner;
            } elsif ($hate->IsBot()) {
                my $owner = $hate->CastToBot()->GetOwner();
                $client = $owner->CastToClient() if $owner && $owner->IsClient();
            }
        }
    }

    unless ($client) {
        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->GetGM();
            $client = $c->CastToClient();
            last;
        }
    }

    return unless $client;

    my $base_ip = $client->GetIP();
    my @ip_clients;

    if ($client->GetRaid()) {
        my $raid = $client->GetRaid();
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $m = $raid->GetMember($i);
            push @ip_clients, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } elsif ($client->GetGroup()) {
        my $group = $client->GetGroup();
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $m = $group->GetMember($i);
            push @ip_clients, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } else {
        push @ip_clients, $client;
    }

    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();

        my $cid = $pc->CharacterID();
        my $essence_key = "POD_EssenceCount_${cid}";
        my $completion_key = "POD_EssenceComplete_${cid}";
        my $count = quest::get_data($essence_key) || 0;
        $count++;

        quest::set_data($essence_key, $count);
        $pc->Message(15, "You have gathered an essence from PoDisease [$count / 1000]");

        if ($count >= 1000) {
            quest::set_data($completion_key, 1);
            $pc->Message(13, "You have gathered 1000 essences from PoDisease! A reward chest appears!");

            if ($pc->CharacterID() == $client->CharacterID()) {
                my ($x, $y, $z, $h) = ($client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
                quest::spawn2(2203, 0, 0, $x, $y, $z, $h);
            }

            quest::set_data($essence_key, 0);
        }
    }
}