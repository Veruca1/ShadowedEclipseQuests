sub EVENT_KILLED_MERIT {
    my $char_id = $client->CharacterID();
    my $npc_level = $npc->GetLevel();
   
    # Define items and their keys for player items
    my %player_items = (
        28113 => { next_item_id => 28114, key => "$char_id-28113", threshold => 750, level_requirement => 55 },
        28114 => { next_item_id => 28623, key => "$char_id-28114", threshold => 750, level_requirement => 55 },
        28623 => { next_item_id => 31647, key => "$char_id-28623", threshold => 750, level_requirement => 55 },
        31647 => { next_item_id => 31648, key => "$char_id-31647", threshold => 750, level_requirement => 55 },
        31648 => { next_item_id => 32463, key => "$char_id-31648", threshold => 750, level_requirement => 55 },
        32463 => { next_item_id => 32464, key => "$char_id-32463", threshold => 750, level_requirement => 55 },
        32464 => { next_item_id => 33024, key => "$char_id-32464", threshold => 750, level_requirement => 55 },
        33024 => { next_item_id => 33025, key => "$char_id-33024", threshold => 750, level_requirement => 55 },
        33025 => { next_item_id => 33026, key => "$char_id-33025", threshold => 750, level_requirement => 55 },

        # New item entry for 399 with level requirement 60 and threshold 1000
        399 => { next_item_id => 400, key => "$char_id-399", threshold => 1000, level_requirement => 60 },
    );

    # Define items and their keys for bot items
    my %bot_items = (
        28113 => { next_item_id => 28114, key => "$char_id-bot-28113", threshold => 750, level_requirement => 55 },
        28114 => { next_item_id => 28623, key => "$char_id-bot-28114", threshold => 750, level_requirement => 55 },
        28623 => { next_item_id => 31647, key => "$char_id-bot-28623", threshold => 750, level_requirement => 55 },
        31647 => { next_item_id => 31648, key => "$char_id-bot-31647", threshold => 750, level_requirement => 55 },
        31648 => { next_item_id => 32463, key => "$char_id-bot-31648", threshold => 750, level_requirement => 55 },
        32463 => { next_item_id => 32464, key => "$char_id-bot-32463", threshold => 750, level_requirement => 55 },
        32464 => { next_item_id => 33024, key => "$char_id-bot-32464", threshold => 750, level_requirement => 55 },
        33024 => { next_item_id => 33025, key => "$char_id-bot-33024", threshold => 750, level_requirement => 55 },
        33025 => { next_item_id => 33026, key => "$char_id-bot-33025", threshold => 750, level_requirement => 55 },

        # New item entry for 399 with level requirement 60 and threshold 1000 for bot
        399 => { next_item_id => 400, key => "$char_id-bot-399", threshold => 1000, level_requirement => 60 },
    );

    # Function to handle progression of items for either bots or players
    sub process_item_progression {
        my ($entity, $items_ref, $is_bot, $bot_name) = @_;

        # Detect the item equipped by the bot
        my $equipped_item_id;
        if ($is_bot) {
            $equipped_item_id = $entity->GetBotItemIDBySlot(0);  # Get item in primary slot
        } else {
            $equipped_item_id = $client->GetItemIDAt(0);  # For players
        }

        # Check if we have a valid equipped item
        return unless defined $equipped_item_id;

        foreach my $item_id (keys %{$items_ref}) {
            # Only proceed if the equipped item matches this entry
            next unless $equipped_item_id == $item_id;

            my $item_info = $items_ref->{$item_id};
            my $key = $item_info->{key};
            my $next_item_id = $item_info->{next_item_id};
            my $threshold = $item_info->{threshold};
            my $level_requirement = $item_info->{level_requirement};

            # Level check for the item
            next unless $npc_level >= $level_requirement;

            # Generate a unique key for each bot based on their name and item id
            if ($is_bot) {
                $key = "16-" . $bot_name . "-$item_id";  # Unique key for each bot using bot name and item ID
            }

            # Retrieve current kill count or initialize if none
            my $kill_count = quest::get_data($key) || 0;
            $kill_count++;

            # Save updated kill count
            quest::set_data($key, $kill_count);

            # If bot, send kill count message only to the player (not to the bot itself)
            if ($is_bot) {
                $client->Message(5, "Bot $bot_name has killed: $kill_count NPCs.");
            } else {
                $client->Message(5, "You have killed: $kill_count NPCs while using item $item_id.");
            }

            # Check if kill count meets upgrade threshold
if ($kill_count >= $threshold) {
    if ($is_bot) {
        # Bot: Remove the current item from the bot's inventory
        $entity->RemoveBotItem($equipped_item_id);  # Remove the item by ID (equipped item)
        
        # Equip the upgraded item in the bot's primary slot (slot 0)
        $entity->AddBotItem(0, $next_item_id, 1);  # Add the new item to slot 0 with 1 charge
        $client->Message(14, "Your bot $bot_name has upgraded to item $next_item_id.");
    } else {
        # Player: Remove the current item and equip the upgraded one
        $client->NukeItem($equipped_item_id);  # Remove the old item
        $client->SummonItem($next_item_id, 1, 0);  # Equip the new item
        $client->Message(14, "Congrats, the item has been upgraded to item $next_item_id.");
    }

    # Reset kill count and carry over remaining kills
    my $remaining_kills = $kill_count - $threshold;
    quest::set_data($items_ref->{$next_item_id}{key}, $remaining_kills);
}
        }
    }

    # Process player item progression
    process_item_progression($client, \%player_items, 0);

    # Process bot item progression using GetBotList to get all bots in the zone
    my @bot_list = $entity_list->GetBotList();
    foreach my $bot (@bot_list) {
        my $bot_id = $bot->GetBotID();
        my $bot_name = quest::GetBotNameByID($bot_id);  # Get the bot's name
        process_item_progression($bot, \%bot_items, 1, $bot_name);
    }


    # ---- Heirloom Checking Logic ----
    my $heirloom_item_id = 473;  # The heirloom item

    # Check if item 473 (heirloom) is in the powersource slot (slot 21)
    my $slot_id = 21;
    my $equipped_item_id = $client->GetItemIDAt($slot_id);

    return unless defined $equipped_item_id && $equipped_item_id == $heirloom_item_id;

    # Ensure the NPC is at least level 65 for the kill to count
return unless $npc_level >= 65;

my $heirloom_key = "$char_id-$heirloom_item_id";
my $heirloom_kill_count = quest::get_data($heirloom_key) || 0;
$heirloom_kill_count++;
quest::set_data($heirloom_key, $heirloom_kill_count);

    # Notify the player of heirloom progress
    $client->Message(5, "Your heirloom item has absorbed $heirloom_kill_count kills.");

    # Upgrade the heirloom item if threshold is met
    my $heirloom_kill_threshold = 750;
    if ($heirloom_kill_count >= $heirloom_kill_threshold) {
        my %heirloom_class_upgrades = (
            1  => 600254, # Warrior - Glacierheart Core
            2  => 600246, # Cleric - Crystal of Eternal Winter
            3  => 600256, # Paladin - Sanctified Frost Core
            4  => 600260, # Ranger - Winterfang Core
            5  => 600255, # Shadow Knight - Abyssal Ice Core
            6  => 600248, # Druid - Snowbloom Essence
            7  => 600258, # Monk - Frosted Spirit Stone
            8  => 600261, # Bard - Echoing Ice Gem
            9  => 600257, # Rogue - Icefang Crystal
            10 => 600247, # Shaman - Frostbound Spirit Core
            11 => 600252, # Necromancer - Wraithfrost Core
            12 => 600249, # Wizard - Glacial Conflagration Core
            13 => 600250, # Magician - Frigid Elemental Core
            14 => 600251, # Enchanter - Frostveil Shard
            15 => 600253, # Beastlord - Frostclaw Essence
            16 => 600259, # Berserker - Avalanche Shard
        );

        my $player_class = $client->GetClass();
        my $upgraded_item_id = $heirloom_class_upgrades{$player_class};

        if ($upgraded_item_id) {
            $client->DeleteItemInInventory($slot_id, 1, true); # Remove heirloom
            $client->SummonItem($upgraded_item_id);           # Summon upgraded heirloom
            $client->Message(14, "Congrats! Your heirloom has evolved into a class-specific item: $upgraded_item_id.");
            quest::delete_data($heirloom_key);
        } else {
            $client->Message(13, "Error: No upgrade defined for your class.");
        }
    }

my $killer_name = "Unknown";  # Global variable to store the killer's name

sub EVENT_ITEM_CLICK {
  return unless defined($client) && $client->IsClient() && $itemid == 33212 && $zoneid == 156;

  my $char_id = $client->CharacterID();
  my $flag = quest::get_data("paludal_boss_unlock_" . $char_id);

  my $saylink_checkpoint = quest::saylink("checkpoint", 1);
  my $saylink_boss = quest::saylink("boss", 1);

  if (defined($flag) && $flag == 1) {
    quest::say("Where would you like to go? $saylink_checkpoint or $saylink_boss?");
  } else {
    quest::say("The path to the boss is blocked... perhaps defeating a powerful guardian could unlock it. You may still say $saylink_checkpoint to proceed.");
  }
}

sub EVENT_COMBAT {
    if ($zoneid == 123) {  # Only activate in zone 123
        if ($combat_state == 1) {  # Engaged in combat
            quest::settimer("check_swarm_pets", 5);  # Check every 5 seconds
        } else {  # Out of combat
            quest::stoptimer("check_swarm_pets");
        }
    }
}


sub EVENT_TIMER {
    if ($zoneid == 123 && $timer eq "check_swarm_pets") {
        my $swarm_npc = $entity_list->GetNPCByNPCTypeID(681);
        if ($swarm_npc) {
            $swarm_npc->Depop();

            # Notify all players in the zone
            foreach my $entity ($entity_list->GetClientList()) {
                $entity->Message(14, "Your swarm pets have been absolutely obliterated! Maybe try a bigger bug zapper?");
            }
        }
    }
}

sub EVENT_DEATH {
    if ($client) {  # Ensure we have a valid client
        $killer_name = $client->GetCleanName();
        $npc->SetEntityVariable("killer_name", $killer_name);
    } else {
        $npc->SetEntityVariable("killer_name", "Unknown");
    }
}

sub EVENT_DEATH_COMPLETE {
    plugin::double_loot($killer_id, 12345, $npc->GetID(), $entity_list);
    plugin::auto_loot($killer_id, $killed_corpse_id, $entity_list);
if ($killer_id && $entity_list) {
    my $killer = $entity_list->GetMobByID($killer_id);
    my $client;
    my $resolved_by = "None";

    if ($killer) {
        if ($killer->IsClient()) {
            $client = $killer->CastToClient();
            $resolved_by = "Direct client kill";
        } elsif ($killer->IsPet() || $killer->IsBot()) {
            my $owner = $killer->GetOwner();
            if ($owner) {
                if ($owner->IsClient()) {
                    $client = $owner->CastToClient();
                    $resolved_by = "Pet/Bot owner";
                } elsif ($owner->IsBot()) {
                    my $bot_owner = $owner->GetOwner();
                    if ($bot_owner && $bot_owner->IsClient()) {
                        $client = $bot_owner->CastToClient();
                        $resolved_by = "Bot pet → bot → client owner";
                    }
                }
            }
        }
    }

    if ($client) {
        my $char_id = $client->CharacterID();
        my $debug_enabled = quest::get_data("autoloot:$char_id:debug") // 0;

        if ($debug_enabled) {
            my $npc_name = $npc->GetCleanName() || "UnknownNPC";
            my $killer_name = $killer ? ($killer->GetCleanName() || "UnknownKiller") : "NoKiller";
            my $client_name = $client->GetCleanName() || "UnknownClient";
            $client->Message(15, "[AutoLoot Debug] EVENT_DEATH_COMPLETE: [$npc_name] killed by [$killer_name]. Resolved Client: [$client_name] via [$resolved_by].");
          #  quest::debug("[AutoLoot Debug] EVENT_DEATH_COMPLETE: [$npc_name] killed by [$killer_name]. Resolved Client: [$client_name] via [$resolved_by].");
        }
    }
}
    # Retrieve the killer's name stored in EVENT_DEATH
    my $player_name = $npc->GetEntityVariable("killer_name") || "Unknown";

    # Define the zone ID for Tower of Frozen Shadow
    my $tofs_zone_id = 111;

    # List of NPC IDs to be excluded from spawning NPC 1618
    my @excluded_npc_ids = (1618, 1619, 1620, 1621, 1622, 1624, 1640, 1693);

    # Check if the current zone is Tower of Frozen Shadow
    if ($zoneid == $tofs_zone_id) {
        my $dead_npc_id = $npc->GetNPCTypeID();

        if (!grep { $_ == $dead_npc_id } @excluded_npc_ids) {
            my $chance_to_spawn = 15;
            my $random_chance = int(rand(100)) + 1;

            if ($random_chance <= $chance_to_spawn) {
                my $npc_to_spawn = 1618;
                my $current_count = quest::countspawnednpcs($npc_to_spawn);

                if ($current_count < 3) {
                    my $x = $npc->GetX();
                    my $y = $npc->GetY();
                    my $z = $npc->GetZ();
                    my $h = $npc->GetHeading();

                    quest::spawn2($npc_to_spawn, 0, 0, $x, $y, $z, $h);
                    #quest::gmsay("NPC 1618 has spawned at $x, $y, $z.", 14, 1, 0, 0);
                }
            }
        }

        # Check if NPC is NPC ID 1814 for a 25% chance to explode with 35k damage
        if ($npc->GetNPCTypeID() == 1814) {
            my $random_chance = int(rand(100)) + 1;
            if ($random_chance <= 50) {
                my $damage = 30000;  # 30,000 damage for NPC 1814 in Tower of Frozen Shadow
                my $radius = 40;  # Radius for checking proximity
                my $npc_x = $npc->GetX();
                my $npc_y = $npc->GetY();
                my $npc_z = $npc->GetZ();

                # Apply damage to players in the zone
                foreach my $entity ($entity_list->GetClientList()) {
                    if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                        $entity->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                        $entity->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                    }
                }

                # Apply damage to bots in the zone
                foreach my $bot ($entity_list->GetBotList()) {
                    if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                        #$bot->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                        $bot->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                    }
                }

                # Apply damage to pets of players
                foreach my $entity ($entity_list->GetClientList()) {
                    my $pet = $entity->GetPet();
                    if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                        $pet->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                        $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                    }
                }

                # Apply damage to pets of bots
                foreach my $bot ($entity_list->GetBotList()) {
                    my $pet = $bot->GetPet();
                    if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                        $pet->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                        $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                    }
                }
            }
        }
    }

