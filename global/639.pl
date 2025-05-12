my $ownerid;
my $last_timer_reset = 0;

sub has_spell_effect {
    my ($mob, $spell_id) = @_;
    return 0 unless $mob;

    foreach my $buff ($mob->GetBuffs()) {
        next unless $buff;
        my $id = $buff->GetSpellID();
        
        return 1 if $id == $spell_id;
    }

    return 0;
}

sub EVENT_SPAWN {
    $ownerid = $npc->GetOwnerID();

    if ($ownerid) {
        my $owner = $entity_list->GetMobByID($ownerid);
        if ($owner && $owner->IsClient()) {
            my $client = $owner->CastToClient();
            my $level = $client->GetLevel();
            my $flag_rank = plugin::get_flag_rank($client);
            my $buff_id = plugin::get_spell_rank(41887, $flag_rank);  # Turtle Armor

            $npc->SetLevel($level);
            plugin::scale_pet_stats($npc, $level, $flag_rank);       # 🔥 This line was missing
            $npc->AddNimbusEffect(613);
            $npc->ApplySpellBuff($buff_id, 60);
            $client->ApplySpellBuff($buff_id, 60);
        }
    }

    quest::stoptimer("check_squirtle_buff");
    quest::stoptimer("check_group_defense");
    quest::stoptimer("aggro_control");

    quest::settimer("check_squirtle_buff", 30);
    quest::settimer("check_group_defense", 10);
    quest::settimer("aggro_control", 5);

    $npc->SetMana($npc->GetMaxMana());
}


sub EVENT_SAY {
    if ($text =~ /hail/i) {
        if ($client->GetTarget()) {
            my $tar = $client->GetTarget();
            $tar->AddNimbusEffect(613);
            
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_squirtle_buff") {
       

        my $owner = $entity_list->GetMobByID($npc->GetOwnerID());
        if ($owner && $owner->IsClient()) {
            my $client = $owner->CastToClient();
            my $flag_rank = plugin::get_flag_rank($client);
            my $buff_id = plugin::get_spell_rank(41887, $flag_rank);

            

            if (!has_spell_effect($npc, $buff_id)) {
                $npc->ApplySpellBuff($buff_id, 60);
            }

            if (!has_spell_effect($client, $buff_id)) {
                $client->ApplySpellBuff($buff_id, 60);
            }
        }
    }
    elsif ($timer eq "check_group_defense") {
        $npc->SetMana($npc->GetMaxMana());
    }
elsif ($timer eq "aggro_control") {
    if ($npc->IsEngaged()) {
        my $owner = $entity_list->GetMobByID($npc->GetOwnerID());
        if ($owner && $owner->IsClient()) {
            my $rank = plugin::get_flag_rank($owner->CastToClient());
            my $taunt_id = plugin::get_spell_rank(41902, $rank);
            $npc->CastSpell($taunt_id, $npc->GetID());
        }
    }
}
}
