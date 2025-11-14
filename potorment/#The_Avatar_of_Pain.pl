# #The_Avatar_of_*.pl
# PoTorment Avatar — raid-scaled, invulnerable unless flagged via databucket

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

    # Start invulnerable
    $npc->SetInvul(1);
}

sub EVENT_ATTACK {
    return unless $client;

    my $cid = $client->CharacterID();
    my $flag_key = "potor_argan_complete_$cid";
    my $flag_value = quest::get_data($flag_key);

    if (defined $flag_value && $flag_value == 1) {
        # Flagged → vulnerable
        $npc->SetInvul(0);
    } else {
        # Not flagged → invulnerable
        $npc->SetInvul(1);
        $client->Message(13, "An unseen force protects this being from your attacks.");
    }
}