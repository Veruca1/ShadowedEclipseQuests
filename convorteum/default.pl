# ===========================================================
# default.pl - Tower of Shattered Lanterns (Convorteum DZ)
# Floors 1–5 Scaling, Essence, and Key Logic
# Per-NPC (entity) scaling; robust essence debug for Floor 5
# ===========================================================

my $is_boss = 0;

# === DEBUG SWITCH (0=off, 1=on) ===
my $DBG = 1;

# === KEY IDS ===
my $TOWER_KEY_ID       = 56755;  # Floor 1 → 2
my $OBSIDIAN_KEY_ID    = 57161;  # Floor 2 → 3
my $PHANTASMAL_KEY_ID  = 57162;  # Floor 3 → 4
my $EMBER_KEY_ID       = 57163;  # Floor 4 → 5
my $UMBRAL_KEY_ID   = 57164;           # Floor 5 → 6
my $UMBRAL_KEY_NAME = "Umbral Key";

# === FLOOR NPC GROUPS ===
my %F1_TRASH = map { $_ => 1 } (2209,2210,2211,2212,2213,2214,2215);
my %F2_TRASH = map { $_ => 1 } (2216,2217,2218,2219);
my %F3_TRASH = map { $_ => 1 } (2220,2221,2222,2223,2224,2225);
my %F4_TRASH = map { $_ => 1 } (2226,2227,2228,2229);      # Floor 4 trash
my %F4_MINIS = map { $_ => 1 } (2230,2231,2232);           # Floor 4 minis

# Floor 5:
# 2234 = Bones (does NOT count toward essences; spawns 2235)
# 2235 = Spawned trash that DOES count toward essences
my %F5_TRASH = map { $_ => 1 } (2235);
my %F5_MINIS = map { $_ => 1 } (2233);                     # The Lanternless
my $F5_ESSENCE_REQ = 30;

# ------------------------------ helpers: per-entity flags
sub _mark_scaled  { my($n)=@_; $n->SetEntityVariable("se_scaled","1"); }
sub _was_scaled   { my($n)=@_; return ($n->GetEntityVariable("se_scaled")||"") eq "1"; }

# ===========================================================
# EVENT_SPAWN
# ===========================================================
sub EVENT_SPAWN {
    return unless $npc && !$npc->IsPet();

    my $npcid = $npc->GetNPCTypeID();
    my $raw   = $npc->GetName() || '';
    $is_boss  = ($raw =~ /^#/) ? 1 : 0;

    # Skip scaling & faction for 2234 (bones only)
    if ($npcid == 2234) {
        quest::debug("[INIT] Skip scale/faction for Bones 2234") if $DBG;
        return;
    }

    # Always set/repair faction early
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);

    # Important: every spawn gets its own delayed init regardless of others
    quest::settimer("delayed_init", 3 + int(rand(2)));

    # Some zonescripts flip faction; force once more shortly after
    quest::settimer("force_faction", 5);
}

# ===========================================================
# EVENT_TIMER
# ===========================================================
sub EVENT_TIMER {
    my $timer = $_[0];
    return unless $npc;

    if ($timer eq "delayed_init") {
        quest::stoptimer($timer);
        _do_delayed_init();

    } elsif ($timer eq "force_faction") {
        $npc->SetNPCFactionID(623);
        $npc->ModifyNPCStat("npc_faction_id", 623);
        quest::stoptimer($timer);
    }
}

# ===========================================================
# INTERNAL: Scaling Initialization (GM-aware era)
# ===========================================================
sub _do_delayed_init {
    return unless $npc;
    return if _was_scaled($npc);   # <-- per-entity guard, not global!

    my $inst_id = quest::GetInstanceID("convorteum", 1);

    # Count ANY clients (GM or not)
    my $client_count = 0;
    my @clients;
    eval { @clients = $entity_list->GetClientList(); };
    if ($@ || !@clients) {
        my $it = $entity_list->GetClientList();
        while (my $c = $it->Next()) { push @clients, $c; }
    }
    foreach my $c (@clients) {
        next unless $c && $c->IsClient();
        $client_count++;
    }

    if ($client_count == 0) {
        quest::settimer("delayed_init", 5);  # wait until at least one client
        quest::debug("[SCALE] No clients yet; recheck in 5s for NPCID ".$npc->GetNPCTypeID()) if $DBG;
        return;
    }

    # Clear stale era cache and compute era including GMs
    eval { plugin::ResetEraCache(); };
    my $era = $qglobals{"era_" . $inst_id};
    $era = _determine_era_including_gm($entity_list) unless $era;

    plugin::ApplyEraStats($npc, $era, $is_boss);
    plugin::RaidScaling($entity_list, $npc);

    # Keep faction consistent
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);

    _mark_scaled($npc);

    quest::debug("[SCALE] NPCID ".$npc->GetNPCTypeID()." scaled to era [$era], boss=$is_boss") if $DBG;
}

