# ===========================================================
# default.pl — Plane of Torment (PoTorment)
# Shadowed Eclipse Progression: Essence Tracking & Scaling
# ===========================================================

my $is_boss      = 0;
my $scaled_spawn = 0;  # block double scaling

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # ===========================================================
    # Exclusion list — only zone_controller
    # ===========================================================
    my $exclusion_list = {
    201007 => 1,  # zone_controller - default system spawner

    # ===== Custom PoTorment Exclusions =====
    207000 => 1,  # A_blurry_image        - ambient illusion
    207081 => 1,  # Tylis_Newleaf_        - storyline NPC
    207048 => 1,  # A_cloudy_image        - ambient illusion
    207083 => 1,  # #a_bruised_woman      - scripted event NPC (boss-like)
    207071 => 1,  # mouth_trigger         - trap or mechanic trigger
    207080 => 1,  # its_a_trap            - trap spawner
    207063 => 1,  # Something_dark        - ambient or effect mob
    207089 => 1,  # A_warm                - environmental flavor
    207062 => 1,  # A_faint_rattle        - environmental flavor
    207061 => 1  # An_acidic_mist        - environmental hazard
};
    return if exists $exclusion_list->{$npc_id};

    # ===========================================================
    # General setup
    # ===========================================================
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    # ===========================================================
    # Set level first
    # ===========================================================
    $npc->ModifyNPCStat("level", $is_boss ? 66 : 63);

    # ===========================================================
    # Apply baseline stats via plugin
    # ===========================================================
    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

# ===========================================================
# Plane of Torment - Trash Kill → Essence Tracking
# ===========================================================

sub EVENT_DEATH_COMPLETE {
    return unless $npc;
    return if $npc->IsPet();

    my $npc_id   = $npc->GetNPCTypeID() || 0;
    my $raw_name = $npc->GetName() || '';
    return if $raw_name =~ /^#/;

    my $client;
    my $ent = $entity_list->GetMobID($killer_id);

    if ($ent) {
        if ($ent->IsClient()) {
            $client = $ent->CastToClient();
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
            } elsif ($owner && $owner->IsBot()) {
                my $bot_owner = $owner->CastToBot()->GetOwner();
                if ($bot_owner && $bot_owner->IsClient()) {
                    $client = $bot_owner->CastToClient();
                }
            }
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            if ($owner && $owner->IsClient()) {
                $client = $owner->CastToClient();
            }
        }
    }

    unless ($client) {
        my $hate = $npc->GetHateTop();
        if ($hate) {
            if    ($hate->IsClient()) { $client = $hate->CastToClient(); }
            elsif ($hate->IsPet()) {
                my $owner = $hate->GetOwner();
                if ($owner && $owner->IsClient()) { $client = $owner->CastToClient(); }
                elsif ($owner && $owner->IsBot()) {
                    my $bot_owner = $owner->CastToBot()->GetOwner();
                    if ($bot_owner && $bot_owner->IsClient()) { $client = $bot_owner->CastToClient(); }
                }
            } elsif ($hate->IsBot()) {
                my $owner = $hate->CastToBot()->GetOwner();
                if ($owner && $owner->IsClient()) { $client = $owner->CastToClient(); }
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
            if ($m && $m->IsClient() && $m->GetIP() == $base_ip) {
                push @ip_clients, $m;
            }
        }
    } elsif ($client->GetGroup()) {
        my $group = $client->GetGroup();
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $m = $group->GetMember($i);
            if ($m && $m->IsClient() && $m->GetIP() == $base_ip) {
                push @ip_clients, $m;
            }
        }
    } else {
        push @ip_clients, $client;
    }

    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();

        my $essence_key    = "PoTorment_EssenceCount_${cid}";
        my $completion_key = "PoTorment_EssenceComplete_${cid}";

        my $count = quest::get_data($essence_key) || 0;
        $count++;
        quest::set_data($essence_key, $count);

        $pc->Message(15, "You have gathered an essence from the Plane of Torment [$count / 1000]");

        if ($count >= 1000) {
            quest::set_data($completion_key, 1);
            $pc->Message(13, "You have gathered 1000 essences from the Plane of Torment! A reward chest appears!");

            if ($pc->CharacterID() == $client->CharacterID()) {
                my $x = $client->GetX();
                my $y = $client->GetY();
                my $z = $client->GetZ();
                my $h = $client->GetHeading();
                quest::spawn2(2250, 0, 0, $x, $y, $z, $h);
            }

            quest::set_data($essence_key, 0);
        }
    }
}