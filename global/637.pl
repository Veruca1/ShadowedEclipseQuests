    sub EVENT_SPAWN {
        $ownerid = $npc->GetOwnerID();

        if ($ownerid) {
            my $owner = $entity_list->GetMobByID($ownerid);
            if ($owner && $owner->IsClient()) {
                my $level = $owner->GetLevel();
                my $client = $owner->CastToClient();
                my $flag_rank = plugin::get_flag_rank($client);
                $npc->SetLevel($level);
                $npc->AddNimbusEffect(649);
                plugin::scale_pet_stats($npc, $level, $flag_rank);
            }
        }

        quest::settimer("bulbasaur_dot", 8);
        quest::settimer("bulbasaur_regen", 30);
    }

    # sub get_flag_rank {
    #     #quest::debug("[FlagRank] Checking zone flags for rank...");
    #     my ($client) = @_;
    #     return 0 unless $client && $client->IsClient();

    #     my @zones = (63, 186, 97, 89, 103, 108, 110, 118, 119, 127, 124); # 11 total
    #     #quest::debug("[FlagRank] Checking zone flags for: " . ($client ? $client->GetCleanName() : 'NO CLIENT'));
    #     foreach my $i (0..$#zones) {
    #         my $zone_id = $zones[$i];
    #         my $has_flag = $client->CastToClient()->HasZoneFlag($zone_id);
    #         #quest::debug("[FlagRank] Zone $zone_id => Flag: " . ($has_flag ? 1 : 0));
    #         if ($has_flag) {
    #             #quest::debug("[FlagRank] Matched flag for zone ID $zone_id at rank " . ($i + 1));
    #             return ($i + 1);
    #         }
    #     }
    #     return 0;
    # }

    sub EVENT_TIMER {
        if ($timer eq "bulbasaur_dot") {
            plugin::pokemon_pet_spellcast($npc, { context => 'dot' });
        } elsif ($timer eq "bulbasaur_regen") {
            plugin::pokemon_pet_spellcast($npc, { context => 'regen' });
        }
    }
