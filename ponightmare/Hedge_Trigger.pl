# ===========================================================
# #Hedge_Trigger
# Global HP/Mana drain controller for the Hedge Maze event
# -----------------------------------------------------------
# Signal 5   → Starts 120s countdown, then begins:
#               - 45k HP/Mana drain every 6 seconds
#               - Spawns 1–2 NPC 2260 every minute
#               - Moves all players to maze start every 3 minutes
#               - Casts Thelin's Presence - Silence (ID 41242) every 1 minute
#               - 5 mins in, ground becomes lava (requires Spirit of Eagle)
# Signal 911 → Stops all drain, spawn, teleport, and lava
# ===========================================================

my $drain_active = 0;

sub EVENT_SIGNAL {
    if ($signal == 5) {
        quest::stoptimer("life_drain");
        quest::stoptimer("start_drain");
        quest::stoptimer("spawn_adds");
        quest::stoptimer("maze_move");
        quest::stoptimer("cast_silence");

        quest::settimer("start_drain", 120); # 2-minute buildup
        quest::ze(15, "The hedge stirs restlessly as dark energy builds in the air...");

        quest::settimer("lava_warning", 300); # === Lava Event === - Trigger warning after 5 mins
    }
    elsif ($signal == 911) {
        quest::stoptimer("start_drain");
        quest::stoptimer("life_drain");
        quest::stoptimer("spawn_adds");
        quest::stoptimer("maze_move");
        quest::stoptimer("cast_silence");
        quest::stoptimer("lava_warning");    # === Lava Event ===
        quest::stoptimer("lava_burn");       # === Lava Event ===
        $drain_active = 0;
        quest::ze(15, "The suffocating energy fades as the hedge’s curse breaks...");
    }
}

sub EVENT_TIMER {
    if ($timer eq "start_drain") {
        quest::stoptimer("start_drain");
        $drain_active = 1;

        quest::settimer("life_drain", 6);
        quest::settimer("spawn_adds", 60);
        quest::settimer("maze_move", 180);
        quest::settimer("cast_silence", 60);

        quest::ze(13, "A vile energy seeps into your body — the hedge begins to feed on your life force!");
    }

    elsif ($timer eq "life_drain" && $drain_active) {
        my $hp_drain   = 30000;
        my $mana_drain = 30000;

        foreach my $client ($entity_list->GetClientList()) {
            next if $client->GetGM();
            my $new_hp   = $client->GetHP()   - $hp_drain;
            my $new_mana = $client->GetMana() - $mana_drain;
            $client->SetHP($new_hp > 0 ? $new_hp : 1);
            $client->SetMana($new_mana > 0 ? $new_mana : 0);
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $new_hp   = $bot->GetHP()   - $hp_drain;
            my $new_mana = $bot->GetMana() - $mana_drain;
            $bot->SetHP($new_hp > 0 ? $new_hp : 1);
            $bot->SetMana($new_mana > 0 ? $new_mana : 0);
        }
    }

    elsif ($timer eq "spawn_adds" && $drain_active) {
        my $spawn_count = int(rand(2)) + 1;
        for (my $i = 0; $i < $spawn_count; $i++) {
            quest::spawn2(2260, 0, 0, -4549.21, 5143.27, 4.16, 3.25);
        }
        quest::ze(15, "The hedge groans as new horrors emerge from the thorns...");
    }

    elsif ($timer eq "maze_move" && $drain_active) {
        my $zone_id = 204;

        foreach my $client ($entity_list->GetClientList()) {
            next if $client->GetGM();
            my $instance_id = $client->GetInstanceID();

            if ($instance_id > 0) {
                $client->MovePCInstance($zone_id, $instance_id, -4774, 5198, 4, 0);
            } else {
                $client->MovePC($zone_id, -4774, 5198, 4, 0);
            }

            $client->Message(15, "The hedge shifts around you, dragging you back to the entrance...");
        }

        quest::ze(13, "The hedge twists and reshapes itself, forcing wanderers back to the start...");
    }

    elsif ($timer eq "cast_silence" && $drain_active) {
        my $spell_id = 41242;

        foreach my $client ($entity_list->GetClientList()) {
            next if $client->GetGM();
            quest::crosszonecastspellbycharid($client->CharacterID(), $spell_id);
            $client->Message(15, "A crushing silence invades your mind...");
        }

        foreach my $bot ($entity_list->GetBotList()) {
            $bot->SpellFinished($spell_id, $bot);
            $bot->Message(15, "A crushing silence invades your mind...");
        }
    }

    # === Lava Event ===
    elsif ($timer eq "lava_warning") {
        quest::stoptimer("lava_warning");

        my $text = "The ground slowly turns to lava, use spirit of eagle quickly!";
        foreach my $client ($entity_list->GetClientList()) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
        }

        quest::settimer("lava_burn", 6); # Apply lava damage every 6 seconds
    }

    elsif ($timer eq "lava_burn") {
        foreach my $client ($entity_list->GetClientList()) {
            next if $client->GetGM();

            if (!$client->FindBuff(2517)) { # 2517 = Spirit of Eagle
                my $new_hp = $client->GetHP() - 50000;
                $client->SetHP($new_hp > 0 ? $new_hp : 1);
                $client->Message(15, "Lava scorches your body!");
            }
        }
    }
}