# ===========================================================
# Local era resolver (includes GMs)
# ===========================================================
sub _determine_era_including_gm {
    my ($entity_list) = @_;
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,204,205],
    );

    my @clients;
    eval { @clients = $entity_list->GetClientList(); };
    if ($@ || !@clients) {
        my $it = $entity_list->GetClientList();
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

# ===========================================================
# EVENT_DEATH_COMPLETE (Floors 2–5)
# ===========================================================
sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();
    my $id = $npc->GetNPCTypeID();
    return if $F1_TRASH{$id};  # Floor 1 essences handled elsewhere

    my $client = plugin::GetKillerClient($npc, $entity_list);
    return unless $client;

    # Build same-IP share list (raid/group aware)
    my $base_ip = $client->GetIP();
    my @pcs;

    if ($client->GetRaid()) {
        my $r = $client->GetRaid();
        for (my $i = 0; $i < $r->RaidCount(); $i++) {
            my $m = $r->GetMember($i);
            push @pcs, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } elsif ($client->GetGroup()) {
        my $g = $client->GetGroup();
        for (my $i = 0; $i < $g->GroupCount(); $i++) {
            my $m = $g->GetMember($i);
            push @pcs, $m if $m && $m->IsClient() && $m->GetIP() == $base_ip;
        }
    } else {
        push @pcs, $client;
    }

    foreach my $pc (@pcs) {
        next unless $pc && $pc->IsClient();
        $pc = $pc->CastToClient();
        my $cid = $pc->CharacterID();

        # ---------------------------
        # Floor 2 → Obsidian Key
        # ---------------------------
        if ($F2_TRASH{$id}) {
            my $ess_key = "CONV_F2_EssenceCount_${cid}";
            my $mini_key = "CONV_F2_Mini2219_${cid}";
            my $given    = "CONV_F2_KeyGiven_${cid}";

            my $count = quest::get_data($ess_key) || 0;
            my $mflag = quest::get_data($mini_key) || 0;
            my $done  = quest::get_data($given)    || 0;

            if ($count < 12) { $count++; quest::set_data($ess_key, $count); }
            $pc->Message(15, "You have gathered an essence of Floor 2 [$count/12]");
            quest::debug("[F2] Essence +1 (npc=$id, cid=$cid) -> $count") if $DBG;

            if ($id == 2219 && !$mflag) {
                quest::set_data($mini_key, 1);
                $pc->Message(13, "✨ You have absorbed the essence of Mini Boss 2219!");
            }

            if ($count >= 12 && $mflag && !$done) {
                plugin::GrantKeyIfMissing($pc, $OBSIDIAN_KEY_ID, "Obsidian Key", "Floor 3");
                quest::set_data($given, 1);
            }
        }

        # ---------------------------
        # Floor 3 → Phantasmal Key
        # ---------------------------
        if ($F3_TRASH{$id}) {
            my $ess_key = "CONV_F3_EssenceCount_${cid}";
            my $mini1   = "CONV_F3_Mini2224_${cid}";
            my $mini2   = "CONV_F3_Mini2225_${cid}";
            my $given   = "CONV_F3_KeyGiven_${cid}";

            my $count = quest::get_data($ess_key) || 0;
            my $m1    = quest::get_data($mini1)   || 0;
            my $m2    = quest::get_data($mini2)   || 0;
            my $done  = quest::get_data($given)   || 0;

            if ($count < 12) { $count++; quest::set_data($ess_key, $count); }
            $pc->Message(15, "You have gathered an essence of Floor 3 [$count/12]");
            quest::debug("[F3] Essence +1 (npc=$id, cid=$cid) -> $count") if $DBG;

            if ($id == 2224 && !$m1) { quest::set_data($mini1, 1); $pc->Message(13, "✨ Essence of the Twilight Phantasm!"); }
            if ($id == 2225 && !$m2) { quest::set_data($mini2, 1); $pc->Message(13, "✨ Essence of the Glasswork Duelist!"); }

            if ($count >= 12 && $m1 && $m2 && !$done) {
                plugin::GrantKeyIfMissing($pc, $PHANTASMAL_KEY_ID, "Phantasmal Key", "Floor 4");
                quest::set_data($given, 1);
            }
        }

        # ---------------------------
        # Floor 4 → Ember Key
        # ---------------------------
        if ($F4_TRASH{$id} || $F4_MINIS{$id}) {
            my $ess_key = "CONV_F4_EssenceCount_${cid}";
            my $count   = quest::get_data($ess_key) || 0;

            if ($F4_TRASH{$id} && $count < 12) {
                $count++; quest::set_data($ess_key, $count);
                $pc->Message(15, "You have gathered an essence of Floor 4 [$count/12]");
                quest::debug("[F4] Essence +1 (npc=$id, cid=$cid) -> $count") if $DBG;
            }

            if ($F4_MINIS{$id}) {
                my $mini_flag = "CONV_F4_Mini${id}_${cid}";
                unless (quest::get_data($mini_flag)) {
                    quest::set_data($mini_flag, 1);
                    $pc->Message(13, "🔥 You have absorbed the molten essence of " . $npc->GetCleanName() . "!");
                }
            }

            my $m1 = quest::get_data("CONV_F4_Mini2230_${cid}") || 0;
            my $m2 = quest::get_data("CONV_F4_Mini2231_${cid}") || 0;
            my $m3 = quest::get_data("CONV_F4_Mini2232_${cid}") || 0;

            my $given = "CONV_F4_KeyGiven_${cid}";
            my $done  = quest::get_data($given) || 0;

            if ($count >= 12 && ($m1 || $m2 || $m3) && !$done) {
                plugin::GrantKeyIfMissing($pc, $EMBER_KEY_ID, "Ember Key", "Floor 5");
                quest::set_data($given, 1);
                $pc->Message(15, "The air cools as the Ember Key binds to your essence.");
            }
        }

        # ---------------------------
        # Floor 5 → Eclipse Key
        # ---------------------------
        if ($F5_TRASH{$id} || $F5_MINIS{$id}) {
            my $ess_key = "CONV_F5_EssenceCount_${cid}";
            my $mini_key = "CONV_F5_Mini2233_${cid}";
            my $given    = "CONV_F5_KeyGiven_${cid}";

            my $count = quest::get_data($ess_key) || 0;

            if ($F5_TRASH{$id} && $count < $F5_ESSENCE_REQ) {
                $count++;
                quest::set_data($ess_key, $count);
                $pc->Message(15, "You have gathered an essence of Floor 5 [$count/$F5_ESSENCE_REQ]");
                quest::debug("[F5] Essence +1 (npc=$id, cid=$cid) -> $count") if $DBG;
            }

            if ($F5_MINIS{$id}) {
                unless (quest::get_data($mini_key)) {
                    quest::set_data($mini_key, 1);
                    $pc->Message(13, "🌑 You have absorbed the voidlight essence of the Lanternless!");
                }
            }

            my $mflag = quest::get_data($mini_key) || 0;
            my $done  = quest::get_data($given)    || 0;

            if ($count >= $F5_ESSENCE_REQ && $mflag && !$done) {
    plugin::GrantKeyIfMissing($pc, $UMBRAL_KEY_ID, $UMBRAL_KEY_NAME, "Floor 6");
    quest::set_data($given, 1);
    $pc->Message(15, "A hush falls as the $UMBRAL_KEY_NAME binds to your essence.");
    quest::debug("[F5] Umbral Key granted (cid=$cid)") if $DBG;
}
        }
    }
}