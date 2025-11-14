# ===========================================================
# default.pl — Lair of Terris Thule (PoTerris)
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
    # Exclusion list — skip scaling/stat logic for specific NPCs
    # ===========================================================
    my $exclusion_list = {
        2261 => 1,   # The_Dreamforged_Horror
    };
    return if exists $exclusion_list->{$npc_id};

    # ===========================================================
    # General setup
    # ===========================================================
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);
    
    # === Baseline stats ===
    my $base_stats = $is_boss ? {
        level       => 66,
        ac          => 35000,
        max_hp      => 200000000,
        hp_regen    => 4000,
        min_hit     => 60000,
        max_hit     => 110000,
        atk         => 2700,
        accuracy    => 2200,
        hst         => 40,
        slow_mit    => 95,
        aggro       => 65,
        assist      => 1,
        str => 1300, sta => 1300, agi => 1300, dex => 1300,
        wis => 1300, int => 1300, cha => 1000,
        mr => 450, fr => 450, cr => 450, pr => 450, dr => 450,
        corr => 600, phys => 1100,
        sa => "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1",
    } : {
        level       => 63,
        ac          => 22000,
        max_hp      => 20000000,
        hp_regen    => 1000,
        min_hit     => 45000,
        max_hit     => 58000,
        atk         => 2400,
        accuracy    => 1900,
        hst         => 30,
        slow_mit    => 80,
        aggro       => 55,
        assist      => 1,
        str => 1050, sta => 1050, agi => 1050, dex => 1050,
        wis => 1050, int => 1050, cha => 850,
        mr => 320, fr => 320, cr => 320, pr => 320, dr => 320,
        corr => 350, phys => 850,
        sa => "3,1^5,1^7,1^8,1^9,1^10,1^14,1",
    };

    _apply_baseline($base_stats);
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

    $npc->ModifyNPCStat("level",     $s->{level});
    $npc->ModifyNPCStat("ac",        $s->{ac});
    $npc->ModifyNPCStat("max_hp",    $s->{max_hp});
    $npc->ModifyNPCStat("hp_regen",  $s->{hp_regen});
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   $s->{min_hit});
    $npc->ModifyNPCStat("max_hit",   $s->{max_hit});
    $npc->ModifyNPCStat("atk",       $s->{atk});
    $npc->ModifyNPCStat("accuracy",  $s->{accuracy});
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", $s->{hst});
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", $s->{slow_mit});
    $npc->ModifyNPCStat("aggro", $s->{aggro});
    $npc->ModifyNPCStat("assist", $s->{assist});

    $npc->ModifyNPCStat("str", $s->{str});
    $npc->ModifyNPCStat("sta", $s->{sta});
    $npc->ModifyNPCStat("agi", $s->{agi});
    $npc->ModifyNPCStat("dex", $s->{dex});
    $npc->ModifyNPCStat("wis", $s->{wis});
    $npc->ModifyNPCStat("int", $s->{int});
    $npc->ModifyNPCStat("cha", $s->{cha});

    $npc->ModifyNPCStat("mr", $s->{mr});
    $npc->ModifyNPCStat("fr", $s->{fr});
    $npc->ModifyNPCStat("cr", $s->{cr});
    $npc->ModifyNPCStat("pr", $s->{pr});
    $npc->ModifyNPCStat("dr", $s->{dr});
    $npc->ModifyNPCStat("corruption_resist", $s->{corr});
    $npc->ModifyNPCStat("physical_resist",   $s->{phys});

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

    my $npc_id   = $npc->GetNPCTypeID();
    my $raw_name = $npc->GetName() || '';

    if ($combat_state == 1) {
        # ===========================================================
        # Shadowed Eclipse — Dreamforged Horror Add-Trigger Link
        # ===========================================================
        # Any NPC entering combat (excluding 2261 itself) signals The_Dreamforged_Horror (2261)
        if ($npc_id != 2261) {
            quest::signalwith(2261, 9, 0);
            #quest::debug("DEBUG: NPC [$npc_id - $raw_name] engaged in combat, signaled 2261.");
        }

        # ===========================================================
        # Normal scaling + boss setup
        # ===========================================================
        if (!$scaled_spawn) {
            plugin::RaidScaling($entity_list, $npc);
            $scaled_spawn = 1;
        }

        my $hst = $is_boss ? 35 : 30;
        $npc->ModifyNPCStat("heroic_strikethrough", $hst);

        my $max_hp = $npc->GetMaxHP();
        $npc->SetHP($max_hp) if $max_hp > 0;

        quest::settimer("life_drain", 5) if $is_boss;

    } else {
        # ===========================================================
        # Combat End — Stop Add Spawning Logic
        # ===========================================================
        if ($npc_id != 2261) {
            quest::signalwith(2261, 10, 0);
            #quest::debug("DEBUG: NPC [$npc_id - $raw_name] left combat, signaled 2261 stop.");
        }

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
        my $dmg = 35000;

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

# ===========================================================
# Lair of Terris Thule - Trash Kill -> Essence Tracking
# ===========================================================
# - Every trash mob kill gives 1 essence.
# - Bosses (names starting with #) do not count.
# - After 2000 essences -> Permanent completion flag (no chest spawn).
# - Counter does NOT reset after completion.
# - Keys are zone-specific (PoTerris_*).

sub EVENT_DEATH_COMPLETE {
    return unless $npc;
    return if $npc->IsPet();

    my $raw_name = $npc->GetName() || '';
    return if $raw_name =~ /^#/;

    # --- Determine killer ---
    my $client;
    my $ent = $entity_list->GetMobID($killer_id);

    if ($ent) {
        if ($ent->IsClient()) {
            $client = $ent->CastToClient();
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            $client = $owner->IsClient() ? $owner->CastToClient() : undef if $owner;
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            $client = $owner->CastToClient() if $owner && $owner->IsClient();
        }
    }

    return unless $client;

    # --- Group/Raid shared IP check ---
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

    # --- Essence Count ---
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        my $cid = $pc->CharacterID();
        my $essence_key    = "PoTerris_EssenceCount_${cid}";
        my $completion_key = "PoTerris_EssenceComplete_${cid}";

        # If player already completed, skip tracking entirely
        next if quest::get_data($completion_key);

        my $count = quest::get_data($essence_key) || 0;
        $count++;
        quest::set_data($essence_key, $count);

        $pc->Message(15, "You have gathered an essence from the Lair of Terris Thule [$count / 2000]");

        if ($count >= 2000) {
            quest::set_data($completion_key, 1);
            $pc->Message(13, "You have gathered 2000 essences from the Lair of Terris Thule! The nightmares bow to your will...");
            # No reset; permanent flag
        }
    }
}