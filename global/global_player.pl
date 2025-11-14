sub EVENT_SAY {
	return unless defined($client) && $client->IsClient();

	return if plugin::handle_autoloot_commands($client, $text);
	return if plugin::handle_arena_commands($client, $text, $entity_list);
	plugin::handle_admin_commands($client, $text, $status, $entity_list);

	if ($text =~ /^#enter$/i) {
		plugin::handle_enter_command($client);
		return;
	} elsif ($text =~ /^#checkflag$/i) {
		plugin::handle_trash_count_command($client);
		return;
	} elsif ($text =~ /^#itemgive$/i) {
		plugin::itemgive();
	} elsif ($text =~ /^#content\s+/i) {
		plugin::update_spawn_content_flags($client, $text);
	} elsif ($text =~ /#model/i) {
		plugin::model_change($text);
	} elsif ($text =~ /^#hotzones\b/i) {
		plugin::hotzones_popup($client);
	} if ($text =~ /#logtargets\s+(on|off)/i) {
		plugin::logtargets_toggle($client, $1);
	} elsif ($text =~ /#logtargets$/i) {
		plugin::logtargets_toggle($client, "");  # status check
	} elsif ($text =~ /^#?augment$/i) {
		plugin::FindAndUseAugmentSealer($client);
		return;
	} elsif ($text =~ /\broles\b/i) {
		plugin::group_roles_check($client);
		return;
	}

	# Handle checkpoint and boss teleports
	return if plugin::handle_checkpoint_and_boss($client, $text, $zoneid);
}

sub EVENT_CLICKDOOR {
    if ($zoneid == 200 && $doorid == 7) {  # CoDecay, chair to Bertox event
        my $qglobals = plugin::var("qglobals");

        if ($qglobals{"pop_cod_preflag"} eq "1" || $client->GetGM()) {
            $client->MovePC(200, 0, -16, -289, 256);  # Move to Bertox event
        } else {
            $client->Message(15, "There is still more work to be done.");
        }
    }
}

sub EVENT_DISCOVER_ITEM {
	my $item_link = quest::varlink($itemid);
	my $item_name = quest::getitemname($itemid);
	my $client_name = $client->GetCleanName();
	
	# Sends a message to the world
	quest::worldwidemessage(15, "$client_name has discovered $item_link!");

	# Sends discovery message to Discord using the "discovery" webhook
	quest::discordsend("discovery", "$client_name has discovered [$item_name](https://shadowedeclipse.com/?a=item&id=$itemid)");
}

