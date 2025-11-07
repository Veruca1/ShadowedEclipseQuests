# Black Mirror Portal NPC (PoNightmareB version)
# - Tints black mirror style (index 30) on spawn
# - Depops after 10 minutes if unused
# - Only interacts with players who have the Eclipsed Midnight Mirror + The Scared Self buff
# - Grants San Junipero flag to group/raid members on shared IP
# - Creates DZ to soltemple v1 on answer
# - "ready" moves player into active DZ

my $expedition_name_prefix = "DZ - ";
my $min_players = 1;
my $max_players = 12;
my $dz_duration = 21600; # 6 hours

my $item_id = 66728;    # Eclipsed Midnight Mirror of Nightmares
my $buff_id = 41246;    # The Scared Self
my $zone_flag_id = 80;  # San Junipero zone flag

my %zone_versions = (
    "soltemple" => {
        1 => "San Junipero",
    },
);

sub EVENT_SPAWN {
    return unless $npc;
    quest::settimer("depop", 600);
    quest::settimer("init_tint", 1);

    my @clients = $entity_list->GetClientList();
    my $text = "You have summoned The Black Mirror, hurry before it fades!";
    foreach my $c (@clients) {
        my $slot_item = $c->GetItemAt(22);
        my $has_item  = ($slot_item && $slot_item->GetID() == $item_id);
        my $has_buff  = ($c->FindBuff($buff_id) != -1);
        next unless $has_item && $has_buff;
        $c->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::stoptimer("depop");
        quest::depop();
    }
    elsif ($timer eq "init_tint") {
        quest::stoptimer("init_tint");
        $npc->SetNPCTintIndex(30);
    }
}

sub EVENT_SAY {
    return unless $client;

    my $slot_item = $client->GetItemAt(22);
    my $has_item  = ($slot_item && $slot_item->GetID() == $item_id);
    my $has_buff  = ($client->FindBuff($buff_id) != -1);

    return unless $has_item && $has_buff;

    if ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short_name = $dz->GetZoneName();
            plugin::Whisper("The portal shimmers... taking you to: $zone_short_name.");
            $client->MovePCDynamicZone($zone_short_name);
        } else {
            plugin::Whisper("There is no active dynamic zone bound to you. Create one first.");
        }
        return;
    }

    if ($text =~ /hail/i) {
        if (!$client->HasZoneFlag($zone_flag_id)) {
            my $clicker_ip = $client->GetIP();
            my $flagged = 0;

            if (my $group = $client->GetGroup()) {
                for (my $i = 0; $i < $group->GroupCount(); $i++) {
                    my $member = $group->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag($zone_flag_id)) {
                        $member->SetZoneFlag($zone_flag_id);
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, $client->GetCleanName() . " and their group members on the same IP have earned access to San Junipero!");
                }
            }
            elsif (my $raid = $client->GetRaid()) {
                for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                    my $member = $raid->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip && !$member->HasZoneFlag($zone_flag_id)) {
                        $member->SetZoneFlag($zone_flag_id);
                        $flagged = 1;
                    }
                }
                if ($flagged) {
                    quest::we(14, $client->GetCleanName() . " and their raid members on the same IP have earned access to San Junipero!");
                }
            }
            else {
                $client->SetZoneFlag($zone_flag_id);
                quest::we(14, $client->GetCleanName() . " has earned access to San Junipero!");
            }

            $client->Message(15, "Somewhere, a door opens where there was never a wall.");
        }

        plugin::Whisper("Where can you go if you die, to live forever... should you choose to upload your consciousness?");
        plugin::Whisper("If you know the answer, speak it aloud.");
        return;
    }

    if ($text =~ /^San\s+Junipero$/i) {
        my $zone_name = $zone_versions{"soltemple"}->{1};
        my $expedition_name = $expedition_name_prefix . "soltemple";
        my $dz = $client->CreateExpedition("soltemple", 1, $dz_duration, $expedition_name, $min_players, $max_players);

        if ($dz) {
            plugin::Whisper("The portal to '$zone_name' begins to form. Tell me when you are [" . quest::saylink("ready", 1, "ready") . "] to enter.");
            quest::depop();
        } else {
            plugin::Whisper("Something interfered with the portal creation. Try again.");
        }
        return;
    }

    plugin::Whisper("I do not understand. Answer the question... or be gone.");
}