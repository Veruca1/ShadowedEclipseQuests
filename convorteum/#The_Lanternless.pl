# ===========================================================
# 2233.pl – Tower of Shattered Lanterns
# Floor 5 Mini Boss (#The_Lanternless)
# -----------------------------------------------------------
# Invulnerable until a nearby player has the Ember Key (57163)
# Marks CONV_F5_Mini2233_<CID> on death; default.pl handles the Floor 5 key logic.
# ===========================================================

my $REQ_KEY_ID     = 57163;   # Ember Key (Floor 4 → 5)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;

# ------------------------------ Key Checks
sub _has_key_inv   { my($c)=@_; return ($c && $c->IsClient() && $c->CountItem($REQ_KEY_ID)>0) ? 1 : 0; }
sub _has_key_ring  { my($c)=@_; return 0 unless $c && $c->IsClient(); my $ok=0; eval{$ok=$c->KeyRingCheck($REQ_KEY_ID)?1:0;}; return $ok; }
sub _client_has_key{ my($c)=@_; return (_has_key_inv($c)||_has_key_ring($c)); }

sub _any_keyholder_nearby {
    my($npc_ref,$r)=@_; return 0 unless $npc_ref;
    foreach my $c ($entity_list->GetClientList()){
        next unless $c->IsClient();
        next if $npc_ref->CalculateDistance($c->GetX,$c->GetY,$c->GetZ) > $r;
        return 1 if _client_has_key($c);
    } return 0;
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

# ------------------------------ Events
sub EVENT_SPAWN {
    return unless $npc;
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39);
    quest::settimer("f5_keycheck",$CHECK_INTERVAL);
}
sub EVENT_TIMER {
    return unless $npc;
    if($_[0] eq "f5_keycheck"){
        if(_any_keyholder_nearby($npc,$CHECK_RADIUS)){ _unlock_if_locked(); }
        else{ _lock_if_unlocked(); }
    }
}
sub EVENT_DAMAGE {
    my($d,$sid,$cid)=@_; return $d unless $npc;
    my $atk=$entity_list->GetMobID($cid); return $d unless $atk;
    my $c;
    if($atk->IsClient()){ $c=$atk->CastToClient(); }
    elsif($atk->IsPet()){ my $o=$atk->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    elsif($atk->IsBot()){ my $o=$atk->CastToBot()->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }

    if($c){
        if(_client_has_key($c)){ _unlock_if_locked(); }
        else{ _lock_if_unlocked(); $npc->WipeHateList(); return -1; }
    }
    return $d;
}
sub EVENT_COMBAT {
    if ($combat_state == 1) {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) {
            _unlock_if_locked();
            # Start spawning
            foreach my $sid (2234, 2236, 2237, 2238, 2239, 2240) {
                quest::signalwith($sid, 10);
            }
        } else {
            _lock_if_unlocked();
            $npc->WipeHateList();
        }
    } else {
        # Stop spawning when combat ends (e.g. player death)
        foreach my $sid (2234, 2236, 2237, 2238, 2239, 2240) {
            quest::signalwith($sid, 20);
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop all spawn signals when this NPC dies
    foreach my $sid (2234, 2236, 2237, 2238, 2239, 2240) {
        quest::signalwith($sid, 20);
    }

    my $c = plugin::GetKillerClient($npc, $entity_list);
    return unless $c && $c->IsClient();
    my $cid = $c->CharacterID();

    # mark mini flag
    my $mini_key = "CONV_F5_Mini2233_${cid}";
    unless (quest::get_data($mini_key)) {
        quest::set_data($mini_key, 1);
        $c->Message(13, "🌑 You have absorbed the voidlight essence of the Lanternless!");
        #quest::debug("[F5 MINI] Flag set for ".$c->GetCleanName());
    }

    # === grant Umbral Key if essence complete ===
    my $ess_key = "CONV_F5_EssenceCount_${cid}";
    my $given   = "CONV_F5_KeyGiven_${cid}";
    my $count   = quest::get_data($ess_key) || 0;
    my $done    = quest::get_data($given)   || 0;

    my $UMBRAL_KEY_ID   = 57164;
    my $UMBRAL_KEY_NAME = "Umbral Key";
    my $F5_ESSENCE_REQ  = 30;

    if ($count >= $F5_ESSENCE_REQ && !$done) {
        plugin::GrantKeyIfMissing($c, $UMBRAL_KEY_ID, $UMBRAL_KEY_NAME, "Floor 6");
        quest::set_data($given, 1);
        $c->Message(15, "A hush falls as the $UMBRAL_KEY_NAME binds to your essence.");
        #quest::debug("[F5] Umbral Key granted on mini death (cid=$cid)");
    }
}