sub EVENT_ENTERZONE {
    # Delay pet scaling slightly so zone flags are available
    quest::settimer("delayed_pet_scale", 3);  # 3 seconds should be safe

    if ($zoneid == 36) {
        quest::whisper("Upon entering this dungeon, you get a sense that, although it is already an undesirable place, it has somehow been disturbed even more and unsettled its undead inhabitants.");
    }

    if ($client->GetItemIDAt(3) == 649) {  # Check if mask is still equipped
        quest::settimer("malfoy_insult", 30);  # Restart insult timer on zoning in
        $client->Message(15, "Draco Malfoy's Mask shivers... the presence is still with you.");
    }

	# ===========================================================
    # Plane of Justice (201) — Mavuin Message
    # ===========================================================

	if ($zoneid == 201) {
    	my $text = "You hear shouts from Mavuin to come see him in the jail area.";
    	$client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
	}

    # ===========================================================
    # Plane of Nightmare (204) — Nyseria / Coven presence
    # ===========================================================
    if ($zoneid == 204) {
        my @messages = (
            "The dream bends and fractures... a soft laugh echoes from nowhere.",
            "Your reflection in the dark water smiles when you do not.",
            "A whisper threads through the mist: 'You cannot wake from what you’ve created.'",
            "Cold fingers brush your mind — Nyseria’s voice murmurs, 'Still dreaming of me?'",
            "You feel unseen eyes behind every shadow. The Coven watches. Always."
        );
        my $text = $messages[int(rand(@messages))];
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    # ===========================================================
    # Plane of Disease (205) — lingering corruption
    # ===========================================================
    if ($zoneid == 205) {
        my @messages = (
            "The wind carries whispers... your presence is felt by her.",
            "You feel her gaze — distant, but deliberate.",
            "The air is thick with anger — the sting of your rejection still lingers.",
            "Shadows coil at the edges of your thoughts. She remembers.",
            "Old magic stirs — twisted, patient, and still bound to her will."
        );
        my $text = $messages[int(rand(@messages))];
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    # ===========================================================
    # Plane of Innovation (206) — Nyseria’s will in the machine
    # ===========================================================
    if ($zoneid == 206) {
        my @messages = (
            "The gears whisper in patterns that almost sound like a name — hers.",
            "Every piston shudder feels deliberate, as though the factory itself is breathing.",
            "A static pulse crawls along your skin. Her presence flickers through the circuitry.",
            "Through the hum of machinery, you swear you hear: 'I improved upon creation... by breaking it.'",
            "A dozen glass lenses twist toward you in unison. They have learned to watch through metal now."
        );
        my $text = $messages[int(rand(@messages))];
        $client->SendMarqueeMessage(15, 510, 1, 1, 9000, $text);
    }

    if ($zoneid == 491) {  # Convorteum - Tower of Shattered Lanterns
        my $text = "Lanterns burn with fractured light — extinguish their guardians to ascend the Tower.";
        $client->SendMarqueeMessage(15, 510, 1, 1, 9000, $text);
    }

    # === Haunted Halloween Items (independent slot timers) ===
    # Includes all variants: Temporary + PoP
    my %haunted_slots = (
        1  => [57148, 57150, 600441],  # Ear 1 - Horror
        4  => [57148, 57150, 600441],  # Ear 2 - Horror
        15 => [57147, 57149, 600440],  # Ring 1 - Fear
        16 => [57147, 57149, 600440],  # Ring 2 - Fear
    );

    # Exclude haunted spawning in these zones
    my %no_haunt_zones = map { $_ => 1 } qw(gfaydark thevoida arcstone);
    my $zone_shortname = $zone->GetShortName() || "";
    my $charid = $client->CharacterID();

    # === NEW: Cursed immunity check ===
    my $curse_flag = "CONV_Cursed_Broken_$charid";
    my $cursed_broken = quest::get_data($curse_flag);

    if ($cursed_broken && $cursed_broken == 1) {
        quest::debug("Cursed immunity detected for charid $charid — haunting disabled.");
        return;
    }

    if (exists $no_haunt_zones{$zone_shortname}) {
        quest::debug("Haunted spawn skipped in $zone_shortname (excluded zone).");
        return;
    }

    # Otherwise start independent timers per haunted slot
    foreach my $slot_id (keys %haunted_slots) {
        my $item_id = $client->GetItemIDAt($slot_id);
        next unless (grep { $_ == $item_id } @{$haunted_slots{$slot_id}});

        my $haunt_timer = int(rand(300)) + 1;  # random 1–300 seconds (within 5 min)
        my $haunt_timer_name = "haunted_spawn_slot" . $slot_id . "_" . $charid;
        quest::settimer($haunt_timer_name, $haunt_timer);
    }
}

sub EVENT_LEVEL_UP {
	plugin::scale_player_pet($client);

	my @bots = $entity_list->GetBotListByCharacterID($client->CharacterID());

	foreach my $bot (@bots) {
		if ($bot->GetPet()) {
			plugin::scale_bot_pet($bot);
		}
	}

	plugin::AutoTrain($client, $ulevel);

	if ($ulevel == 30) {
		quest::whisper("Hello $name, I am Elondra Aradune. If you wish to seek extra help along your journey's please come see me in Greater Faydark, outside Felwithe.");
	}
}

sub EVENT_EQUIP_ITEM_CLIENT {
	# Check for Draco Malfoy's Mask in slot 3
	if ($slot_id == 3 && $item_id == 649) {
		quest::settimer("malfoy_insult", 30);
		$client->Message(15, "Draco Malfoy's Mask shivers in your hands... something feels wrong.");
	}

	# Check for item ID 12345 and play MP3
	if ($item_id == 50259) {
		$client->PlayMP3("rr.mp3");
	}
}

sub EVENT_TIMER {
	return if plugin::handle_timer($client, $timer, $entity_list);
	if ($timer eq "delayed_pet_scale") {
		quest::stoptimer("delayed_pet_scale");
		plugin::scale_player_pet($client);

		my @bots = $entity_list->GetBotListByCharacterID($client->CharacterID());

		foreach my $bot (@bots) {
			if ($bot->GetPet()) {
				plugin::scale_bot_pet($bot);
			}
		}
	}
	elsif ($timer eq "malfoy_insult") {
		if ($client->GetItemIDAt(3) == 649) {  # Ensure mask is still equipped
			my $chance = int(rand(100));
			if ($chance < 20) {  # 20% chance to insult
				my @insults = (
					"Draco Malfoy's voice echoes: 'You really think you look good in this? Pathetic.'",
					"Draco Malfoy sneers: 'Filthy Mudblood. How *dare* you wear my legacy?'",
					"You hear Draco’s mocking voice: 'My *father* would *buy* ten of these just to burn them.'",
					"Draco Malfoy whispers: 'How *dare* you mock me by wearing this, you insignificant fool.'",
					"You feel Draco’s presence: 'You could never be worthy of this mask...'",
					"Draco scoffs: 'I don’t lose. This must be some sort of mistake.'",
					"Draco Malfoy sneers: 'Pathetic... you'll never be more than a *sidekick*.'",
					"Draco's voice mocks: 'What a waste of my mask... you don’t deserve to wear it.'",
					"Draco Malfoy hisses: 'You're not worthy of *anything* I leave behind.'",
					"Draco Malfoy's voice echoes: 'My *father* would be ashamed of you.'",
					"Draco Malfoy scoffs: 'You think you're special? You're nothing.'"
				);
				$client->Message(15, $insults[rand @insults]);
			}
		} else {
			quest::stoptimer("malfoy_insult");  # Stop the timer if mask is removed
		}
	}

           elsif ($timer =~ /^haunted_spawn_slot(\d+)_/) {
        my $slot_id = $1;
        my $charid  = $client->CharacterID();
        my $curse_flag = "CONV_Cursed_Broken_$charid";
        my $cursed_broken = quest::get_data($curse_flag);

        # Skip spawns if cursed immunity is active
        if ($cursed_broken && $cursed_broken == 1) {
            quest::stoptimer($timer);
            quest::debug("Cursed immunity active for charid $charid — no haunt spawn.");
            return;
        }

        my $item_id = $client->GetItemIDAt($slot_id);
        my %valid_items = (
            1  => [57148, 57150, 600441],
            4  => [57148, 57150, 600441],
            15 => [57147, 57149, 600440],
            16 => [57147, 57149, 600440],
        );

        if ($valid_items{$slot_id} && grep { $_ == $item_id } @{$valid_items{$slot_id}}) {
            my ($x, $y, $z, $h) = ($client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
            my $spawn_id = quest::spawn2(2251, 0, 0, $x, $y, $z, $h);

            my $tag_timer = "tag_haunt_slot${slot_id}_" . $spawn_id;
            quest::settimer($tag_timer, 1);

            $client->Message(13, "A chilling presence materializes nearby... something follows the cursed item in slot $slot_id.");

            my $haunt_timer = int(rand(300)) + 1;
            my $haunt_timer_name = "haunted_spawn_slot${slot_id}_" . $charid;
            quest::settimer($haunt_timer_name, $haunt_timer);
        } else {
            quest::stoptimer($timer);
        }
    }

elsif ($timer =~ /^tag_haunt_slot(\d+)_/) {
    quest::stoptimer($timer);
    my $spawn_id = $timer;
    $spawn_id =~ s/^tag_haunt_slot\d+_//;
    my $mob = $entity_list->GetMobByID($spawn_id);
    if ($mob) {
        $mob->SetEntityVariable("haunt_charid", $client->CharacterID());
        quest::debug("Haunt tag applied to 2251 for charid " . $client->CharacterID());
    }
}
}

sub EVENT_DEATH {
	quest::stoptimer("malfoy_insult");

	my $char_id = $client->CharacterID();
	return unless $char_id;

	my $dbh = plugin::LoadMysql();
	return unless $dbh;

	my $sql = qq{
		INSERT INTO character_deaths (char_id, death_count)
		VALUES (?, 1)
		ON DUPLICATE KEY UPDATE
			death_count = death_count + 1
	};

	my $sth = $dbh->prepare($sql);
	$sth->execute($char_id);
	$sth->finish();
	$dbh->disconnect();
}

sub EVENT_ZONE {
	quest::stoptimer("malfoy_insult");  # Stop the timer while zoning
}

sub EVENT_DAMAGE_TAKEN {
	my $client = $entity_list->GetClientByID($userid);
	return unless $client;

	$damage = plugin::reduce_npc_damage($userid, $damage, 40665, 50);
	$damage = plugin::reduce_npc_damage($userid, $damage, 40712, 25);
	$damage = plugin::rebirth_reduction($client, $damage);
	$damage = plugin::augment_40820_reduction($client, $damage);

	return int($damage);
}

sub EVENT_GROUP_CHANGE {
	# Handle autoloot group functionality
	plugin::handle_group_change($client);
}

sub EVENT_TARGET_CHANGE {
	return unless ($client && $client->IsClient());

	my $charid = $client->CharacterID();
	return unless (quest::get_data("log_targets_$charid"));

	my $target = $client->GetTarget();
	return unless ($target && $target->IsNPC());

	my $npc_id = $target->CastToNPC()->GetNPCTypeID();
	my $npc_name = $target->GetCleanName();
	my $x = sprintf("%.2f", $target->GetX());
	my $y = sprintf("%.2f", $target->GetY());
	my $z = sprintf("%.2f", $target->GetZ());
	my $h = int($target->GetHeading());

	my $filename = "npc_target_dump.txt";

	if (open(my $fh, '>>', $filename)) {
		print $fh "[$npc_id] $npc_name \@ ($x, $y, $z, $h)\n";
		close($fh);
		$client->Message(15, "[Logged] $npc_name [$npc_id] at ($x, $y, $z, $h)");
	} else {
		$client->Message(13, "[ERROR] Could not write to $filename");
	}
}

sub EVENT_DAMAGE_GIVEN {
plugin::echoing_onslaught_melee($client, $entity_list, $skill_id, $entity_id, $damage);

}

sub EVENT_CAST_BEGIN {
	plugin::echoing_onslaught_spell($client, $entity_list, $spell_id);
	 if ($spell_id == 40726) {
	   
		my $target = $client->GetTarget();
		return unless $target;

		my $char_id = $client->CharacterID();
		my $rebirths = quest::get_data("$char_id-rebirth_total") || 1;

		my $base_damage = 1500;
		my $damage = $base_damage * $rebirths;

		$target->Damage($client, $damage, -1, 0, false);
		$client->Message(13, "Perfect Execution strikes for $damage damage!");
	}
}



# sub EVENT_SPELL_EFFECT {
#      quest::debug("[Perfect Execution] Spell effect triggered by $name (ID: $userid)");      
#     if ($spell_id == 40726) {
	   
#         my $target = $client->GetTarget();
#         return unless $target;

#         my $char_id = $client->CharacterID();
#         my $rebirths = quest::get_data("$char_id-rebirth_total") || 1;

#         my $base_damage = 1500;
#         my $damage = $base_damage * $rebirths;

#         $target->Damage($client, $damage, -1, 0, false);
#         $client->Message(13, "Perfect Execution strikes for $damage damage!");
#     }
# }

sub EVENT_CONNECT {
	my $client = $entity_list->GetClientByID($userid);
	return unless $client;
	plugin::HolidayItems($client);

	my @item_ids = (40502, 45500);  # Items to give

	foreach my $item_id (@item_ids) {
		if (!plugin::check_hasitem($client, $item_id)) {
			$client->SummonItem($item_id);
		}
	}
	
	# Send message only if any items were given
	my $items_given = 0;
	foreach my $item_id (@item_ids) {
		$items_given++ if (!plugin::check_hasitem($client, $item_id));
	}
	
	if ($items_given > 0) {
		$client->Message(15, "You have received special gifts!");
	}
}


sub EVENT_WARP {
    my $zone_blocklist = {
        ponightmare    => 1,
        frozenshadow   => 1,
        templeveeshan  => 1,
        ssratemple     => 1,
        veeshan        => 1,
    };

    # Define legitimate teleporter destinations by zone
    my $teleporter_destinations = {
        frozenshadow => [
            {x => 660,  y => 100, z => 40,  radius => 30},
            {x => 670,  y => 750, z => 75,  radius => 30},
            {x => 170,  y => 755, z => 175, radius => 30},
            {x => -150, y => 160, z => 217, radius => 30},
            {x => -320, y => 725, z => 12,  radius => 30},
            {x => -490, y => 175, z => 2,   radius => 30},
            {x => 10,   y => 65,  z => 310, radius => 30},
        ],
    };

    return if $client->GetGM();

    my $char_id = $client->CharacterID();
    my $donator_flag_key = "warp_donator_flag$char_id";
    my $donator_flag = quest::get_data($donator_flag_key);

    my $zone_name = $zone->GetShortName();
    return unless exists $zone_blocklist->{$zone_name};

    # Check if this warp destination is a legitimate teleporter
    if (exists $teleporter_destinations->{$zone_name}) {
        my $current_x = $client->GetX();
        my $current_y = $client->GetY();
        my $current_z = $client->GetZ();

        foreach my $teleporter (@{$teleporter_destinations->{$zone_name}}) {
            my $distance = sqrt(
                ($current_x - $teleporter->{x})**2 +
                ($current_y - $teleporter->{y})**2 +
                ($current_z - $teleporter->{z})**2
            );

            if ($distance <= $teleporter->{radius}) {
                return; # legit teleporter
            }
        }
    }

    # Block warping in ponightmare ALWAYS, no donator bypass
    my $no_donator_bypass = ($zone_name eq 'ponightmare');

    # Allow donators in other zones
    if (!$no_donator_bypass && defined $donator_flag && $donator_flag == 1) {
        return;
    }

    my $suppress_key = "warp_suppress_$char_id";
    if (quest::get_data($suppress_key)) {
        quest::delete_data($suppress_key);
        return;
    }

    my $warn_key = "warp_warning_given_$char_id";
    my $warned = quest::get_data($warn_key);

    my $zone_id      = $zone->GetZoneID();
    my $instance_id  = $client->GetInstanceID();

    # ============================================================
    # NEW — ponightmare EXCEPTION
    # ============================================================
    if ($zone_name eq 'ponightmare') {

        # FIRST OFFENSE → teleports to your custom location
        if (!defined $warned) {
            quest::set_data($warn_key, 1);
            quest::set_data($suppress_key, 1, 2);

            $client->MovePCInstance($zone_id, $instance_id, -4774, 5198, 4, 0);
            $client->Message(15, "Warp detection triggered — returned to designated Plane of Nightmare location.");
            return;
        }

        # SECOND OFFENSE → kill them
        $client->Message(15, "You were warned. Warping is not allowed in the Plane of Nightmare.");
        #$client->Kill();
        return;
    }
    # ============================================================

    # Normal behavior for non-ponightmare zones
    my $safe_x = $zone->GetSafeX();
    my $safe_y = $zone->GetSafeY();
    my $safe_z = $zone->GetSafeZ();
    my $safe_h = $zone->GetSafeHeading();

    if (defined $warned && $warned == 1) {
        $client->Message(15, "You were warned. Warping is not allowed here.");
        #$client->Kill();
    } 
    else {
        quest::set_data($warn_key, 1);
        quest::set_data($suppress_key, 1, 2);

        $client->MovePCInstance($zone_id, $instance_id, $safe_x, $safe_y, $safe_z, $safe_h);
        $client->Message(15, "Warping is disabled in this zone. Further attempts will result in death.");
    }
}