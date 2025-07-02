# Arena Zone Script - Fixed version for default.pl

sub EVENT_SPAWN {
    quest::debug("Arena Zone: EVENT_SPAWN triggered");
    
    # Extensive safety checks
    if (!defined($npc)) {
        return;
    }
    if (!$npc->IsNPC()) {
        return;
    }
    quest::debug("Arena Zone: NPC validation passed");

    my $raw_name = '';
    my $npc_id = 0;
    
    # Safely get NPC info
    eval {
        $raw_name = $npc->GetName() || '';
        $npc_id = $npc->GetNPCTypeID() || 0;
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error getting NPC info: $@");
        return;
    }
    
    quest::debug("Arena Zone: NPC ID: $npc_id, Name: '$raw_name'");

    # Skip excluded NPCs and pets using plugin function
    eval {
        if (plugin::arena_is_excluded_npc($npc_id)) {
            quest::debug("Arena Zone: NPC $npc_id is in exclusion list, skipping");
            return;
        }
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error checking exclusion list: $@");
        return;
    }
    
    # Check if it's a pet
    eval {
        if ($npc->IsPet()) {
            quest::debug("Arena Zone: NPC $npc_id is a pet, skipping");
            return;
        }
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error checking if pet: $@");
        return;
    }
    
    quest::debug("Arena Zone: NPC $npc_id passed exclusion checks");
    
    # Get entity list safely
    my $zone_entity_list = undef;
    eval {
        $zone_entity_list = $entity_list;
    };
    
    # If entity_list isn't available in this context, try to get it another way
    if (!defined($zone_entity_list)) {
        eval {
            $zone_entity_list = quest::get_entity_list();
        };
        
        if ($@) {
            quest::debug("Arena Zone: Could not get entity_list: $@");
        }
    }
    
    # Get current wave - plugin should handle missing entity_list gracefully
    my $current_wave = 0;
    eval {
        $current_wave = plugin::arena_get_current_wave($zone_entity_list);
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error getting current wave: $@");
        return;
    }
    
    quest::debug("Arena Zone: Current wave retrieved: $current_wave");
    
    if (!$current_wave || $current_wave <= 0) {
        return;
    }
    quest::debug("Arena Zone: Wave validation passed");
    
    # Determine NPC type for appropriate stat template
    # UPDATED: Check name first since we set it immediately during spawning
    my $npc_type = '';
    eval {
        # First check name for immediate type detection
        if ($raw_name =~ /^#/) {
            $npc_type = 'boss';
            quest::debug("Arena Zone: Detected boss by name prefix: '$raw_name'");
        } elsif ($raw_name =~ /^\*/) {
            $npc_type = 'elite';
            quest::debug("Arena Zone: Detected elite by name prefix: '$raw_name'");
        } else {
            # Try tracker lookup as fallback
            $npc_type = plugin::arena_determine_npc_type($npc_id, $raw_name, $npc->GetID());
            quest::debug("Arena Zone: Used plugin detection, result: '$npc_type'");
        }
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error determining NPC type: $@");
        return;
    }
    
    quest::debug("Arena Zone: NPC type determined: $npc_type");
    
    # Apply scaled stats, random appearance, and names based on wave and NPC type
    quest::debug("Arena Zone: Calling arena_apply_scaled_stats for NPC $npc_id, type $npc_type, wave $current_wave");
    
    eval {
        plugin::arena_apply_scaled_stats($npc, $npc_type, $current_wave);
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error applying scaled stats: $@");
        return;
    }
    
    quest::debug("Arena Zone: Finished applying scaled stats to NPC $npc_id");
}

sub EVENT_DEATH_COMPLETE {
    quest::debug("Arena Zone: EVENT_DEATH_COMPLETE triggered");
    
    # Safety checks
    if (!defined($client)) {
        return;
    }
    if (!$client->IsClient()) {
        return;
    }
    quest::debug("Arena Zone: Client validation passed in death event");
    
    # Check if the dead NPC was an arena NPC before checking completion
    my $npc_id = 0;
    my $was_arena_npc = 0;
    
    eval {
        if (defined($npc)) {
            $npc_id = $npc->GetNPCTypeID();
        }
        
        # Only proceed if this was an arena NPC (not excluded)
        if ($npc_id > 0) {
            $was_arena_npc = !plugin::arena_is_excluded_npc($npc_id);
        }
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error getting dead NPC info: $@");
        return;
    }
    
    # Only check wave completion for arena NPCs
    if ($was_arena_npc) {
        quest::debug("Arena Zone: Arena NPC died (ID: $npc_id), checking wave completion");
        
        # Get entity list for completion check
        my $zone_entity_list = undef;
        eval {
            $zone_entity_list = $entity_list;
        };
        
        # If entity_list isn't available, try alternative method
        if (!defined($zone_entity_list)) {
            eval {
                $zone_entity_list = quest::get_entity_list();
            };
        }
        
        # Check wave completion immediately - plugin handles timing issues
        eval {
            plugin::arena_check_wave_completion($client, $zone_entity_list);
        };
        
        if ($@) {
            quest::debug("Arena Zone: Error in wave completion check: $@");
        }
    } else {
        quest::debug("Arena Zone: Non-arena NPC died (ID: $npc_id), skipping completion check");
    }
    
    quest::debug("Arena Zone: Finished death event processing");
}

sub EVENT_ENTER {
    quest::debug("Arena Zone: Player entered arena zone");
    
    # Send welcome message and instructions immediately
    eval {
        if (defined($client) && $client->IsClient()) {
            $client->Message(15, "=== WELCOME TO THE INFINITE ARENA ===");
            $client->Message(15, "Use '#arena help' for a list of commands.");
            $client->Message(15, "Use '#arena start' to begin your challenge!");
            
            # Show current status if they have progress
            my $player_data = plugin::arena_get_player_data($client);
            if ($player_data && $player_data->{current_wave} > 0) {
                my $wave = $player_data->{current_wave};
                my $personal_best = $player_data->{personal_best};
                
                $client->Message(15, "Current Progress: Wave $wave");
                if ($personal_best > 0) {
                    $client->Message(15, "Personal Best: Wave $personal_best");
                }
                $client->Message(15, "Use '#arena status' for detailed information.");
            }
        }
    };
    
    if ($@) {
        quest::debug("Arena Zone: Error in EVENT_ENTER: $@");
    }
}