# ===========================================================
# 2241.pl – Tower of Shattered Lanterns (Floor 6 Mini)
# #The_Wickbreaker
# -----------------------------------------------------------
# • Invulnerable unless a nearby player has the Umbral Key (57164)
# • Blocks damage / wipes hate from non-keyholders
# • No signals to other NPCs (unlike 2233)
# • Includes per-entity era + raid scaling (since default.pl won't run)
# • On death: spawns 2244 at exact death location + spawns 2242 (Morghast)
# ===========================================================

my $REQ_KEY_ID     = 57164;   # Umbral Key (Floor 5 → 6)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;

# ------------------------------ Era scaling helpers
sub _mark_scaled { $npc->SetEntityVariable("se_scaled","1"); }
sub _was_scaled  { return ($npc->GetEntityVariable("se_scaled")||"") eq "1"; }

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
    if ($@ || !@clients) {
        my $it = $elist->GetClientList();
        while (my $c = $it->Next()) { push @clients, $c; }
    }

    foreach my $era (qw(pop luclin velious kunark antonica)) {
        foreach my $c (@clients) {
            next unless $c && $c->IsClient();
            foreach my $zoneid (@{$eras{$era}}) {
                return $era if $c->HasZoneFlag($zoneid);
            }
        }
    }
    return "antonica";
}

sub _scale_self_once {
    return if _was_scaled();

    my @clients = $entity_list->GetClientList();
    my $has_client = scalar grep { $_ && $_->IsClient() } @clients;

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

    eval { plugin::ApplyEraStats($npc, $era, $is_boss); };
    eval { plugin::RaidScaling($entity_list, $npc); };

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);
    _mark_scaled();
}

# ------------------------------ Key checks
sub _has_key_inv   { my($c)=@_; return ($c && $c->IsClient() && $c->CountItem($REQ_KEY_ID)>0) ? 1 : 0; }
sub _has_key_ring  { my($c)=@_; return 0 unless $c && $c->IsClient(); my $ok=0; eval{ $ok=$c->KeyRingCheck($REQ_KEY_ID)?1:0; }; return $ok; }
sub _client_has_key{ my($c)=@_; return (_has_key_inv($c)||_has_key_ring($c)); }

sub _any_keyholder_nearby {
    my($npc_ref,$r)=@_;
    return 0 unless $npc_ref;
    my @cl = $entity_list->GetClientList();
    foreach my $c (@cl){
        next unless $c && $c->IsClient();
        next if $npc_ref->CalculateDistance($c->GetX,$c->GetY,$c->GetZ) > $r;
        return 1 if _client_has_key($c);
    }
    return 0;
}

# ------------------------------ Lock / Unlock
sub _unlock_if_locked {
    return unless $npc && $npc->GetInvul();
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39);
}
sub _lock_if_unlocked {
    return unless $npc && !$npc->GetInvul();
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39);
}

# ===========================================================
# Events
# ===========================================================
sub EVENT_SPAWN {
    return unless $npc;
    _lock_if_unlocked();

    _scale_self_once();
    quest::settimer("retry_scale", 3);
    quest::settimer("late_scale", 4);
    quest::settimer("f6_keycheck", $CHECK_INTERVAL);
}

sub EVENT_TIMER {
    return unless $npc;

    if ($_[0] eq "f6_keycheck") {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); }
    }
    elsif ($_[0] eq "retry_scale") {
        quest::stoptimer("retry_scale");
        _scale_self_once();
    }
    elsif ($_[0] eq "late_scale") {
        quest::stoptimer("late_scale");
        _scale_self_once();
    }
}

# Block damage from anyone who lacks the Umbral Key
sub EVENT_DAMAGE {
    my($d,$sid,$cid)=@_;
    return $d unless $npc;

    my $atk=$entity_list->GetMobID($cid);
    return $d unless $atk;

    my $c;
    if ($atk->IsClient()) { $c=$atk->CastToClient(); }
    elsif ($atk->IsPet()) { my $o=$atk->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    elsif ($atk->IsBot()) { my $o=$atk->CastToBot()->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }

    if ($c && !_client_has_key($c)) {
        $npc->WipeHateList();
        return -1; # negate damage
    }
    return $d;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); $npc->WipeHateList(); }
    } else {
        _lock_if_unlocked();
    }
}

# ------------------------------ Death: spawn 2244 and 2242
sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("f6_keycheck");
    quest::stoptimer("retry_scale");
    quest::stoptimer("late_scale");

    quest::ze(15, "As the Wickbreaker falls, the air thickens with smoke and dread — something awakens in the gazebo.");

    my ($sx,$sy,$sz,$sh) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(2244, 0, 0, $sx, $sy, $sz, $sh);

    my ($bx,$by,$bz,$bh) = (958.29, -1033.30, 1003.82, 256.75);
    quest::spawn2(2242, 0, 0, $bx, $by, $bz, $bh);
}