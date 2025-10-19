# ===========================================================
# 2232.pl – Tower of Shattered Lanterns
# Floor 4 Mini Boss (Molten Lantern Colossus)
# -----------------------------------------------------------
# Invulnerable until a nearby player has the Phantasmal Key (57162)
# Marks CONV_F4_Mini2232_<CID> on death; default.pl handles Ember Key logic.
# ===========================================================

my $REQ_KEY_ID     = 57162;   # Phantasmal Key (F3→F4)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;

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

sub _unlock_if_locked { return unless $npc && $npc->GetInvul(); $npc->SetInvul(0); $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39); }
sub _lock_if_unlocked { return unless $npc && !$npc->GetInvul(); $npc->SetInvul(1); $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39); }

sub EVENT_SPAWN { return unless $npc; _lock_if_unlocked(); quest::settimer("f4_keycheck",$CHECK_INTERVAL); }
sub EVENT_TIMER { return unless $npc; if($_[0] eq "f4_keycheck"){ _any_keyholder_nearby($npc,$CHECK_RADIUS) ? _unlock_if_locked() : _lock_if_unlocked(); } }
sub EVENT_DAMAGE {
    my($d,$sid,$cid)=@_; return $d unless $npc;
    my $atk=$entity_list->GetMobID($cid); return $d unless $atk;
    my $c;
    if($atk->IsClient()){ $c=$atk->CastToClient(); }
    elsif($atk->IsPet()){ my $o=$atk->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    elsif($atk->IsBot()){ my $o=$atk->CastToBot()->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    if($c){ if(_client_has_key($c)){ _unlock_if_locked(); } else { _lock_if_unlocked(); $npc->WipeHateList(); return -1; } }
    return $d;
}
sub EVENT_COMBAT { if($combat_state==1){ _any_keyholder_nearby($npc,$CHECK_RADIUS) ? _unlock_if_locked() : (_lock_if_unlocked(), $npc->WipeHateList()); } }

sub EVENT_DEATH_COMPLETE {
    my $c=plugin::GetKillerClient($npc,$entity_list);
    return unless $c;
    my $cid=$c->CharacterID();

    my $flag="CONV_F4_Mini2232_${cid}";
    unless(quest::get_data($flag)){
        quest::set_data($flag,1);
        $c->Message(13,"💥 You have absorbed the blazing essence of the Molten Lantern Colossus!");
    }

    my $ess = quest::get_data("CONV_F4_EssenceCount_${cid}") || 0;
    my $done= quest::get_data("CONV_F4_KeyGiven_${cid}") || 0;
    if ($ess >= 12 && !$done) {
        plugin::GrantKeyIfMissing($c, 57163, "Ember Key", "Floor 5");
        quest::set_data("CONV_F4_KeyGiven_${cid}", 1);
        $c->Message(15,"The air cools as the Ember Key binds to your essence.");
    }
}