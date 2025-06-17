sub EVENT_SAY {
    return unless defined($client) && $client->IsClient();

    # Handle auto-loot and lootfilter related commands
    return if plugin::handle_autoloot_commands($client, $text);
    plugin::handle_admin_commands($client, $text, $status, $entity_list);
    
    
    # Handle #enter to rejoin expedition
    if ($text =~ /^#enter$/i) {
        plugin::handle_enter_command($client);
        return;
    }

    if ($text =~ /^#itemgive$/i) {
    plugin::itemgive();
    }

    # Handle #model command
    if ($text =~ /#model/i) {
        plugin::model_change($text);
    }

    if ($text =~ /^#hotzones\b/i) {
        plugin::hotzones_popup($client);
    }

    # Handle #logtargets on/off and status
    if ($text =~ /#logtargets\s+(on|off)/i) {
        plugin::logtargets_toggle($client, $1);
    }
    elsif ($text =~ /#logtargets$/i) {
        plugin::logtargets_toggle($client, "");  # status check
    }

    # Handle #augment command
    if ($text =~ /^#?augment$/i) {
        plugin::FindAndUseAugmentSealer($client);
        return;
    }

    # Handle checkpoint and boss teleports
    return if plugin::handle_checkpoint_and_boss($client, $text, $zoneid);
}



sub EVENT_DISCOVER_ITEM {
    my $discovereditem = quest::varlink($itemid);
    my $client_name = $client->GetCleanName();
    
    # Sends a message to the world
    quest::worldwidemessage(15, "$client_name has discovered $discovereditem!");

    # Sends discovery message to Discord using the "discovery" webhook
    quest::discordsend("discovery", "$client_name has discovered " . quest::getitemname($itemid) . " (https://shadowedeclipse.com/?a=item&id=" . $itemid . ")");
}

sub EVENT_ENTERZONE {
    # Delay pet scaling slightly so zone flags are available
    quest::settimer("delayed_pet_scale", 3);  # 3 seconds should be safe

    if ($zoneid == 36) {
        quest::message(15, "Upon entering this dungeon, you get a sense that, although it is already an undesirable place, it has somehow been disturbed even more and unsettled its undead inhabitants.");
    }

     if ($client->GetItemIDAt(3) == 649) {  # Check if mask is still equipped
        quest::settimer("malfoy_insult", 30);  # Restart insult timer on zoning in
        $client->Message(15, "Draco Malfoy's Mask shivers... the presence is still with you.");
    }
}

sub EVENT_LEVEL_UP {
    plugin::scale_player_pet($client);
    plugin::AutoTrain($client, $ulevel);

    if ($ulevel == 30) {
        quest::message(14, "Hello $name, I am Elondra Aradune. If you wish to seek extra help along your journey's please come see me in Greater Faydark, outside Felwithe.");
    }
}




sub EVENT_EQUIP_ITEM_CLIENT {
    if ($slot_id == 3 && $item_id == 649) {  # Mask equipped in slot 3
        quest::settimer("malfoy_insult", 30);  # Start insult timer
        $client->Message(15, "Draco Malfoy's Mask shivers in your hands... something feels wrong.");
    }
}


sub EVENT_TIMER {
    if ($timer eq "delayed_pet_scale") {
        quest::stoptimer("delayed_pet_scale");
        plugin::scale_player_pet($client);
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

    # Fixed reductions from buffs
    my $damage = plugin::reduce_npc_damage($userid, $damage, 40665, 50);
    $damage = plugin::reduce_npc_damage($userid, $damage, 40712, 25);

    # AA-based mitigation
    $damage = plugin::rebirth_reduction($client, $damage);

    # Augment-based reduction using supported method
    $damage = plugin::augment_40820_reduction($client, $damage);

    return int($damage);
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

    my $item_id = 40502;  # The item to give

     #Check if the player has the item and give it if they don't
    if (!plugin::check_hasitem($client, $item_id)) {
        $client->SummonItem($item_id);
       $client->Message(15, "You have received a special gift!");
    }
}


sub EVENT_WARP {
    my $zone_blocklist = {
        akheva         => 1,
        frozenshadow   => 1,
        katta          => 1,
        maiden         => 1,
        neriakb        => 1,
        neriakc        => 1,
        neriaka        => 1,
        paludal        => 1,
        shadeweaver    => 1,
        templeveeshan  => 1,
        tenebrous      => 1,
        thedeep        => 1,
        veeshan        => 1,
    };

    return if $client->GetGM();

    my $char_id = $client->CharacterID();
    my $donator_flag_key = "warp_donator_flag$char_id";
    my $donator_flag = quest::get_data($donator_flag_key);

   # quest::debug("Warp Event: Checking $donator_flag_key - Value: " . (defined $donator_flag ? $donator_flag : "undef"));

    if (defined $donator_flag && $donator_flag == 1) {
       # quest::debug("Warp Event: Donator flag is set, skipping enforcement.");
        return;
    }

    my $zone_name = $zone->GetShortName();
    return unless exists $zone_blocklist->{$zone_name};

    my $suppress_key = "warp_suppress_$char_id";
    if (quest::get_data($suppress_key)) {
      #  quest::debug("Warp Event: Suppress flag present, skipping warp check.");
        quest::delete_data($suppress_key);
        return;
    }

    my $safe_x = $zone->GetSafeX();
    my $safe_y = $zone->GetSafeY();
    my $safe_z = $zone->GetSafeZ();
    my $safe_h = $zone->GetSafeHeading();

    my $warn_key = "warp_warning_given_$char_id";
    my $warned = quest::get_data($warn_key);

    if (defined $warned && $warned == 1) {
       # quest::debug("Warp Event: Already warned, killing client.");
        $client->Message(15, "You were warned. Warping is not allowed here.");
        $client->Kill();
    } else {
     #   quest::debug("Warp Event: Warning issued, moving client to safe spot.");
        quest::set_data($warn_key, 1);
        quest::set_data($suppress_key, 1, 2);
        $client->MovePCInstance($zone_name, $client->GetInstanceID(), $safe_x, $safe_y, $safe_z, $safe_h);
        $client->Message(15, "Warping is disabled in this zone. Further attempts will result in death.");
    }
}












