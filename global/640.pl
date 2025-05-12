sub EVENT_SPAWN {
    $ownerid = $npc->GetOwnerID();

    if ($ownerid) {
        my $owner = $entity_list->GetMobByID($ownerid);
        if ($owner && $owner->IsClient()) {
            my $level = $owner->GetLevel();
            my $client = $owner->CastToClient();
            my $flag_rank = plugin::get_flag_rank($client);
            $npc->SetLevel($level);
            $npc->AddNimbusEffect(448);
            plugin::scale_pet_stats($npc, $level, $flag_rank);
        }
    }

    quest::settimer("pikachu_nuke", 7);
    quest::settimer("pikachu_aura", 30);
}

sub EVENT_TIMER {
    if ($timer eq "pikachu_nuke") {
        plugin::pokemon_pet_spellcast($npc, { context => 'bolt' });
    } elsif ($timer eq "pikachu_aura") {
        #quest::debug("[Pikachu] Casting Aura!");
        plugin::pokemon_pet_spellcast($npc, { context => 'aura' });
    }
}
