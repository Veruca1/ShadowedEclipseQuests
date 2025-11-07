#a_coven_wolf
# Hunts nearby players; despawns after 3 minutes if idle
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
}