#a_coven_wolf
# Hunts nearby players; despawns after 3 minutes if idle
# Grants 1 Lair of Terris Thule essence on death
# Applies progression-era stats dynamically via plugin::era_stats

my $warned_once = 0;  # flag to prevent repeated messages

sub EVENT_SPAWN {
    return unless $npc;

    # === Apply Era-based Stats ===
    my $is_boss = 0;
    my $era = "antonica";  # default fallback

    my @clients = $entity_list->GetClientList();
    if (@clients) {
        my $c = $clients[0];
        $era = plugin::DetermineEraForClient($c);
    }

    plugin::ApplyEraStats($npc, $era, $is_boss);

    # === AI Timers ===
    quest::settimer("hunt", 1);           # Start hunt logic immediately
    quest::settimer("self_despawn", 180); # Depop after 3 minutes if idle
    $warned_once = 0;                     # reset per spawn
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();
        @clients = grep { !$_->GetGM() } @clients;  # Ignore GMs

        if (@clients) {
            my $target = $clients[rand @clients];

            # Only send the message once per NPC spawn
            if (!$warned_once) {
                $target->Message(15, "You feel like you are being watched...");
                $warned_once = 1;
            }

            # Move toward the selected player
            $npc->MoveTo(
                $target->GetX(),
                $target->GetY(),
                $target->GetZ(),
                $npc->GetHeading(),
                true
            );

            # Stop despawn once the wolf starts hunting
            quest::stoptimer("self_despawn");
        }

        quest::settimer("hunt", 5); # Continue hunting every 5 seconds
    }
    elsif ($timer eq "self_despawn") {
        $npc->Depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");
    quest::stoptimer("self_despawn");

    # ===========================================================
    # Essence Tracking — Mirrors Lair of Terris Thule logic
    # ===========================================================
    my $ent = $entity_list->GetMobID($killer_id);
    return unless $ent;

    my $client;

    if ($ent->IsClient()) {
        $client = $ent->CastToClient();
    } elsif ($ent->IsPet()) {
        my $owner = $ent->GetOwner();
        $client = $owner->IsClient() ? $owner->CastToClient() : undef if $owner;
    } elsif ($ent->IsBot()) {
        my $owner = $ent->CastToBot()->GetOwner();
        $client = $owner->CastToClient() if $owner && $owner->IsClient();
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

    # --- Essence Count Update ---
    foreach my $pc (@ip_clients) {
        next unless $pc && $pc->IsClient();
        my $cid = $pc->CharacterID();
        my $essence_key    = "PoTerris_EssenceCount_${cid}";
        my $completion_key = "PoTerris_EssenceComplete_${cid}";

        # Skip if already completed
        next if quest::get_data($completion_key);

        my $count = quest::get_data($essence_key) || 0;
        $count++;
        quest::set_data($essence_key, $count);

        $pc->Message(15, "You have gathered an essence from the Lair of Terris Thule [$count / 2000]");

        if ($count >= 2000) {
            quest::set_data($completion_key, 1);
            $pc->Message(13, "You have gathered 2000 essences from the Lair of Terris Thule! The nightmares bow to your will...");
        }
    }
}