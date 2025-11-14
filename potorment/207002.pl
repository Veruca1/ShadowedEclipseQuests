# ===========================================================
# TaGrusch_the_Abomination.pl — Plane of Torment
# ===========================================================
# Shadowed Eclipse: Flag Gating + Default Stats + Raid Scaling
# ===========================================================

my $is_boss      = 0;
my $scaled_spawn = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    return if $npc->IsPet();

    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", $is_boss ? 66 : 63);

    plugin::DefaultNPCStats($npc, $entity_list);
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    $npc->SetInvul(1);
    quest::settimer("flag_check", 5);
}

sub EVENT_TIMER {
    if ($timer eq "flag_check") {
        quest::stoptimer("flag_check");

        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            next unless $client;
            my $cid = $client->CharacterID();
            my $flag = quest::get_data("potor_saryrn_key_complete_$cid");
            if (defined $flag && $flag == 1) {
                $npc->SetInvul(0);
                last;
            }
        }
    }
}