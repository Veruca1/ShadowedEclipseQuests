# ===========================================================
# 2251.pl - Haunted Apparition (hub-aware, robust era detect)
# ===========================================================

my $target_charid = 0;
my $scaled_once   = 0;

# Hubs / safe zones where combat is disabled by design
my %SAFE_ZONES = map { $_ => 1 } qw(
  nexus poknowledge bazaar guildlobby guildhall shadowhaven
);

sub EVENT_SPAWN {
    quest::debug("2251 spawned; waiting for haunt_charid...");

    # Reset per-spawn variables
    $target_charid = 0;
    $scaled_once   = 0;
    $npc->SetEntityVariable("haunt_warned", 0);

    # Always start tag polling for every spawn
    quest::settimer("await_tag", 1);

    # Movement defaults
    $npc->ModifyNPCStat("runspeed", 12);
    $npc->ModifyNPCStat("walkspeed", 8);
}

sub EVENT_TIMER {
    # Wait for haunt_charid assignment
    if ($timer eq "await_tag") {
        my $charid = $npc->GetEntityVariable("haunt_charid") || 0;
        if ($charid) {
            $target_charid = $charid;
            quest::stoptimer("await_tag");
            quest::debug("2251 haunt_charid linked to charid $target_charid");

            _scale_to_target_era();
            quest::settimer("hunt_target", 5);
            quest::settimer("autodepop", 90);
        }
        return;
    }

    # Hunt the assigned player
    if ($timer eq "hunt_target") {
        my $target = $entity_list->GetClientByCharID($target_charid);
        if ($target && $target->IsClient() && !$target->GetGM()) {
            my ($x, $y, $z) = ($target->GetX(), $target->GetY(), $target->GetZ());

            # Move and engage target
            $npc->MoveTo($x, $y, $z, $npc->GetHeading(), 1);
            $npc->AddToHateList($target, 1, 500);

            # Only message once per haunt to prevent spam
            if (!$npc->GetEntityVariable("haunt_warned")) {
                $target->Message(13, "The air turns bitterly cold... something hunts you from beyond.");
                $npc->SetEntityVariable("haunt_warned", 1);
            }
        }
        return;
    }

    # Automatic despawn
    if ($timer eq "autodepop") {
        quest::stoptimer("autodepop");
        quest::depop();
        return;
    }
}

# ===========================================================
# Era scaling logic with hub-awareness and flag fallback
# ===========================================================
sub _scale_to_target_era {
    return if $scaled_once;
    my $c = $entity_list->GetClientByCharID($target_charid);
    return unless $c && $c->IsClient();

    # Optional override for testing
    my $override = quest::get_data("SE_era_" . $target_charid);
    if ($override && $override =~ /^(antonica|kunark|velious|luclin|pop)$/i) {
        my $era = lc $override;
        plugin::ApplyEraStats($npc, $era, 0);
        _maybe_set_kos_in_combat_zones();
        quest::debug("2251 era override used: $era; faction 623 applied if combat zone");
        $scaled_once = 1;
        return;
    }

    # Era detect via zone flags
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220],
    );

    my $era = "antonica";
    my $hit = "";
    ERA: for my $e (qw(pop luclin velious kunark antonica)) {
        for my $zoneid (@{$eras{$e}}) {
            if ($c->HasZoneFlag($zoneid)) { $era = $e; $hit = $zoneid; last ERA; }
        }
    }
    quest::debug("2251 era detect => $era (matched zoneflag $hit)") if $hit ne "";

    # Fallback by level
    if ($era eq "antonica") {
        my $lvl = $c->GetLevel();
        if    ($lvl >= 60) { $era = "pop"; }
        elsif ($lvl >= 55) { $era = "luclin"; }
        elsif ($lvl >= 50) { $era = "velious"; }
        elsif ($lvl >= 46) { $era = "kunark"; }
        quest::debug("2251 fallback era by level ($lvl) => $era");
    }

    plugin::ApplyEraStats($npc, $era, 0);
    _maybe_set_kos_in_combat_zones();
    quest::debug("2251 scaled for $era era; " .
                 ( _is_safe_zone() ? "hub zone (no combat)" : "faction 623 set (KOS)") );

    $scaled_once = 1;
}

# ===========================================================
# Helper subs
# ===========================================================
sub _maybe_set_kos_in_combat_zones {
    return if _is_safe_zone();
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);
}

sub _is_safe_zone {
    my $short = $zone->GetShortName() || "";
    return exists $SAFE_ZONES{$short};
}

sub EVENT_SIGNAL {
    if ($signal == 99) { quest::depop(); }
}