# Check if the current zone is Necropolis (Zone ID 123) and apply additional damage with a 25% chance
if ($zoneid == 123 && !$damage_applied) {
    my $damage = 10000;  # 10,000 damage
    my $radius = 40;  # Radius for checking proximity
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();

    # Random chance for 25% chance to apply damage
    my $random_chance = int(rand(100)) + 1;
    if ($random_chance <= 25) {
        # Apply damage to players in the zone
        foreach my $entity ($entity_list->GetClientList()) {
            if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $entity->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                $entity->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
            }
        }

        # Apply damage to bots in the zone
        foreach my $bot ($entity_list->GetBotList()) {
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                #$bot->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                $bot->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
            }
        }

        # Apply damage to pets of players
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
            }
        }

        # Apply damage to pets of bots
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Message(14, "A massive shockwave erupts as the creature dies, causing massive damage!");
                $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
            }
        }

        # Set the flag to indicate damage has been applied
        $damage_applied = 1;
    }
    
    # Check if the NPC is Phase Spider (1793) or Phase Spiderling (1791)
    if ($npc->GetNPCTypeID() == 1793 || $npc->GetNPCTypeID() == 1791) {
        # 40% chance to spawn Veil Spider (1792)
        my $spawn_chance = int(rand(100)) + 1;
        if ($spawn_chance <= 40) {
            # Spawn Veil Spider (NPC ID 1792) at the NPC's location
            quest::spawn2(1792, 0, 0, $npc_x, $npc_y, $npc_z, $npc->GetHeading());
        }
    }
}

    # Check if the NPC is a raid target or rare spawn and handle death announcement
    if ($npc->IsRaidTarget() || $npc->IsRareSpawn()) {
        my $npc_name = $npc->GetCleanName();

        # Announce in-game
        quest::gmsay("$npc_name has been killed by $player_name", 14, 1, 0, 0);

        # Send message to Discord
        quest::discordsend("victory", "$npc_name has been killed by $player_name");
    } 
}
}