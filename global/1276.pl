sub EVENT_SPAWN {
    return unless defined $npc;

    my $ownerid = $npc->GetOwnerID();

    plugin::pokemon_pet_spellcast($npc, { context => 'buff' });

    quest::settimer("check_inferno_shield", 30);
    quest::settimer("check_player_hp", 3);

if ($ownerid) {
    my $owner = $entity_list->GetMobByID($ownerid);
    if ($owner && $owner->IsClient()) {
        my $level = $owner->GetLevel();
        my $client = $owner->CastToClient();
        my $flag_rank = plugin::get_flag_rank($client);
        $npc->SetLevel($level);
        $npc->AddNimbusEffect(462);
        #quest::debug("[SPAWN] Calling scale_pet_stats for NPCID " . $npc->GetNPCTypeID() . " | Level $level | FlagRank $flag_rank");
        plugin::scale_pet_stats($npc, $level, $flag_rank);
        #quest::debug("[SPAWN] scale_pet_stats finished for NPCID " . $npc->GetNPCTypeID());
        #quest::debug("[SPAWN] Current DMG Range => Min: " . $npc->GetMinDMG() . " | Max: " . $npc->GetMaxDMG());
    }
}
}


# sub get_flag_rank {
#     ##quest::debug("[FlagRank] Checking zone flags for rank...");
#     my ($client) = @_;
#     return 0 unless $client && $client->IsClient();

#     my @zones = (63, 186, 97, 89, 103, 108, 110, 118, 119, 127, 124); # 11 total
#     ##quest::debug("[FlagRank] Checking zone flags for: " . ($client ? $client->GetCleanName() : 'NO CLIENT'));
#     foreach my $i (0..$#zones) {
#         my $zone_id = $zones[$i];
#         my $has_flag = $client->CastToClient()->HasZoneFlag($zone_id);
#         ##quest::debug("[FlagRank] Zone $zone_id => Flag: " . ($has_flag ? 1 : 0));
#         if ($has_flag) {
#             ##quest::debug("[FlagRank] Matched flag for zone ID $zone_id at rank " . ($i + 1));
#             return ($i + 1);
#         }
#     }
#     return 0;
# }

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::signalwith(1276, 1);
    }
}

sub EVENT_TIMER {
    $timer =~ s/^\s+|\s+$//g;

    if ($timer eq "check_inferno_shield") {
        plugin::pokemon_pet_spellcast($npc, { context => 'buff' });
        $npc->SetMana($npc->GetMaxMana());
    }

    elsif ($timer eq "check_player_hp") {
        if ($ownerid) {
            my $owner = $entity_list->GetMobByID($ownerid);
            if ($owner) {
                my $should_heal = 0;
                my $group;

                if ($owner->IsClient()) {
                    my $client = $owner->CastToClient();
                    $group = $client->GetGroup();
                } elsif ($owner->IsBot()) {
                    my $bot = $owner->CastToBot();
                    $group = $bot->GetGroup();
                }

                if ($group) {
                    for (my $i = 0; $i < $group->GroupCount(); $i++) {
                        my $member = $group->GetMember($i);
                        next unless $member;
                        if ($member->GetHPRatio() < 50) {
                            $should_heal = 1;
                            last;
                        }
                    }
                } elsif ($owner->GetHPRatio() < 50) {
                    $should_heal = 1;
                }

                # ✅ Check Charmander's own HP
                if ($npc->GetHPRatio() < 50) {
                    $should_heal = 1;
                }

                if ($should_heal) {
                    plugin::pokemon_pet_spellcast($npc, { context => 'heal' });
                    $npc->SetMana($npc->GetMaxMana());
                }
            }
        }
    }
}



sub EVENT_SIGNAL {
    if ($signal == 1) {
        my $now = time;
        if ($now - $last_timer_reset > 5) {
            start_timers();
            $last_timer_reset = $now;
        }
    }
}

sub start_timers {
    $ownerid = $npc->GetOwnerID();

    quest::stoptimer("check_inferno_shield");
    quest::stoptimer("check_player_hp");
    quest::settimer("check_inferno_shield", 30);
    quest::settimer("check_player_hp", 3);
}