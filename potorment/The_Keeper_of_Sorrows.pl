# Keeper_of_Sorrows.pl — Plane of Torment
# Shadowed Eclipse: Boss Scaling + Flag Gating

my $is_boss      = 0;
my $scaled_spawn = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    return if $npc->IsPet();

    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;

    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 66);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    $npc->SetInvul(1);
}

sub EVENT_ATTACK {
    return unless $client;

    my $cid = $client->CharacterID();
    my $flag = quest::get_data("_potor_tylis_keeper_$cid");

    if (defined $flag && $flag == 1) {
        $npc->SetInvul(0);
    } else {
        $npc->SetInvul(1);
        $client->Message(13, "Your attacks have no effect. A powerful barrier repels you...");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("fallcheck", 6);
    } else {
        quest::stoptimer("fallcheck");
    }
}

sub EVENT_TIMER {
    if ($timer eq "fallcheck") {
        if ($z < -975) {
            my $inst_id = $npc->GetInstanceID();
            if ($inst_id > 0) {
                $npc->MovePCInstance(207, $inst_id, -175, 354, -759.13, 503);
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    #quest::signal(207014, 0);
    quest::spawn2(207066, 0, 0, $x, $y, $z, $h);
}

1;