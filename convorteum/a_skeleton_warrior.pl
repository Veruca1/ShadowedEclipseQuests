# ===========================================================
# 2235.pl - Floor 5 spawned trash (Skeleton Warrior)
# • Requires Ember Key (57163) to interact:
#   - Hunts only keyholders
#   - Ignores damage from non-keyholders (wipes hate)
#   - Essence credit only to keyholders (same-IP share)
# • Runs its own era + raid scaling (using entity vars for guard)
# • Retains hunt + timed despawn behavior
# ===========================================================

my $REQ_KEY_ID        = 57163;          # Ember Key
my $F5_ESSENCE_REQ    = 30;
my $UMBRAL_KEY_ID     = 57164;          # Floor 5 → 6
my $UMBRAL_KEY_NAME   = "Umbral Key";

# ------------------------------ Key helpers
sub _has_key_inv   { my($c)=@_; return ($c && $c->IsClient() && $c->CountItem($REQ_KEY_ID)>0) ? 1 : 0; }
sub _has_key_ring  { my($c)=@_; return 0 unless $c && $c->IsClient(); my $ok=0; eval{$ok=$c->KeyRingCheck($REQ_KEY_ID)?1:0;}; return $ok; }
sub _client_has_key{ my($c)=@_; return (_has_key_inv($c)||_has_key_ring($c)); }

# ------------------------------ per-instance scaled guard (entity vars)
sub _mark_scaled { $npc->SetEntityVariable("se_scaled","1"); }
sub _was_scaled  { return ($npc->GetEntityVariable("se_scaled")||"") eq "1"; }

# ------------------------------ era detection that includes GMs
sub _determine_era_including_gm {
    my ($elist) = @_;
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,204,205],
    );

    my @clients;
    eval { @clients = $elist->GetClientList(); };
    if ($@ || !@clients) { my $it = $elist->GetClientList(); while (my $c = $it->Next()) { push @clients, $c; } }

    foreach my $era (qw(pop luclin velious kunark antonica)) {
        foreach my $c (@clients) {
            next unless $c && $c->IsClient();
            foreach my $zoneid (@{$eras{$era}}) { return $era if $c->HasZoneFlag($zoneid); }
        }
    }
    return "antonica";
}

# ------------------------------ scale THIS NPC instance (with retry if no clients)
sub _scale_self_once {
    return if _was_scaled();

    my $has_client = 0;
    my @clients;
    eval { @clients = $entity_list->GetClientList(); };
    if ($@ || !@clients) { my $it = $entity_list->GetClientList(); while (my $c = $it->Next()) { push @clients, $c; } }
    foreach my $c (@clients) { $has_client++ if $c && $c->IsClient(); }

    if (!$has_client) {
        quest::settimer("retry_scale", 3);
        return;
    }

    my $inst_id = quest::GetInstanceID("convorteum", 1);
    eval { plugin::ResetEraCache(); };

    my $era = $qglobals{"era_" . $inst_id};
    $era = _determine_era_including_gm($entity_list) unless $era;

    my $raw = $npc->GetName() || '';
    my $is_boss = ($raw =~ /^#/) ? 1 : 0;

    plugin::ApplyEraStats($npc, $era, $is_boss);
    plugin::RaidScaling($entity_list, $npc);

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);

    _mark_scaled();
}

# ------------------------------ essence credit (keyholders only)
sub _credit_floor5_essence {
    my ($killer_client) = @_;
    return unless $killer_client && $killer_client->IsClient();

    my $base_ip = $killer_client->GetIP();
    my @pcs;

    if ($killer_client->GetRaid()) {
        my $r = $killer_client->GetRaid();
        for (my $i = 0; $i < $r->RaidCount(); $i++) {
            my $m = $r->GetMember($i);
            push @pcs, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } elsif ($killer_client->GetGroup()) {
        my $g = $killer_client->GetGroup();
        for (my $i = 0; $i < $g->GroupCount(); $i++) {
            my $m = $g->GetMember($i);
            push @pcs, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } else {
        push @pcs, $killer_client;
    }

    foreach my $pc (@pcs) {
        next unless $pc && $pc->IsClient();
        next unless _client_has_key($pc);
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();

        my $ess_key = "CONV_F5_EssenceCount_${cid}";
        my $mini_key = "CONV_F5_Mini2233_${cid}";
        my $given    = "CONV_F5_KeyGiven_${cid}";

        my $count = quest::get_data($ess_key) || 0;

        if ($count < $F5_ESSENCE_REQ) {
            $count++;
            quest::set_data($ess_key, $count);
            $pc->Message(15, "You have gathered an essence of Floor 5 [$count/$F5_ESSENCE_REQ]");
        }

        my $mflag = quest::get_data($mini_key) || 0;
        my $done  = quest::get_data($given)    || 0;

        if ($count >= $F5_ESSENCE_REQ && $mflag && !$done) {
            plugin::GrantKeyIfMissing($pc, $UMBRAL_KEY_ID, $UMBRAL_KEY_NAME, "Floor 6");
            quest::set_data($given, 1);
            $pc->Message(15, "A hush falls as the $UMBRAL_KEY_NAME binds to your essence.");
        }
    }
}

# ===========================================================
# EVENTS
# ===========================================================
sub EVENT_SPAWN {
    _scale_self_once();
    quest::settimer("late_scale", 4);
    quest::settimer("hunt", 1);
    quest::settimer("self_despawn", 180);

    # ✅ Force extreme movement speed for testing
    $npc->ModifyNPCStat("runspeed", 15);
    $npc->ModifyNPCStat("walkspeed", 10);
}

sub EVENT_TIMER {
    if ($timer eq "late_scale") {
        quest::stoptimer("late_scale");
        _scale_self_once();
    }
    elsif ($timer eq "retry_scale") {
        quest::stoptimer("retry_scale");
        _scale_self_once();
    }
    elsif ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();
        @clients = grep { $_ && $_->IsClient() && !$_->GetGM() && _client_has_key($_) } @clients;

        if (@clients) {
            my $target = $clients[int(rand(@clients))];
            $target->Message(15, "You feel like you are being watched");
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), 1);
            quest::stoptimer("self_despawn");
        }
        quest::settimer("hunt", 5);
    }
    elsif ($timer eq "self_despawn") {
        $npc->Depop();
    }
}

sub EVENT_DAMAGE {
    my($d,$sid,$cid)=@_;
    return $d unless $npc;

    my $atk = $entity_list->GetMobID($cid);
    return $d unless $atk;

    my $c;
    if ($atk->IsClient()) { $c = $atk->CastToClient(); }
    elsif ($atk->IsPet())  { my $o=$atk->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    elsif ($atk->IsBot())  { my $o=$atk->CastToBot()->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }

    if ($c && !_client_has_key($c)) {
        $npc->WipeHateList();
        return -1;
    }
    return $d;
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");
    quest::stoptimer("self_despawn");
    my $killer = plugin::GetKillerClient($npc, $entity_list);
    _credit_floor5_essence($killer);
}