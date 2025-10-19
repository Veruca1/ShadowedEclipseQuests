# ===========================================================
# 2242.pl – Tower of Shattered Lanterns (Floor 6 BOSS)
# #Morghast,_Shatterlight_Sovereign
# -----------------------------------------------------------
# • Era + raid scaling
# • Faction normalized to 623
# • Stage gating at HP 80/60/40/20/10:
#     - Each threshold triggers its matching plinth (signal 10)
#     - Boss is INVUL until correct plinth dies (signal 1..5)
# ===========================================================

# =========================
# Client utilities
# =========================
sub _clients {
    my @clients = $entity_list->GetClientList();
    my @out;
    foreach my $c (@clients) {
        next unless $c && $c->IsClient();
        next if $c->GetHP() <= 0;  # dead check
        push @out, $c;
    }
    return @out;
}

sub _nearest_client {
    my ($r) = @_;
    $r ||= 250;
    my $best;
    my $bestd2 = 9e18;
    foreach my $c (_clients()) {
        my $dx = $c->GetX() - $npc->GetX();
        my $dy = $c->GetY() - $npc->GetY();
        my $dz = $c->GetZ() - $npc->GetZ();
        my $d2 = $dx*$dx + $dy*$dy + $dz*$dz;
        next if $d2 > $r*$r;
        if ($d2 < $bestd2) { $bestd2 = $d2; $best = $c; }
    }
    return $best;
}

# =========================
# Era + raid scaling
# =========================
sub _mark_scaled { $npc->SetEntityVariable("se_scaled","1"); }
sub _was_scaled  { return ($npc->GetEntityVariable("se_scaled")||"") eq "1"; }

sub _determine_era_including_gm {
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,204,205],
    );
    foreach my $era (qw(pop luclin velious kunark antonica)) {
        foreach my $c (_clients()) {
            foreach my $zoneid (@{$eras{$era}}) {
                return $era if $c->HasZoneFlag($zoneid);
            }
        }
    }
    return "antonica";
}

sub _scale_self_once {
    return if _was_scaled();
    my @cl = _clients();
    if (!@cl) {
        quest::settimer("retry_scale", 3);
        return;
    }
    my $inst_id = quest::GetInstanceID("convorteum", 1);
    eval { plugin::ResetEraCache(); };
    my $era = $qglobals{"era_" . $inst_id};
    $era = _determine_era_including_gm() unless $era;
    my $raw = $npc->GetName() || '';
    my $is_boss = ($raw =~ /^#/) ? 1 : 0;
    eval { plugin::ApplyEraStats($npc, $era, $is_boss); };
    eval { plugin::RaidScaling($entity_list, $npc);     };
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);
    _mark_scaled();
}

# =========================
# Invul / vulnerable controls
# =========================
sub _unlock_if_locked {
    return unless $npc && $npc->GetInvul();
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39);
    if (!$npc->IsEngaged()) {
        my $t = _nearest_client(250);
        if ($t) {
            $npc->AddToHateList($t, 10000, 10000);
            $npc->Attack($t);
        }
    }
}

sub _lock_if_unlocked {
    return unless $npc && !$npc->GetInvul();
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39);
}

# =========================
# Stage gating logic
# =========================
my @STAGE_PCT = (80, 60, 40, 20, 10);
my @STAGE_MSG = (
    "Energy ripples upward — the ascent awakens.",
    "A low resonance crawls through the stone — darkness gathers at the edges of sight.",
    "The veil shimmers — faint laughter echoes where none should be.",
    "The temperature rises — motes of ash drift lazily through the air.",
    "A suffocating silence falls — shadows twist inward upon themselves."
);
my %stage_done = ();
my $active_stage_pct = -1;
my $fight_active     = 0;

sub _reset_fight_state {
    %stage_done       = ();
    $active_stage_pct = -1;
    $fight_active     = 0;
    _unlock_if_locked();
    quest::setnexthpevent($STAGE_PCT[0]);
}

sub _idx_for_pct {
    my ($p) = @_;
    for (my $i=0; $i<@STAGE_PCT; $i++) { return $i if $STAGE_PCT[$i] == $p; }
    return -1;
}

sub _activate_stage_at_pct {
    my ($pct) = @_;
    return if $pct < 0;
    return if $stage_done{$pct};
    $active_stage_pct = $pct;
    _lock_if_unlocked();

    if ($pct == 80) { quest::signalwith(2243, 10); }
    elsif ($pct == 60) { quest::signalwith(2247, 10); }
    elsif ($pct == 40) { quest::signalwith(2246, 10); }
    elsif ($pct == 20) { quest::signalwith(2245, 10); }
    elsif ($pct == 10) { quest::signalwith(2244, 10); }

    my $idx = _idx_for_pct($pct);
    quest::ze(15, $STAGE_MSG[$idx]) if $idx >= 0;
}

sub _complete_active_stage {
    return if $active_stage_pct < 0;
    $stage_done{$active_stage_pct} = 1;
    $active_stage_pct = -1;
    _unlock_if_locked();
    my $next;
    foreach my $p (@STAGE_PCT) {
        next if $stage_done{$p};
        $next = $p; last;
    }
    quest::setnexthpevent($next) if defined $next;
}

# =========================
# Events
# =========================
sub EVENT_SPAWN {
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39);
    _scale_self_once();
    quest::settimer("retry_scale", 3);
    quest::settimer("late_scale", 4);
    _reset_fight_state();
}

sub EVENT_TIMER {
    if ($_[0] eq "retry_scale") {
        quest::stoptimer("retry_scale");
        _scale_self_once();
    } elsif ($_[0] eq "late_scale") {
        quest::stoptimer("late_scale");
        _scale_self_once();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        $fight_active = 1;
    } elsif ($npc->GetHPRatio() >= 99.5) {
        _reset_fight_state();
    }
}

sub EVENT_HP {
    my $pct = $hpevent;
    return unless $fight_active;
    return if $stage_done{$pct};
    _activate_stage_at_pct($pct);
}

sub EVENT_SIGNAL {
    my $sig = $signal;
    return if $active_stage_pct < 0;
    my $need_idx = _idx_for_pct($active_stage_pct);
    my $need_sig = $need_idx + 1;
    if ($npc->GetInvul() && $sig == $need_sig) {
        _complete_active_stage();
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("retry_scale");
    quest::stoptimer("late_scale");
}