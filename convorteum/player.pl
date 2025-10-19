# quests/convorteum/player.pl

my $did_rescale = 0;  # only rescale once per instance

sub EVENT_ENTERZONE {
    return unless $client;

    my $inst_id = quest::GetInstanceID("convorteum", 1);
    if ($inst_id) {
        my $era = $qglobals{"era_" . $inst_id};

        if ($era && !$did_rescale) {
            my $entity_list = plugin::val('$entity_list');
            foreach my $npc ($entity_list->GetNPCList()) {
                next unless $npc;
                next if $npc->IsPet();

                my $raw_name = $npc->GetName() || '';
                my $is_boss  = ($raw_name =~ /^#/) ? 1 : 0;

                plugin::ApplyEraStats($npc, $era, $is_boss);
                plugin::RaidScaling($entity_list, $npc);
            }

            $client->Message(15, ">> Convorteum NPCs rescaled to [$era] era.");
            #plugin::Debug("Convorteum: Applied [$era] scaling on player entry (inst=$inst_id).");

            $did_rescale = 1;
        }
    }
}

sub EVENT_CLICKDOOR {
    if ($doorid == 8) {
        my $key_id = 56755;

        if (!$client->CountItem($key_id) && !$client->KeyRingCheck($key_id)) {
            $client->Message(13, "You must possess the correct key to activate this portal.");
            return;
        }

        my $instance_id = $client->GetInstanceID();
        if (defined $instance_id && $instance_id != 0) {
            quest::MovePCInstance(491, $instance_id, 1123.99, -819.13, 256.57, 330);
        } else {
            quest::movepc(491, 1123.99, -819.13, 256.57, 330);
        }

        if (!$client->KeyRingCheck($key_id)) {
            eval {
                $client->KeyRingAdd($key_id);
                #plugin::Debug("Key $key_id added to keyring for " . $client->GetName());
            };
        }
    }
}